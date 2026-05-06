import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'shimmer_box.dart';

final class DiscoveryCardShimmer extends StatelessWidget {
  const DiscoveryCardShimmer({super.key, required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(animation: animation, width: double.infinity, height: 120, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(animation: animation, width: double.infinity, height: 18),
                const SizedBox(height: AppSpacing.sm),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ShimmerBox(animation: animation, width: double.infinity, height: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
