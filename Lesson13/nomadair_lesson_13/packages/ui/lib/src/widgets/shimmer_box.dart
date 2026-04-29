import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// Shimmer skeleton tile driven by a single [Animation<double>].
///
/// One [AnimationController] at the screen level drives ALL shimmer tiles
/// simultaneously — a single animation, multiple tiles. This produces the
/// synchronised sweep that signals "all loading together" to the user.
///
/// The [animation] value runs 0.0 → 1.0. The gradient position maps
/// this to a horizontal sweep from left-of-screen to right-of-screen.
///
/// [shouldRepaint] returns true only when the animation value actually
/// changes. Without this, every [AnimationController] tick repaints
/// every visible shimmer tile — 60 GPU operations per second per tile.
final class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.animation,
    required this.width,
    required this.height,
    this.borderRadius = AppSpacing.radiusSm,
  });

  final Animation<double> animation;
  final double            width;
  final double            height;
  final double            borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base      = isDark ? AppColors.darkElevated : AppColors.grey200;
    final highlight = isDark
        ? const Color(0xFF3A3A4E)
        : AppColors.grey100;

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => CustomPaint(
        size: Size(width, height),
        painter: _ShimmerPainter(
          value:       animation.value,
          base:        base,
          highlight:   highlight,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

final class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({
    required this.value,
    required this.base,
    required this.highlight,
    required this.borderRadius,
  });

  final double value;
  final Color  base;
  final Color  highlight;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Map animation 0→1 to gradient sweep: start at -2, end at +2
    final sweep = value * 4 - 2;
    final gradient = LinearGradient(
      begin: Alignment(sweep - 1, 0),
      end:   Alignment(sweep + 1, 0),
      colors: [base, highlight, base],
      stops:  const [0.0, 0.5, 1.0],
    );
    final rRect = RRect.fromRectAndRadius(
      rect, Radius.circular(borderRadius));
    canvas.drawRRect(
      rRect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) =>
      old.value != value ||
      old.base != base ||
      old.highlight != highlight;
}
