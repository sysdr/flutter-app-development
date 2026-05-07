  import 'package:flutter/material.dart';
  import 'package:nomadair_core/core.dart';

  final class ShimmerBox extends StatelessWidget {
    const ShimmerBox({
      super.key,
      required this.animation,
      required this.width,
      required this.height,
      this.borderRadius = AppSpacing.radiusSm,
    });

    final Animation<double> animation;
    final double width;
    final double height;
    final double borderRadius;

    @override
    Widget build(BuildContext context) {
      final dark = Theme.of(context).brightness == Brightness.dark;
      final base = dark ? AppColors.darkElevated : AppColors.grey200;
      final highlight = dark ? const Color(0xFF3A3A4E) : AppColors.grey100;
      return AnimatedBuilder(
        animation: animation,
builder: (context, child) => DecoratedBox(
          decoration: BoxDecoration(
            color: Color.lerp(base, highlight, animation.value)!,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: SizedBox(width: width, height: height),
        ),
      );
    }
  }
