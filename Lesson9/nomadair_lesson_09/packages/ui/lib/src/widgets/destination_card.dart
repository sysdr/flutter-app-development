import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// Destination discovery card for the Discover screen.
///
/// Uses [ColorFilter.mode] with [NomadThemeExtension.imageOverlayColor]
/// for dark-mode image tinting (Lesson 07 pattern).
///
/// Fully accessible: [MergeSemantics] + [Semantics.label] from
/// [DestinationModel.accessibilityLabel] (Lesson 08 pattern).
final class DestinationCard extends StatelessWidget {
  const DestinationCard({
    super.key,
    required this.destination,
    this.onTap,
  });

  final DestinationModel destination;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return MergeSemantics(
      child: Semantics(
        label: destination.accessibilityLabel,
        button: onTap != null,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image area — painted gradient + tinting
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    t.imageOverlayColor, BlendMode.srcATop,
                  ),
                  child: ExcludeSemantics(
                    child: CustomPaint(
                      size: const Size(double.infinity, 140),
                      painter: _GradientPainter(
                        topColor: Color(destination.skyColorTop),
                        bottomColor: Color(destination.skyColorBottom),
                        iataCode: destination.iataCode,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            destination.city,
                            style: AppTypography.headlineSmall,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: t.brandPrimary.withAlpha(18),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull,
                              ),
                              border: Border.all(
                                color: t.brandPrimary.withAlpha(80),
                              ),
                            ),
                            child: Text(
                              destination.iataCode,
                              style: AppTypography.monoSmall.copyWith(
                                color: t.brandPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        destination.tagline,
                        style: AppTypography.bodySmall.copyWith(
                          color: t.onSurfaceColor.withAlpha(160),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        destination.formattedPrice,
                        style: AppTypography.labelLarge.copyWith(
                          color: t.brandPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _GradientPainter extends CustomPainter {
  const _GradientPainter({
    required this.topColor,
    required this.bottomColor,
    required this.iataCode,
  });

  final Color  topColor;
  final Color  bottomColor;
  final String iataCode;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Sky gradient
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [topColor, bottomColor],
        ).createShader(rect),
    );
    // Horizon glow
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.55, size.width, size.height * 0.45),
      Paint()
        ..color = Colors.black.withAlpha(50)
        ..blendMode = BlendMode.darken,
    );
    // IATA code watermark
    final tp = TextPainter(
      text: TextSpan(
        text: iataCode,
        style: TextStyle(
          color: Colors.white.withAlpha(40),
          fontSize: 72,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(size.width - tp.width - 12, size.height / 2 - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(_GradientPainter o) =>
      o.topColor != topColor || o.bottomColor != bottomColor;
}
