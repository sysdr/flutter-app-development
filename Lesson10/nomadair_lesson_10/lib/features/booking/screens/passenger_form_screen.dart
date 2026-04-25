import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

/// PassengerFormScreen — placeholder screen.
///
/// L35: CheckoutBloc PassengerFilled state
final class PassengerFormScreen extends StatelessWidget {
  const PassengerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PassengerFormScreen'),
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child:Icon(Icons.person_outline,size:80,
              color: const Color(0xFFE8934A).withAlpha(120))),
            const SizedBox(height: AppSpacing.lg),
            Text('PassengerFormScreen',
              style: AppTypography.headlineLarge.copyWith(
                color: t.onSurfaceColor)),
            const SizedBox(height: AppSpacing.sm),
            Text('booking/screens/',
              style: AppTypography.monoSmall.copyWith(
                color: t.onSurfaceColor.withAlpha(140))),
            const SizedBox(height: AppSpacing.xs),
            Text('L35: CheckoutBloc PassengerFilled state',
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
