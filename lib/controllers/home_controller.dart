import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:unstudio_ai/models/training_result.dart';
import 'package:unstudio_ai/routes/app_pages.dart';
import 'package:unstudio_ai/utils/app_preferences.dart';
import 'package:fal_client/fal_client.dart';

class HomeController extends GetxController {
  RxList<TrainingResult> trainingResults = <TrainingResult>[].obs;

  late final FalClient _falClient;

  @override
  void onInit() {
    super.onInit();
    final falApiKey = dotenv.env['FAL_TOKEN'];
    _falClient = FalClient.withCredentials(falApiKey!);
    loadTrainingResults();
  }

  Future<void> loadTrainingResults() async {
    final List<String> storedList =
        await AppPreference.getStringListValuesSF('training_results') ?? [];

    final List<TrainingResult> updatedResults = [];

    for (final jsonStr in storedList) {
      final map = jsonDecode(jsonStr);
      final result = TrainingResult.fromJson(map);

      updatedResults.add(result);
    }

    trainingResults.value = updatedResults;
  }

  Future<void> onTrainModelTap() async {
    final granted = await _requestPermissionIfNeeded();
    if (granted) {
      Get.toNamed(Routes.feed, arguments: {'isModelFeed': false});
    } else {
      Get.snackbar(
        'Permission Required',
        'Please allow notifications to proceed.',
      );
    }
  }

  Future<bool> _requestPermissionIfNeeded() async {
    final sdkInt = await _getAndroidSdkInt();
    if (sdkInt != null && sdkInt >= 33) {
      final status = await Permission.notification.status;
      if (status.isGranted) return true;
      final result = await Permission.notification.request();
      return result.isGranted;
    }
    return true;
  }

  Future<int?> _getAndroidSdkInt() async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    } catch (_) {
      return null;
    }
  }
}
