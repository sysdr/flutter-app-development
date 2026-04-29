import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

import 'shimmer_box.dart';

/// Skeleton placeholder that matches [DestinationCardWidget]'s layout.
///
/// Used during the loading state of [DiscoveryFeedScreen].
/// All shimmer tiles share the same [animation] from the parent's
/// single [AnimationController] — synchronised sweep across all tiles.
///
/// Shape: rounded card with:
///   - tall hero area (same height as real card hero)
///   - city name line (wide)
///   - tagline line (medium width)
///   - price line (narrow)
final class DiscoveryCardShimmer extends StatelessWidget {
  const DiscoveryCardShimmer({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero area placeholder
          ShimmerBox(
            animation:    animation,
            width:        double.infinity,
            height:       120,
            borderRadius: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // City name (full width)
                ShimmerBox(
                  animation:    animation,
                  width:        double.infinity,
                  height:       18,
                  borderRadius: AppSpacing.radiusSm,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Tagline (75% width)
                FractionallySizedBox(
                  widthFactor: 0.75,
                  child: ShimmerBox(
                    animation:    animation,
                    width:        double.infinity,
                    height:       13,
                    borderRadius: AppSpacing.radiusSm,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Price (40% width)
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: ShimmerBox(
                    animation:    animation,
                    width:        double.infinity,
                    height:       16,
                    borderRadius: AppSpacing.radiusSm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
