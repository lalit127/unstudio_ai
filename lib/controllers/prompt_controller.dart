import 'package:get/get.dart';
import 'package:fal_client/fal_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unstudio_ai/models/training_result.dart';

class PromptGenerationController extends GetxController {
  final TrainingResult result;

  PromptGenerationController({required this.result});

  late final FalClient _falClient;
  final prompt = ''.obs;
  final isLoading = false.obs;
  final generatedImageUrl = RxnString();
  final progressValue = 0.0.obs;

  /// Generates an image using the trained model and prompt.
  Future<void> generateImage() async {
    if (prompt.value.trim().isEmpty) return;

    isLoading.value = true;
    try {
      final output = await _falClient.run(
        "fal-ai/flux-lora/inpainting",
        input: {
          "prompt": prompt.value.trim(),
          "lora_model": result.modelName,
          "request_id": result.requestId,
        },
      );

      final data = output.data;

      if (data is Map && data['image_url'] != null) {
        generatedImageUrl.value = data['image_url'];
      } else {
        print('image_url is null or missing in response.');
      }
    } catch (e) {
      print('❌ Failed to generate image: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches current training status and updates progress value.
  Future<String> fetchModelStatus() async {
    isLoading.value = true;
    try {
      final job = await _falClient.queue.status(
        "fal-ai/flux-lora-fast-training",
        requestId: result.requestId!,
        logs: true,
      );

      final status = job.status;
      print('Status: ${job.status}');

      // Convert to progress value
      switch (status) {
        case 'completed':
          progressValue.value = 1.0;
          break;
        case 'generating':
          progressValue.value = 0.7;
          break;
        case 'processing':
          progressValue.value = 0.4;
          break;
        default:
          progressValue.value = 0.2;
      }

      return status;
    } catch (e) {
      print('Failed to fetch model status: $e');
      return 'error';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final falApiKey = dotenv.env['FAL_TOKEN'];
    _falClient = FalClient.withCredentials(falApiKey!);
  }
}
