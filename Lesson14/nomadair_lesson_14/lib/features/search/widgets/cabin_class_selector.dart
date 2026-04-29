import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../models/search_criteria.dart';

/// Horizontal chip row for cabin class selection.
///
/// Exactly one chip selected at all times.
/// Scrollable on narrow screens where all chips don't fit.
final class CabinClassSelector extends StatelessWidget {
  const CabinClassSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final CabinClass value;
  final ValueChanged<CabinClass> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cabin Class',
          style: AppTypography.labelLarge.copyWith(
            color: t.onSurfaceColor.withAlpha(160))),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: CabinClass.values.map((cabin) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: NomadChip(
                  label:        cabin.label,
                  variant:      const FilterChipVariant(),
                  selected:     value == cabin,
                  semanticLabel:
                      '${cabin.label} cabin${value == cabin ? ", selected" : ""}',
                  onTap: () => onChanged(cabin),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
