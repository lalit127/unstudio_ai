import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unstudio_ai/config/theme/app_colors.dart';
import 'package:unstudio_ai/utils/constants.dart';

class StatusBarColorController extends GetxController {
  Rx<Color> statusBarColor = AppColors.backgroundLight.obs;

  void changeStatusBarColor(String pageTitle) {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle overlayStyle;
      if (pageTitle == Constants.PROFILE) {
        overlayStyle = SystemUiOverlayStyle(
          statusBarColor: AppColors.backgroundLight,
          statusBarIconBrightness: Brightness.dark,
        );
      } else if (pageTitle == Constants.SPLASH) {
        overlayStyle = SystemUiOverlayStyle(
          statusBarColor: AppColors.secondaryColor,
          statusBarIconBrightness: Brightness.light,
        );
      } else {
        overlayStyle = SystemUiOverlayStyle(
          statusBarColor: AppColors.whiteOff,
          statusBarIconBrightness: Brightness.dark,
        );
      }
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    }
    update();
  }

  VoidCallback onBackPress(String pageTitle) {
    return () {
      changeStatusBarColor(pageTitle);
      Get.back();
    };
  }

  ThemeMode themeMode = ThemeMode.dark;
  bool isThemeDark = false;

  void isDark(bool isDark) async {
    try {
      isThemeDark = isDark;
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('darkMode', isDark);
    } catch (error) {
      print("Error saving theme mode: $error");
    }
  }
}
