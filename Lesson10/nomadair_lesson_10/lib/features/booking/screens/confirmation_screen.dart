import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

/// ConfirmationScreen — placeholder screen.
///
/// L53: Lottie confetti + BookingConfirmed state
final class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConfirmationScreen'),
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child:Icon(Icons.check_circle_outline,size:80,
              color: const Color(0xFF5BAD6F).withAlpha(120))),
            const SizedBox(height: AppSpacing.lg),
            Text('ConfirmationScreen',
              style: AppTypography.headlineLarge.copyWith(
                color: t.onSurfaceColor)),
            const SizedBox(height: AppSpacing.sm),
            Text('booking/screens/',
              style: AppTypography.monoSmall.copyWith(
                color: t.onSurfaceColor.withAlpha(140))),
            const SizedBox(height: AppSpacing.xs),
            Text('L53: Lottie confetti + BookingConfirmed state',
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
