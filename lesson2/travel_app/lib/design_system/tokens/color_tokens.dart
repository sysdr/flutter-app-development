import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
  });

  final Color primary;
  final Color onPrimary;
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;

  static const AppColors light = AppColors(
    primary: Color(0xFF0A84FF),
    onPrimary: Colors.white,
    background: Colors.white,
    textPrimary: Colors.black87,
    textSecondary: Colors.grey,
    accent: Color(0xFFFFCC00),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? background,
    Color? textPrimary,
    Color? textSecondary,
    Color? accent,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      background: Color.lerp(background, other.background, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
