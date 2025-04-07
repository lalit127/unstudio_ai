import 'package:flutter/material.dart';
import 'package:unstudio_ai/common/common_import.dart';
import 'package:unstudio_ai/utils/base_extensions.dart';

class NetworkOverlayService {
  OverlayEntry? _overlayEntry;

  void showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    if (overlayState == null) {
      print("[Overlay] No Overlay found in context.");
      return;
    }

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned.fill(
            child: Scaffold(
              body: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        color: AppColors.appWhiteColor,
                        size: 40,
                      ),
                      10.0.toVSB,
                      Text(
                        "No Internet Connection",
                        style: AppTextStyles(context).display20W700.copyWith(
                          color: AppColors.appWhiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
