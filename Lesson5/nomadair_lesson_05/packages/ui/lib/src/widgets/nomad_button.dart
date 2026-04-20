import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

// ── Variant sealed class ──────────────────────────────────────────────

/// Selects which Flutter button primitive [NomadButton] renders.
///
/// [sealed] ensures every switch on [ButtonVariant] is exhaustive.
/// Adding a new variant produces a compile error at every switch site
/// that does not yet handle it — the compiler finds all of them.
///
/// Never use boolean flags (`isOutlined: bool`) as alternatives.
/// A [sealed class] makes illegal combinations unrepresentable.
sealed class ButtonVariant { const ButtonVariant(); }

/// High-emphasis filled button — primary CTA (e.g. "Book Flight").
final class FilledVariant   extends ButtonVariant { const FilledVariant(); }

/// Medium-emphasis outlined button — secondary action (e.g. "Save Trip").
final class OutlinedVariant extends ButtonVariant { const OutlinedVariant(); }

/// Low-emphasis text-only button — destructive or tertiary action.
final class GhostVariant    extends ButtonVariant { const GhostVariant(); }

// ── Component ─────────────────────────────────────────────────────────

/// NomadAir's primary interactive button component.
///
/// Renders one of three Flutter button primitives based on [variant].
/// All visual states (enabled, loading, disabled, hovered, pressed) are
/// resolved via [MaterialStateProperty] against [NomadThemeExtension].
///
/// Usage:
/// ```dart
/// NomadButton(
///   label: 'Book Flight',
///   onPressed: _handleBooking,
/// )
///
/// NomadButton(
///   label: 'Save Trip',
///   variant: const OutlinedVariant(),
///   onPressed: _handleSave,
/// )
/// ```
///
/// Touch target: enforced at [AppSpacing.minTouchTarget] (48 dp).
final class NomadButton extends StatelessWidget {
  const NomadButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant   = const FilledVariant(),
    this.loading   = false,
    this.icon,
    this.semanticLabel,
  });

  /// Button label text.
  final String label;

  /// Callback for tap. Pass [null] to disable.
  final VoidCallback? onPressed;

  /// Visual variant — defaults to [FilledVariant].
  final ButtonVariant variant;

  /// When [true], replaces label with a [CircularProgressIndicator].
  /// Disables [onPressed] regardless of its value.
  final bool loading;

  /// Optional leading icon.
  final IconData? icon;

  /// Screen-reader label. Defaults to [label] when omitted.
  final String? semanticLabel;

  // ── Style builders ───────────────────────────────────────────

  ButtonStyle _filledStyle(NomadThemeExtension t) => ButtonStyle(
    minimumSize: WidgetStateProperty.all(
      const Size(double.infinity, AppSpacing.minTouchTarget),
    ),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return t.brandPrimary.withAlpha(60);
      }
      if (states.contains(WidgetState.pressed)) {
        return t.brandPrimary.withAlpha(200);
      }
      return t.brandPrimary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return AppColors.white.withAlpha(120);
      }
      return AppColors.white;
    }),
    overlayColor: WidgetStateProperty.all(
      AppColors.white.withAlpha(30),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    ),
    elevation: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return 0;
      return 1;
    }),
  );

  ButtonStyle _outlinedStyle(NomadThemeExtension t) => ButtonStyle(
    minimumSize: WidgetStateProperty.all(
      const Size(double.infinity, AppSpacing.minTouchTarget),
    ),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return t.brandPrimary.withAlpha(80);
      }
      return t.brandPrimary;
    }),
    side: WidgetStateProperty.resolveWith((states) {
      final color = states.contains(WidgetState.disabled)
          ? t.brandPrimary.withAlpha(60)
          : states.contains(WidgetState.pressed)
              ? t.brandPrimary
              : t.brandPrimary.withAlpha(180);
      final width = states.contains(WidgetState.pressed) ? 2.0 : 1.5;
      return BorderSide(color: color, width: width);
    }),
    overlayColor: WidgetStateProperty.all(t.brandPrimary.withAlpha(20)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    ),
  );

  ButtonStyle _ghostStyle(NomadThemeExtension t) => ButtonStyle(
    minimumSize: WidgetStateProperty.all(
      const Size(double.infinity, AppSpacing.minTouchTarget),
    ),
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return t.onSurfaceColor.withAlpha(80);
      }
      return t.onSurfaceColor;
    }),
    overlayColor: WidgetStateProperty.all(
      t.onSurfaceColor.withAlpha(12),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    ),
  );

  // ── Child builder ────────────────────────────────────────────

  Widget _child() {
    if (loading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          // color resolved by parent button's foregroundColor
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTypography.labelLarge),
        ],
      );
    }
    return Text(label, style: AppTypography.labelLarge);
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    // loading overrides onPressed — a loading button is never tappable
    final cb = loading ? null : onPressed;

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: cb != null,
      child: switch (variant) {
        FilledVariant()   => FilledButton(
            style: _filledStyle(t),
            onPressed: cb,
            child: _child(),
          ),
        OutlinedVariant() => OutlinedButton(
            style: _outlinedStyle(t),
            onPressed: cb,
            child: _child(),
          ),
        GhostVariant()    => TextButton(
            style: _ghostStyle(t),
            onPressed: cb,
            child: _child(),
          ),
      },
    );
  }
}
