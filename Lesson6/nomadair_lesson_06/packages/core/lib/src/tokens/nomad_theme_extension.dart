import 'package:flutter/material.dart';
import 'app_colors.dart';

final class NomadThemeExtension extends ThemeExtension<NomadThemeExtension> {
  const NomadThemeExtension({
    required this.brandPrimary,
    required this.onSurfaceColor,
    required this.surfaceColor,
    required this.errorColor,
  });

  final Color brandPrimary;
  final Color onSurfaceColor;
  final Color surfaceColor;
  final Color errorColor;

  static const NomadThemeExtension light = NomadThemeExtension(
    brandPrimary: AppColors.blue600,
    onSurfaceColor: AppColors.grey900,
    surfaceColor: AppColors.white,
    errorColor: AppColors.red500,
  );

  static const NomadThemeExtension dark = NomadThemeExtension(
    brandPrimary: AppColors.blue300,
    onSurfaceColor: AppColors.grey200,
    surfaceColor: AppColors.darkSurface,
    errorColor: AppColors.red500,
  );

  @override
  NomadThemeExtension copyWith({
    Color? brandPrimary,
    Color? onSurfaceColor,
    Color? surfaceColor,
    Color? errorColor,
  }) {
    return NomadThemeExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }

  @override
  NomadThemeExtension lerp(NomadThemeExtension? other, double t) {
    if (other == null) return this;
    return NomadThemeExtension(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      onSurfaceColor: Color.lerp(onSurfaceColor, other.onSurfaceColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
    );
  }
}
