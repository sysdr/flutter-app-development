import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

final class PassengerFormScreen extends StatelessWidget {
  const PassengerFormScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(title: const Text('Passengers'),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop())),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ExcludeSemantics(child: Icon(Icons.person_outline, size: 80,
            color: t.brandPrimary.withAlpha(120))),
          const SizedBox(height: AppSpacing.lg),
          Text('PassengerFormScreen', style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
          const SizedBox(height: AppSpacing.xs),
          Text('booking/screens/ · CheckoutBloc L35', style: AppTypography.bodySmall.copyWith(
            color: t.onSurfaceColor.withAlpha(140)),
            textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(width: 200, child: NomadButton(label: 'Back',
            variant: const OutlinedVariant(),
            onPressed: () => context.pop())),
        ]))));
  }
}
