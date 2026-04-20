import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// NomadAir's text input component.
///
/// All visual states — enabled, focused, error, disabled — are expressed
/// through [InputDecoration] with borders parameterized by [NomadThemeExtension].
///
/// The error state conveys information via [errorText] (text), not color
/// alone — satisfying WCAG 2.1 SC 1.4.1 (Use of Color).
///
/// Usage:
/// ```dart
/// NomadTextField(
///   label: 'Email',
///   hint: 'you@example.com',
///   prefixIcon: Icons.email_outlined,
///   controller: _emailController,
///   error: _emailError,   // null when valid
/// )
/// ```
final class NomadTextField extends StatelessWidget {
  const NomadTextField({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.helperText,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.enabled     = true,
    this.maxLines    = 1,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.semanticLabel,
  });

  /// Floating label shown above the input when focused.
  final String label;

  /// Placeholder text when the field is empty and unfocused.
  final String? hint;

  /// Error message. When non-null, the field renders in its error state.
  /// The message is shown below the field as text — not color alone.
  final String? error;

  /// Helper text shown below the field when [error] is null.
  final String? helperText;

  final TextEditingController? controller;
  final FocusNode?             focusNode;

  /// Leading icon inside the input box.
  final IconData? prefixIcon;

  /// Trailing icon inside the input box.
  final IconData? suffixIcon;

  /// Callback when [suffixIcon] is tapped (e.g. password visibility toggle).
  final VoidCallback? onSuffixTap;

  /// When [true], input characters are replaced with bullets (passwords).
  final bool obscureText;

  /// When [false], the field is visually dimmed and non-interactive.
  final bool enabled;

  final int       maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>?   onChanged;
  final ValueChanged<String>?   onSubmitted;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;

    final borderRadius = BorderRadius.circular(AppSpacing.radiusMd);

    // ── Border for each focus/validation state ────────────────
    final enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: t.onSurfaceColor.withAlpha(60),
      ),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: t.brandPrimary, width: 2),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: t.errorColor),
    );
    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: t.errorColor, width: 2),
    );
    final disabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: t.onSurfaceColor.withAlpha(30),
      ),
    );

    // ── InputDecoration (fully token-driven) ──────────────────
    final decoration = InputDecoration(
      labelText:    label,
      hintText:     hint,
      errorText:    error,
      helperText:   helperText,
      enabled:      enabled,
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: error != null ? t.errorColor : t.onSurfaceColor.withAlpha(180),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: t.onSurfaceColor.withAlpha(100),
      ),
      errorStyle: AppTypography.bodySmall.copyWith(
        color: t.errorColor,
      ),
      helperStyle: AppTypography.bodySmall.copyWith(
        color: t.onSurfaceColor.withAlpha(140),
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: t.onSurfaceColor.withAlpha(160), size: 20)
          : null,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: Icon(suffixIcon, size: 20),
              color: t.onSurfaceColor.withAlpha(160),
              onPressed: onSuffixTap,
              tooltip: 'Toggle field action',
            )
          : null,
      filled:      true,
      fillColor: enabled
          ? t.surfaceColor
          : t.onSurfaceColor.withAlpha(10),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      enabledBorder:      enabledBorder,
      focusedBorder:      focusedBorder,
      errorBorder:        errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      disabledBorder:     disabledBorder,
    );

    return Semantics(
      label: semanticLabel ?? label,
      textField: true,
      enabled: enabled,
      child: TextField(
        controller:    controller,
        focusNode:     focusNode,
        decoration:    decoration,
        obscureText:   obscureText,
        enabled:       enabled,
        maxLines:      obscureText ? 1 : maxLines,
        keyboardType:  keyboardType,
        onChanged:     onChanged,
        onSubmitted:   onSubmitted,
        style: AppTypography.bodyLarge.copyWith(
          color: enabled
              ? t.onSurfaceColor
              : t.onSurfaceColor.withAlpha(100),
        ),
        cursorColor: t.brandPrimary,
      ),
    );
  }
}
