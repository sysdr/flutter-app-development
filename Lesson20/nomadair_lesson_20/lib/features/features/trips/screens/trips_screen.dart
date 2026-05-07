import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../router/navigator_routes.dart';

final class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          'My Trips',
          style: AppTypography.displayLarge.copyWith(color: t.onSurfaceColor),
        ),
        const SizedBox(height: AppSpacing.xl),
        NomadCard(
          variant: const OutlinedCard(),
          child: Column(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.luggage_outlined,
                  size: 64,
                  color: t.onSurfaceColor.withAlpha(80),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No trips yet',
                style: AppTypography.headlineMedium.copyWith(
                  color: t.onSurfaceColor,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              NomadButton(
                label: 'Start Searching',
                icon: Icons.search,
                variant: const OutlinedVariant(),
                onPressed: () => context.go(NavigatorRoutes.search),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
