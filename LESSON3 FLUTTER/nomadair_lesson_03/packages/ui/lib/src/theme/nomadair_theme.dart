import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// Applies NomadAir design tokens from [nomadair_core] to Flutter ThemeData.
///
/// Consumes [AppColors] from core. Does not depend on [nomadair_data].
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
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
