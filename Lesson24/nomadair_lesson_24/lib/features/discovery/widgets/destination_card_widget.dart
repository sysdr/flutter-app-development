import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../models/destination_model.dart';

final class DestinationCardWidget extends StatelessWidget {
  const DestinationCardWidget({
    super.key,
    required this.destination,
    this.onTap,
  });

  final DiscoveryDestination destination;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Semantics(
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
              ExcludeSemantics(
                child: CustomPaint(
                  size: const Size(double.infinity, 120),
                  painter: _SkyPainter(
                    top: Color(destination.skyColorTop),
                    bottom: Color(destination.skyColorBottom),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(destination.city, style: AppTypography.headlineSmall),
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
    );
  }
}

class _SkyPainter extends CustomPainter {
  const _SkyPainter({required this.top, required this.bottom});

  final Color top;
  final Color bottom;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
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
  bool shouldRepaint(_SkyPainter oldDelegate) {
    return oldDelegate.top != top || oldDelegate.bottom != bottom;
  }
}
