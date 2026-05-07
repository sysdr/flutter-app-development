import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

final class DiscoveryCardFull extends StatelessWidget {
  const DiscoveryCardFull({
    super.key,
    required this.destination,
    this.onBook,
  });

  final dynamic destination;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey900,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(destination.city as String, style: AppTypography.displayLarge.copyWith(color: AppColors.white)),
          Text(destination.formattedPrice as String, style: AppTypography.headlineMedium.copyWith(color: AppColors.white)),
          if (onBook != null) ...[
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: onBook, child: const Text('Book Now')),
          ],
        ],
      ),
    );
  }
}
