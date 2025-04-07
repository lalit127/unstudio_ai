import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:unstudio_ai/controllers/home_controller.dart';
import 'package:unstudio_ai/gen/assets.gen.dart';
import 'package:unstudio_ai/modules/home/widgets/product_train_list_widget.dart';
import 'package:unstudio_ai/routes/app_pages.dart';
import 'package:unstudio_ai/utils/base_extensions.dart';

import '../../common/common_import.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: _buildAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            24.0.toVSB,
            buildTrainNewModel(context).paddingSymmetric(horizontal: 24),
            32.0.toVSB,
            Obx(
              () =>
                  controller.trainingResults.isEmpty
                      ? const SizedBox()
                      : buildTrainListGenerate(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.grayLight,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.icons.icProfile, height: 40),
                const Spacer(),
                SvgPicture.asset(Assets.icons.icMenu),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTrainNewModel(BuildContext context) {
    return GestureDetector(
      onTap: controller.onTrainModelTap,
      child: Container(
        height: 137,
        decoration: BoxDecoration(
          color: AppColors.uiColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Card(
                elevation: 0,
                color: AppColors.appWhiteColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 19,
                    vertical: 14,
                  ),
                  child: SvgPicture.asset(
                    Assets.icons.icTrainProp,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25.0,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Train new model',
                      style: AppTextStyles(context).display17W700,
                    ),
                    const Spacer(),
                    Text(
                      'Upload pictures of your product and we will train a model on it for you.',
                      style: AppTextStyles(context).display13W400,
                      softWrap: true,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTrainListGenerate(BuildContext context) {
    return Obx(() {
      return Column(
        children:
            controller.trainingResults.map((result) {
              return ProductListCard(
                title: result.modelName ?? 'Trained Model',
                result: result,
                products: [
                  ProductTrainModel(
                    name: result.modelName ?? "Model",
                    imageUrl: result.trainingImages,
                  ),
                ],
              );
            }).toList(),
      );
    });
  }
}
