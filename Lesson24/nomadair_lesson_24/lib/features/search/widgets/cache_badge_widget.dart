import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

// Small chip shown in the SearchResultsScreen AppBar when
// results came from the Hive cache instead of the network.
class CacheBadge extends StatelessWidget {
  const CacheBadge({super.key, required this.ageSeconds});
  final int ageSeconds;

  String get _ageLabel {
    if (ageSeconds < 60) return '< 1 min ago';
    final m = ageSeconds ~/ 60;
    return '$m min ago';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Semantics(
      label: 'Results from cache, cached $_ageLabel',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical:   2,
        ),
        decoration: BoxDecoration(
          color:        t.successColor.withAlpha(26),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border:       Border.all(color: t.successColor.withAlpha(80)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.bolt,
            size:  12,
            color: t.successColor),
          const SizedBox(width: 3),
          Text('Cached · $_ageLabel',
            style: AppTypography.labelMedium.copyWith(
              color: t.successColor)),
        ]),
      ),
    );
  }
}
