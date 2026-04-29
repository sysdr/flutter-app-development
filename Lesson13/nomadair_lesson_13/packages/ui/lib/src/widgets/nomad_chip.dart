import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

sealed class ChipVariant { const ChipVariant(); }
final class FilterChipVariant extends ChipVariant { const FilterChipVariant(); }
final class ActionChipVariant extends ChipVariant { const ActionChipVariant(); }

final class NomadChip extends StatelessWidget {
  const NomadChip({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = const FilterChipVariant(),
    this.selected = false,
    this.icon,
    this.semanticLabel,
  });
  final String label;
  final VoidCallback onTap;
  final ChipVariant variant;
  final bool selected;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Semantics(
      label: semanticLabel ?? label,
      selected: switch (variant) {
        FilterChipVariant() => selected,
        ActionChipVariant() => null,
      },
      button: true,
      child: switch (variant) {
        FilterChipVariant() => FilterChip(
          label: Text(label, style: AppTypography.labelMedium),
          avatar: icon != null ? ExcludeSemantics(child: Icon(icon, size: 16)) : null,
          selected: selected,
          onSelected: (_) => onTap(),
          selectedColor: t.brandPrimary.withAlpha(28),
          checkmarkColor: t.brandPrimary,
          side: BorderSide(color: selected ? t.brandPrimary : t.onSurfaceColor.withAlpha(60)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
          backgroundColor: Colors.transparent,
        ),
        ActionChipVariant() => ActionChip(
          label: Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: t.brandPrimary),
          ),
          avatar: icon != null
              ? ExcludeSemantics(child: Icon(icon, size: 16, color: t.brandPrimary))
              : null,
          onPressed: onTap,
          backgroundColor: t.brandPrimary.withAlpha(18),
          side: BorderSide(color: t.brandPrimary.withAlpha(80)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
        ),
      },
    );
  }
}
