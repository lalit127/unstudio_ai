import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unstudio_ai/common/app_button.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/gen/assets.gen.dart';
import 'package:get/get.dart';
import 'package:unstudio_ai/routes/app_pages.dart';
import 'package:unstudio_ai/utils/base_extensions.dart';

class FeedModelProgressScreen extends StatelessWidget {
  final double progress;

  const FeedModelProgressScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles(context).display20W700,
                  children: [
                    const TextSpan(text: 'Your model is being trained.\n'),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 10,
                        ),
                        child: Text(
                          'You can check the dashboard to see the status.',
                          style: AppTextStyles(
                            context,
                          ).display12W500.copyWith(color: AppColors.gray),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              60.0.toVSB,
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 219,
                            width: 219,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 8,
                              backgroundColor: AppColors.darkGreen,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.uiColor,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            Assets.icons.icTrainProp,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                      12.0.toVSB,
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: AppTextStyles(
                          context,
                        ).display30W400.copyWith(fontSize: 32),
                      ),
                    ],
                  ),
                ),
              ),
              40.0.toVSB,
              AppButton(
                onPressed: () => Get.offAllNamed(Routes.home),
                buttonColor: AppColors.grayLight,
                text: 'Go to Dashboard',
                textStyle: AppTextStyles(context).display16W700,
              ).paddingSymmetric(horizontal: 30),
            ],
          ),
        ),
      ),
    );
  }
}
