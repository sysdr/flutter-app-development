import 'package:flutter/material.dart';
import 'app_colors.dart';

sealed class WcagLevel {
  const WcagLevel(this.label);
  final String label;
}
final class WcagAAA      extends WcagLevel { const WcagAAA()      : super('AAA'); }
final class WcagAA       extends WcagLevel { const WcagAA()       : super('AA'); }
final class WcagAALarge  extends WcagLevel { const WcagAALarge()  : super('AA Large'); }
final class WcagFail     extends WcagLevel { const WcagFail()     : super('Fail'); }

final class NomadThemeExtension extends ThemeExtension<NomadThemeExtension> {
  const NomadThemeExtension({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandAccent,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.successColor,
    required this.errorColor,
    required this.warningColor,
  });

  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandAccent;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color successColor;
  final Color errorColor;
  final Color warningColor;

  static const NomadThemeExtension light = NomadThemeExtension(
    brandPrimary:   AppColors.blue600,
    brandSecondary: AppColors.green500,
    brandAccent:    AppColors.amber600,
    surfaceColor:   AppColors.white,
    onSurfaceColor: AppColors.grey900,
    successColor:   AppColors.green500,
    errorColor:     AppColors.red500,
    warningColor:   AppColors.amber700,
  );

  static const NomadThemeExtension dark = NomadThemeExtension(
    brandPrimary:   AppColors.blue300,
    brandSecondary: AppColors.green300,
    brandAccent:    AppColors.amber300,
    surfaceColor:   AppColors.darkSurface,
    onSurfaceColor: AppColors.grey200,
    successColor:   AppColors.green300,
    errorColor:     Color(0xFFFF7B72),
    warningColor:   AppColors.amber300,
  );

  @override
  NomadThemeExtension copyWith({
    Color? brandPrimary, Color? brandSecondary, Color? brandAccent,
    Color? surfaceColor, Color? onSurfaceColor,
    Color? successColor, Color? errorColor, Color? warningColor,
  }) => NomadThemeExtension(
    brandPrimary:   brandPrimary   ?? this.brandPrimary,
    brandSecondary: brandSecondary ?? this.brandSecondary,
    brandAccent:    brandAccent    ?? this.brandAccent,
    surfaceColor:   surfaceColor   ?? this.surfaceColor,
    onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
    successColor:   successColor   ?? this.successColor,
    errorColor:     errorColor     ?? this.errorColor,
    warningColor:   warningColor   ?? this.warningColor,
  );

  @override
  NomadThemeExtension lerp(NomadThemeExtension? other, double t) {
    if (other == null) return this;
    return NomadThemeExtension(
      brandPrimary:   Color.lerp(brandPrimary,   other.brandPrimary,   t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandAccent:    Color.lerp(brandAccent,    other.brandAccent,    t)!,
      surfaceColor:   Color.lerp(surfaceColor,   other.surfaceColor,   t)!,
      onSurfaceColor: Color.lerp(onSurfaceColor, other.onSurfaceColor, t)!,
      successColor:   Color.lerp(successColor,   other.successColor,   t)!,
      errorColor:     Color.lerp(errorColor,     other.errorColor,     t)!,
      warningColor:   Color.lerp(warningColor,   other.warningColor,   t)!,
    );
  }
}
