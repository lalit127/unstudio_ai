import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'common_import.dart';

class ShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final Color? baseColor;
  final Color? highLightColor;
  final double? borderRadius;
  final BoxShape? boxShape;
  final double? circleRadius;
  final BoxDecoration? boxDecoration;
  final bool? isLoading;
  final Widget? child;
  final EdgeInsets padding;

  const ShimmerWidget({
    super.key,
    this.height,
    this.width,
    this.color,
    this.baseColor,
    this.boxShape,
    this.borderRadius,
    this.boxDecoration,
    this.circleRadius,
    this.highLightColor,
    this.isLoading,
    this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading == null
        ? Shimmer.fromColors(
          direction: ShimmerDirection.rtl,
          baseColor: baseColor ?? Colors.grey[350]!,
          highlightColor: highLightColor ?? Colors.grey[200]!,
          child:
              boxShape == BoxShape.circle
                  ? CircleAvatar(
                    radius: circleRadius ?? 40.0,
                    backgroundColor: Colors.white,
                  )
                  : Container(
                    height: height ?? 20,
                    width: width ?? 200,
                    decoration:
                        boxDecoration ??
                        BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: color ?? Colors.white,
                          borderRadius: BorderRadius.circular(
                            borderRadius ?? 12,
                          ),
                        ),
                  ),
        ).paddingSymmetric(horizontal: 10)
        : (isLoading ?? false)
        ? Padding(
          padding: padding,
          child: Shimmer.fromColors(
            direction: ShimmerDirection.rtl,
            baseColor: baseColor ?? Colors.grey[350]!,
            highlightColor: highLightColor ?? Colors.grey[200]!,
            child:
                boxShape == BoxShape.circle
                    ? CircleAvatar(
                      radius: circleRadius ?? 40.0,
                      backgroundColor: Colors.white,
                    )
                    : Container(
                      height: height ?? 20,
                      width: width ?? 200,
                      decoration:
                          boxDecoration ??
                          BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: color ?? Colors.white,
                            borderRadius: BorderRadius.circular(
                              borderRadius ?? 12,
                            ),
                          ),
                    ),
          ),
        )
        : child ?? const SizedBox.shrink();
  }
}
