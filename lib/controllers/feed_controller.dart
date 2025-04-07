import 'dart:io';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unstudio_ai/utils/app_preferences.dart';

class FeedController extends GetxController {
  final RxBool isModelFeed = false.obs;
  final RxList<File> selectedImages = <File>[].obs;
  var progressIndicatorValue = 0.0.obs;
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      isModelFeed.value = Get.arguments['isModelFeed'] ?? false;
      progressIndicatorValue.value =
          (await AppPreference.getDoubleFromSF('progressIndicatorValue')) ??
          0.0;
    }
  }

  Future<void> pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images == null || images.isEmpty) return;

    final newImages =
        images
            .map((image) => File(image.path))
            .take(9 - selectedImages.length)
            .toList();
    selectedImages.addAll(newImages);
  }

  Future<void> startTraining() async {
    if (selectedImages.length < 4) {
      Get.snackbar(
        "Minimum Images Required",
        "Please upload at least 4 images.",
      );
      return;
    }

    isLoading.value = true;

    try {
      final service = FlutterBackgroundService();
      final isRunning = await service.isRunning();

      if (!isRunning) {
        await service.startService();
      }
      final hfToken = dotenv.env['HF_TOKEN'];
      final falKey = dotenv.env['FAL_TOKEN'];
      if (hfToken == null) {
        Get.snackbar("Error", "HF_TOKEN not found in .env");
        isLoading.value = false;
        return;
      }

      final imagePaths = selectedImages.map((e) => e.path).toList();
      service.on("training-complete").listen((event) {
        final message = event?["message"] ?? "Done";
        Get.snackbar("Success", message);
        isModelFeed.value = true;
        isLoading.value = false;
      });

      service.invoke("start-training", {
        "imagePaths": imagePaths,
        "hfToken": hfToken,
        "falKey": falKey,
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to start training: $e");
      isLoading.value = false;
    }
  }

  void clearImages() {
    selectedImages.clear();
  }

  void removeImageAt(int index) {
    selectedImages.removeAt(index);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
