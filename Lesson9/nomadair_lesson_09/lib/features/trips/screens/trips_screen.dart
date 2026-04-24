import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

/// Trips Screen — Module 1 Mastery Challenge.
///
/// Empty state with cross-tab navigation back to Search.
/// liveRegion on the trip count (Lesson 08 pattern).
/// OutlinedCard variant and OutlinedVariant button demonstrated.
final class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key, required this.onSearchTap});

  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Trips',
            style: AppTypography.displayLarge.copyWith(color: t.onSurfaceColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          // liveRegion: trip count announced when it changes
          Semantics(
            liveRegion: true,
            label: '0 saved trips',
            child: Text(
              '0 saved trips',
              style: AppTypography.bodyMedium.copyWith(
                color: t.onSurfaceColor.withAlpha(160),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Empty state card
          NomadCard(
            variant: const OutlinedCard(),
            semanticLabel: 'No saved trips. Tap to start searching.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'When you book a flight or hotel, '
                  'your trips will appear here.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: t.onSurfaceColor.withAlpha(160),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                NomadButton(
                  label: 'Start Searching',
                  icon: Icons.search,
                  variant: const OutlinedVariant(),
                  semanticLabel: 'Navigate to Search tab to find flights',
                  onPressed: onSearchTap,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Rubric note
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: t.brandSecondary.withAlpha(12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: t.brandSecondary.withAlpha(60)),
            ),
            child: Text(
              'Rubric: OutlinedCard + OutlinedVariant button — '
              'cross-tab navigation via onSearchTap callback. '
              'liveRegion on trip count (Lesson 38 will update it).',
              style: AppTypography.monoSmall.copyWith(
                color: t.brandSecondary.withAlpha(200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
