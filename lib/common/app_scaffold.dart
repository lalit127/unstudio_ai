import 'package:unstudio_ai/common/common_import.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomBar;
  final bool showAppBar;
  final List<Widget>? appBarActions;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.drawer,
    this.bottomBar,
    this.showAppBar = false,
    this.appBarActions,
    this.backgroundColor,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.whiteOff,
      appBar:
          showAppBar
              ? appBar ??
                  AppBar(
                    title: Text(
                      title,
                      style: AppTextStyles(context).display22W700,
                    ),
                    actions: appBarActions,
                  )
              : null,
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      bottomNavigationBar: bottomBar,
    );
  }
}
