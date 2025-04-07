import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/common/status_bar_color_controller.dart';
import 'package:unstudio_ai/config/theme/theme.dart';
import 'package:unstudio_ai/routes/app_pages.dart';
import 'package:unstudio_ai/services/background_service.dart';
import 'package:unstudio_ai/services/network_overlay_service.dart';

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  await localNotifications.initialize(initializationSettings);
  await initializeService();
  await dotenv.load();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StatusBarColorController statusBarColorController = Get.put(
    StatusBarColorController(),
  );

  final Connectivity _connectivity = Connectivity();
  final NetworkOverlayService _overlayService = NetworkOverlayService();
  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  Future<void> _startMonitoring() async {
    await _checkAndHandleInternet(); // Initial check

    _subscription =
        (_connectivity.onConnectivityChanged.listen((result) {
              _checkAndHandleInternet();
            }))
            as StreamSubscription<ConnectivityResult>?;
  }

  Future<void> _checkAndHandleInternet() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final hasInternet = await _hasRealInternetConnection();
    if (!hasInternet) {
      _overlayService.showOverlay(context);
    } else {
      _overlayService.hideOverlay();
    }
  }

  Future<bool> _hasRealInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeMode themeMode = statusBarColorController.themeMode;

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Overlay(
              initialEntries: [OverlayEntry(builder: (_) => child!)],
            );
          },
          home: GetMaterialApp(
            theme: AppThemes.lightTheme,
            navigatorKey: navigatorKey,
            darkTheme: AppThemes.lightTheme,
            themeMode: themeMode,
            title: 'Unstudio Ai',
            localizationsDelegates: const [AppLocalizations.delegate],
            locale: const Locale('en'),
            supportedLocales: const [Locale('en')],
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
