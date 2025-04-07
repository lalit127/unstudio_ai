import 'package:get/get.dart';
import 'package:unstudio_ai/routes/app_pages.dart';
import 'package:unstudio_ai/utils/app_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await AppPreference.getStringFromSF('access_token');
    if (accessToken != null) {
      Get.offAllNamed(AppPages.home);
    } else {
      Get.offAllNamed(AppPages.signUp);
    }
  }
}
