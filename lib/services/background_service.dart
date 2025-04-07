import 'dart:io';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unstudio_ai/main.dart';
import 'dart:async';
import 'package:unstudio_ai/services/hugging_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
      autoStartOnBoot: false,
      initialNotificationTitle: 'Model Training',
      initialNotificationContent: 'Training is running...',
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: (_) async => true,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "Model Training",
      content: "Training in progress...",
    );
  }

  service.on('start-training').listen((event) async {
    final List<String>? imagePaths = event?['imagePaths']?.cast<String>();
    final String? hfToken = event?['hfToken'];
    final String? falKey = event?['falKey'];

    if (imagePaths == null || imagePaths.isEmpty || hfToken == null) {
      print('[Service] Missing image paths or token');
      service.stopSelf();
      return;
    }

    final files = imagePaths.map((e) => File(e)).toList();
    await TrainingService(falKey!).performTraining(files, hfToken);

    await localNotifications.show(
      0,
      'Training Complete',
      'Your model has been trained successfully!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'training_channel',
          'Model Training',
          channelDescription: 'Training completed',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    service.invoke("training-complete", {
      "message": "Model training is complete!",
    });

    service.stopSelf();
  });
}
