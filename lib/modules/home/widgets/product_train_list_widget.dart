import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/gen/assets.gen.dart';
import 'package:unstudio_ai/models/training_result.dart';
import 'package:unstudio_ai/modules/prompt_generate_image/prompt_generate_screen.dart';
import 'package:unstudio_ai/utils/base_extensions.dart';

class ProductListCard extends StatelessWidget {
  final List<ProductTrainModel> products;
  final String title;
  final TrainingResult result;

  const ProductListCard({
    super.key,
    required this.products,
    required this.title,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyles(context).display20W500),
            8.0.toHSB,
            GestureDetector(
              onTap: () {
                Get.to(PromptGenerationScreen(result: result));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.uiColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Text('Create', style: AppTextStyles(context).display16W500),
                    2.0.toHSB,
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 24),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 23),
            itemBuilder: (context, index) {
              final product = products[index];
              return Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl[index],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget:
                          (context, url, error) =>
                              Image.asset(Assets.images.checker.path),
                    ),
                  ),
                ).paddingOnly(left: index == 0 ? 24 : 0),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProductTrainModel {
  final String name;
  final List<String> imageUrl;

  ProductTrainModel({required this.name, required this.imageUrl});
}
