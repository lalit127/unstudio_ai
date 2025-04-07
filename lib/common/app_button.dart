import 'package:unstudio_ai/common/common_import.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? buttonColor;
  final bool isLoading;
  final double? width;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.buttonColor,
    this.width,
    this.textStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width ?? 300,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor ?? AppColors.buttonColor,
        ),
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotIndicator(color: textColor ?? AppColors.whiteOff),
                    const SizedBox(width: 5),
                    Text(
                      '',
                      style:
                          textStyle ??
                          AppTextStyles(context).display16W500.copyWith(
                            color: textColor ?? AppColors.whiteOff,
                          ),
                    ),
                  ],
                )
                : Text(
                  text,
                  style:
                      textStyle ??
                      AppTextStyles(context).display20W700.copyWith(
                        color: textColor ?? AppColors.whiteOff,
                      ),
                ),
      ),
    );
  }
}

class BottomAppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? buttonColor;
  final bool isLoading;

  const BottomAppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.buttonColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Fixed height for the button
      width: double.infinity, // Full width of the screen
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: buttonColor ?? AppColors.buttonColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // No border radius
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotIndicator(color: textColor ?? AppColors.whiteOff),
                  ],
                )
                : Text(
                  text,
                  style: AppTextStyles(context).display20W700.copyWith(
                    color: textColor ?? AppColors.whiteOff,
                  ),
                ),
      ),
    );
  }
}

class DotIndicator extends StatefulWidget {
  final Color color;

  const DotIndicator({super.key, required this.color});

  @override
  _DotIndicatorState createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<DotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color:
                    _animation.value > index / 3
                        ? widget.color
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
