import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

/// SeatMapScreen — placeholder screen.
///
/// L40–44: CustomPainter seat map engine
final class SeatMapScreen extends StatelessWidget {
  const SeatMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeatMapScreen'),
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child:Icon(Icons.airline_seat_recline_extra,size:80,
              color: const Color(0xFFE8934A).withAlpha(120))),
            const SizedBox(height: AppSpacing.lg),
            Text('SeatMapScreen',
              style: AppTypography.headlineLarge.copyWith(
                color: t.onSurfaceColor)),
            const SizedBox(height: AppSpacing.sm),
            Text('booking/screens/',
              style: AppTypography.monoSmall.copyWith(
                color: t.onSurfaceColor.withAlpha(140))),
            const SizedBox(height: AppSpacing.xs),
            Text('L40–44: CustomPainter seat map engine',
              style: AppTypography.bodySmall.copyWith(
                color: t.onSurfaceColor.withAlpha(120)),
              textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: 200,
              child: NomadButton(
                label: 'Go Back',
                variant: const OutlinedVariant(),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
