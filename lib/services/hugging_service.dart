import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cross_file/cross_file.dart';
import 'package:fal_client/fal_client.dart';
import 'package:unstudio_ai/models/caption_model.dart';
import 'package:unstudio_ai/models/training_result.dart';
import 'package:unstudio_ai/utils/app_preferences.dart';

class TrainingService {
  final FalClient _falClient;

  TrainingService(String falApiKey)
    : _falClient = FalClient.withCredentials(falApiKey);

  Future<EnqueueResult?> performTraining(
    List<File> imageFiles,
    String hfToken,
  ) async {
    try {
      List<Map<String, String>> trainingData = [];

      for (final file in imageFiles) {
        final CaptionModelResponse? caption = await getCaptionFromHuggingFace(
          file,
          hfToken,
        );
        if (caption != null) {
          final imageUrl = await _falClient.storage.upload(XFile(file.path));
          trainingData.add({
            "image": imageUrl,
            "caption": caption.caption ?? "",
          });
          print("✅ ${file.path.split('/').last}: ${caption.caption}");
        } else {
          print("⚠️ Skipped: ${file.path.split('/').last}");
        }
      }

      if (trainingData.isEmpty) {
        print("❌ No valid data to train.");
        return null;
      }

      print("📦 Submitting the following instance_data:");
      print(jsonEncode(trainingData));

      final job = await _falClient.queue.submit(
        "fal-ai/flux-lora-fast-training",
        input: {
          "instance_data": trainingData,
          "lora_name": "unstudio_ai_model",
          "base_model": "stabilityai/stable-diffusion-2-1",
          "num_steps": 10,
          "trigger_word": "unstudio",
        },
      );

      await saveTrainingResult(job.requestId, trainingData);

      print("🚀 Training submitted: ${job.requestId}");
      print("🔧 Job ID: ${job.requestId}");

      // Only store the requestId in preferences
      await AppPreference.saveJsonToPrefs(
        "last_training_result",
        jsonEncode({"requestId": job.requestId}),
      );

      return job;
    } catch (e, stack) {
      print("❌ Training failed: $e");
      if (e is DioError) {
        print("➡️ Response: ${e.response?.data}");
      }
      print(stack);
    }
    return null;
  }

  Future<CaptionModelResponse?> getCaptionFromHuggingFace(
    File imageFile,
    String hfToken,
  ) async {
    final dio = Dio();
    final bytes = await imageFile.readAsBytes();

    try {
      final response = await dio.post(
        'https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-base',
        data: bytes,
        options: Options(
          headers: {
            "Authorization": "Bearer $hfToken",
            "Content-Type": "application/octet-stream",
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is List && responseData.isNotEmpty) {
          final caption = responseData[0]['generated_text'] ?? '';
          return CaptionModelResponse(caption: caption, imageBytes: bytes);
        }
      } else {
        print('Hugging Face API failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling Hugging Face: $e');
    }

    return null;
  }

  Future<void> saveTrainingResult(
    String requestId,
    List<Map<String, String>> trainingData,
  ) async {
    final List<String> existing =
        await AppPreference.getStringListValuesSF('training_results') ?? [];

    final trainingImages = trainingData.map((e) => e['image']!).toList();

    final trainingResult = TrainingResult(
      loraName: "unstudio_ai_model",
      modelName: "unstudio_ai_model",
      requestId: requestId,
      previewImage: trainingImages.isNotEmpty ? trainingImages.first : null,
      trainingImages: trainingImages,
    );

    final String newEntry = jsonEncode(trainingResult.toJson());
    existing.add(newEntry);
    await AppPreference.addStringListToSF('training_results', existing);
  }

  Future<List<TrainingResult>> getTrainingResults() async {
    final List<String> storedList =
        await AppPreference.getStringListValuesSF('training_results') ?? [];

    return storedList.map((jsonStr) {
      final Map<String, dynamic> map = jsonDecode(jsonStr);
      return TrainingResult.fromJson(map);
    }).toList();
  }
}
