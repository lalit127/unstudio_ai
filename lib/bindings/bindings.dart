import 'package:get/get.dart';
import 'package:unstudio_ai/controllers/auth_controller.dart';
import 'package:unstudio_ai/controllers/feed_controller.dart';
import 'package:unstudio_ai/controllers/home_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class FeedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeedController());
  }
}
