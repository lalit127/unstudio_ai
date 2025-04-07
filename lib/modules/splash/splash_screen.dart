import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/common/loading_indicator.dart';
import 'package:unstudio_ai/controllers/splash_controller.dart';
import 'package:unstudio_ai/gen/assets.gen.dart';
import 'package:unstudio_ai/utils/base_extensions.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController _controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Makes Column size wrap content
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.appLogo.path, height: 120),
            40.0.toVSB,
            LoadingIndicator(color: AppColors.appWhiteColor),
          ],
        ),
      ),
    );
  }
}
