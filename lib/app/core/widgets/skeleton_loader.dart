import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uifrontendmobile/app/core/values/app_colors.dart';

/// A global wrapper widget to apply shimmer effect for skeleton loading.
/// Wrap any layout composed of [SkeletonShape]s inside this widget.
class SkeletonLoader extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;

  const SkeletonLoader({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.surface,
      highlightColor: highlightColor ?? AppColors.white.withValues(alpha: 0.5),
      period: period,
      child: child,
    );
  }
}

/// A basic building block shape used to construct skeleton layout skeletons.
/// Can be a rectangle with customizable border radius, or a circle.
class SkeletonShape extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const SkeletonShape.rectangle({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  }) : shape = BoxShape.rectangle;

  const SkeletonShape.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 0,
        shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white, // Shimmer acts as a mask over non-transparent widgets.
        shape: shape,
        borderRadius: shape == BoxShape.circle
            ? null
            : BorderRadius.circular(borderRadius),
      ),
    );
  }
}
