import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

final class DiscoveryCardFull extends StatelessWidget {
  const DiscoveryCardFull({
    super.key,
    required this.city,
    required this.formattedPrice,
    required this.skyColorTop,
    required this.skyColorBottom,
    this.onBook,
  });

  final String city;
  final String formattedPrice;
  final int skyColorTop;
  final int skyColorBottom;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          child: CustomPaint(
            painter: _P(top: Color(skyColorTop), bottom: Color(skyColorBottom)),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withAlpha(200)],
              ),
            ),
          ),
        ),
        Positioned(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(city, style: AppTypography.displayLarge.copyWith(color: AppColors.white)),
              Text(
                formattedPrice,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onBook != null) ...[
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: 160,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.white.withAlpha(230),
                      foregroundColor: AppColors.grey900,
                      minimumSize: const Size(0, AppSpacing.minTouchTarget),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    onPressed: onBook,
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _P extends CustomPainter {
  const _P({required this.top, required this.bottom});
  final Color top;
  final Color bottom;

  @override
  void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    c.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, bottom],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_P o) => o.top != top || o.bottom != bottom;
}
