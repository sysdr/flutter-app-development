import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

// ── Variant sealed class ──────────────────────────────────────────────

/// Selects whether [NomadChip] behaves as a toggleable filter or a tap action.
sealed class ChipVariant { const ChipVariant(); }

/// Toggleable filter chip. Maintains a [selected] state that the parent manages.
final class FilterChipVariant extends ChipVariant { const FilterChipVariant(); }

/// One-shot action chip. Has no selected state — triggers [onTap] once per tap.
final class ActionChipVariant extends ChipVariant { const ActionChipVariant(); }

// ── Component ─────────────────────────────────────────────────────────

/// NomadAir's chip component — used in search filters and action bars.
///
/// Usage (filter):
/// ```dart
/// NomadChip(
///   label: 'Non-stop',
///   variant: const FilterChipVariant(),
///   selected: _nonStopSelected,
///   onTap: () => setState(() => _nonStopSelected = !_nonStopSelected),
/// )
/// ```
///
/// Usage (action):
/// ```dart
/// NomadChip(
///   label: 'Search',
///   icon: Icons.search,
///   variant: const ActionChipVariant(),
///   onTap: _triggerSearch,
/// )
/// ```
final class NomadChip extends StatelessWidget {
  const NomadChip({
    super.key,
    required this.label,
    required this.onTap,
    this.variant  = const FilterChipVariant(),
    this.selected = false,
    this.icon,
    this.semanticLabel,
  });

  final String      label;
  final VoidCallback onTap;
  final ChipVariant variant;

  /// Applies selected visual treatment for [FilterChipVariant].
  /// Ignored for [ActionChipVariant].
  final bool selected;

  final IconData? icon;
  final String?   semanticLabel;

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
            label: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: selected ? t.brandPrimary : t.onSurfaceColor,
              ),
            ),
            avatar: icon != null
                ? Icon(
                    icon,
                    size: 16,
                    color: selected ? t.brandPrimary : t.onSurfaceColor.withAlpha(160),
                  )
                : null,
            selected: selected,
            onSelected: (_) => onTap(),
            selectedColor: t.brandPrimary.withAlpha(28),
            checkmarkColor: t.brandPrimary,
            side: BorderSide(
              color: selected
                  ? t.brandPrimary
                  : t.onSurfaceColor.withAlpha(60),
              width: selected ? 1.5 : 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            backgroundColor: Colors.transparent,
            showCheckmark: true,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 0,
            ),
          ),
        ActionChipVariant() => ActionChip(
            label: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: t.brandPrimary,
              ),
            ),
            avatar: icon != null
                ? Icon(icon, size: 16, color: t.brandPrimary)
                : null,
            onPressed: onTap,
            backgroundColor: t.brandPrimary.withAlpha(18),
            side: BorderSide(color: t.brandPrimary.withAlpha(80)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 0,
            ),
          ),
      },
    );
  }
}
