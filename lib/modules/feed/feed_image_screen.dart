import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:unstudio_ai/common/app_button.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/controllers/feed_controller.dart';
import 'package:unstudio_ai/modules/feed/widgets/feed_image_grid_widget.dart';
import 'package:unstudio_ai/modules/feed/widgets/feed_model_progress_screen.dart';
import 'package:unstudio_ai/utils/base_extensions.dart';

class FeedImageScreen extends GetView<FeedController> {
  const FeedImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final imageCount = controller.selectedImages.length;
      final canStart = imageCount >= 4;

      return controller.isModelFeed.value
          ? FeedModelProgressScreen(
            progress: controller.progressIndicatorValue.value,
          )
          : Stack(
            children: [
              Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 62,
                    vertical: 90,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Upload at least 4 photos to train your model.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles(context).display20W700,
                      ),
                      FeedImageGrid(
                        selectedImages: controller.selectedImages.value,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 17,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grayLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.gray,
                                ),
                              ),
                            ),
                          ),
                          16.0.toHSB,
                          Expanded(
                            child: AppButton(
                              text: 'Start Training',
                              textStyle: AppTextStyles(
                                context,
                              ).display16W700.copyWith(
                                color:
                                    controller.selectedImages.length < 4
                                        ? AppColors.gray
                                        : AppColors.appWhiteColor,
                              ),
                              buttonColor:
                                  controller.selectedImages.length < 4
                                      ? AppColors.grayLight
                                      : AppColors.secondaryColor,
                              onPressed: () {
                                if (canStart) {
                                  controller.startTraining();
                                } else {
                                  Get.snackbar(
                                    "Minimum Required",
                                    "Please select at least 4 images to start training.",
                                    backgroundColor: Colors.red.shade100,
                                    colorText: Colors.red.shade900,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
    });
  }
}
