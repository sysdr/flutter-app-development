import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

// ── Variant sealed class ──────────────────────────────────────────────

/// Selects the visual style of [NomadCard].
sealed class CardVariant { const CardVariant(); }

/// No shadow, blends with scaffold background. Use for grouped list items.
final class FlatCard     extends CardVariant { const FlatCard(); }

/// Subtle shadow elevation=2. Default for standalone content cards.
final class ElevatedCard extends CardVariant { const ElevatedCard(); }

/// Brand-colored border, no shadow. Use to highlight selected or featured content.
final class OutlinedCard extends CardVariant { const OutlinedCard(); }

// ── Component ─────────────────────────────────────────────────────────

/// NomadAir's base content card component.
///
/// Wraps a [Card] with token-driven styling and an optional [InkWell]
/// for tap interaction. All colours resolve from [NomadThemeExtension].
///
/// Usage:
/// ```dart
/// NomadCard(
///   variant: const ElevatedCard(),
///   onTap: () => _navigate(),
///   child: FlightCardContent(flight: flight),
/// )
/// ```
final class NomadCard extends StatelessWidget {
  const NomadCard({
    super.key,
    required this.child,
    this.variant = const ElevatedCard(),
    this.onTap,
    this.padding,
    this.semanticLabel,
  });

  final Widget                child;
  final CardVariant           variant;
  final VoidCallback?         onTap;
  final EdgeInsetsGeometry?   padding;
  final String?               semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;

    final (elevation, border) = switch (variant) {
      FlatCard()     => (0.0, Border.all(color: Colors.transparent)),
      ElevatedCard() => (2.0, Border.all(color: Colors.transparent)),
      OutlinedCard() => (0.0, Border.all(color: t.brandPrimary.withAlpha(120), width: 1.5)),
    };

    return Semantics(
      label: semanticLabel,
      container: true,
      child: Material(
        color: t.surfaceColor,
        elevation: elevation,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.md),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
