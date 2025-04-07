import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BounceRightToLeftPageRoute<T> extends CustomTransition {
  BounceRightToLeftPageRoute();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Custom smoother bounce effect using ElasticOut curve
    final customBounceCurve = Curves.elasticOut;

    // Tween for horizontal slide (Right to Center) with bounce
    final offsetTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: customBounceCurve));

    return SlideTransition(
      position: animation.drive(offsetTween),
      child: child,
    );
  }
}
