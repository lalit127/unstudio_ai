// ignore_for_file: depend_on_referenced_packages, constant_identifier_names

import 'dart:developer';

import 'package:flutter/foundation.dart';

class Constants {
  static const String PROFILE = 'Profile';
  static const String SPLASH = 'Splash';

  ///Api

  static const String baseUrl = 'http://172.20.10.2:5000';
}

void appPrint(object) {
  if (kDebugMode) {
    log('$object');
  }
}
