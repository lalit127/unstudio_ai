import 'package:unstudio_ai/bindings/bindings.dart';
import 'package:unstudio_ai/modules/auth/login_screen.dart';
import 'package:unstudio_ai/modules/auth/sign_up_screen.dart';
import 'package:unstudio_ai/modules/feed/feed_image_screen.dart';
import 'package:unstudio_ai/modules/prompt_generate_image/prompt_generate_screen.dart';
import 'package:unstudio_ai/modules/splash/splash_screen.dart';
import 'package:unstudio_ai/utils/custom_transition.dart';
import 'package:get/get.dart';

import '../modules/home/home_screen.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;
  static const splash = Routes.splash;
  static const signUp = Routes.signUp;
  static const login = Routes.login;
  static const home = Routes.home;
  static const feed = Routes.feed;
  static const promptGenerate = Routes.promptGenerate;

  static final routes = [
    GetPage(name: _Paths.splash, page: () => SplashScreen()),
    GetPage(
      name: _Paths.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      customTransition: BounceRightToLeftPageRoute(),
    ),
    GetPage(
      name: _Paths.signUp,
      page: () => const SignUpScreen(),
      binding: AuthBinding(),
      customTransition: BounceRightToLeftPageRoute(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeScreen(),
      binding: HomeBinding(),
      customTransition: BounceRightToLeftPageRoute(),
    ),
    GetPage(
      name: _Paths.feed,
      page: () => const FeedImageScreen(),
      binding: FeedBinding(),
      customTransition: BounceRightToLeftPageRoute(),
    ),
  ];
}
