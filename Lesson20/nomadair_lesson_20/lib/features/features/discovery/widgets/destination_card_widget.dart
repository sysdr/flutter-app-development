import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
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
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Semantics(
      label: destination.accessibilityLabel,
      button: onTap != null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
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
                    color: t.brandPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
