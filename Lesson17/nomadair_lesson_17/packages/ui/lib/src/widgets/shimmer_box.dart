import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
final class ShimmerBox extends StatelessWidget {
  const ShimmerBox({super.key, required this.animation,
    required this.width, required this.height,
    this.borderRadius = AppSpacing.radiusSm});
  final Animation<double> animation;
  final double width, height, borderRadius;
  @override Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base = dark ? AppColors.darkElevated : AppColors.grey200;
    final hi   = dark ? const Color(0xFF3A3A4E) : AppColors.grey100;
    return AnimatedBuilder(animation: animation,
      builder: (_, __) => CustomPaint(
        size: Size(width, height),
        painter: _P(v: animation.value, base: base, hi: hi,
          r: borderRadius)));
  }
}
class _P extends CustomPainter {
  const _P({required this.v, required this.base, required this.hi,
    required this.r});
  final double v, r; final Color base, hi;
  @override void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    final sweep = v * 4 - 2;
    final g = LinearGradient(
      begin: Alignment(sweep - 1, 0), end: Alignment(sweep + 1, 0),
      colors: [base, hi, base], stops: const [0.0, 0.5, 1.0]);
    c.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)),
      Paint()..shader = g.createShader(rect));
  }
  @override bool shouldRepaint(_P o) =>
    o.v != v || o.base != base || o.hi != hi;
}
