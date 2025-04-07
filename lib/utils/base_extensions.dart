import 'package:flutter/material.dart';

extension ExpandedExtension on Widget {
  Widget get toExpanded {
    return Expanded(child: this);
  }

  Widget get toCenter {
    return Center(
      child: this,
    );
  }

  /// Vertical Padding
  Widget toVPadding(double verticalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: this,
    );
  }

  /// Horizontal Padding
  Widget toHPadding(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: this,
    );
  }

  /// Symmetric Padding
  Widget padSymmetric({required double vertical, required double horizontal}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// All Padding
  Widget toAllPadding(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// All Margin
  Widget toAllMargin(double padding) {
    return Container(
      margin: EdgeInsets.all(padding),
      child: this,
    );
  }
}

extension SpacingExtension on double {
  /// Vertical Space
  Widget get toVSB {
    return SizedBox(
      height: this,
    );
  }

  /// Horizontal Space
  Widget get toHSB {
    return SizedBox(
      width: this,
    );
  }
}

extension StringExtension on String {
  Widget get showNoDataFound {
    return Text(this).toCenter;
  }
}

extension TimeExtension on int {
  int get toHours => this ~/ 3600;
  int get toMinutes => (this % 3600) ~/ 60;
  int get toSeconds => this % 60;
}
