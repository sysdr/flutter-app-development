import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
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
    final theme = Theme.of(context).extension<NomadThemeExtension>()!;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(destination.city, style: AppTypography.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                destination.formattedPrice,
                style: AppTypography.labelLarge.copyWith(
                  color: theme.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
