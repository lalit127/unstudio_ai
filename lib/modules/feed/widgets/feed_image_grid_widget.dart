import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:unstudio_ai/controllers/feed_controller.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/modules/feed/widgets/feed_model_progress_screen.dart';

class FeedImageGrid extends GetView<FeedController> {
  final List<File> selectedImages;
  final bool? isModelFeed;

  const FeedImageGrid({
    super.key,
    required this.selectedImages,
    this.isModelFeed,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> gridTiles = List.generate(selectedImages.length, (
      index,
    ) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(selectedImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    });

    // Add "Add New" tile if less than 9 images
    if (selectedImages.length < 9) {
      gridTiles.add(
        GestureDetector(
          onTap: controller.pickImages,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.add, size: 40, color: Colors.black45),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: gridTiles,
    );
  }
}
