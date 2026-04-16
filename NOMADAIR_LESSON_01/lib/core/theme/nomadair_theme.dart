import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Applies NomadAir design tokens to Flutter's [ThemeData].
///
/// Both [light] and [dark] variants are derived from the same
/// seed colour. The seed-based colour scheme means every tonal
/// surface (container, on-container, surface tint) is computed
/// consistently without manual colour overrides.
abstract final class NomadAirTheme {
  static ThemeData light() => _base(Brightness.light).copyWith(
    scaffoldBackgroundColor: AppColors.backgroundLight,
  );

  static ThemeData dark() => _base(Brightness.dark).copyWith(
    scaffoldBackgroundColor: AppColors.backgroundDark,
  );

  static ThemeData _base(Brightness brightness) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandPrimary,
      brightness: brightness,
    ),
    cardTheme: const CardThemeData(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
