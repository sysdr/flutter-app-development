import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/nomad_theme_extension.dart';

abstract final class NomadAirTheme {
  static ThemeData light() => _base(
    brightness: Brightness.light,
    ext: NomadThemeExtension.light,
    scaffold: AppColors.grey50,
  );

  static ThemeData dark() => _base(
    brightness: Brightness.dark,
    ext: NomadThemeExtension.dark,
    scaffold: AppColors.darkBackground,
  );

  static ThemeData _base({
    required Brightness brightness,
    required NomadThemeExtension ext,
    required Color scaffold,
  }) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue600,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: scaffold,
    extensions: <ThemeExtension<dynamic>>[ext],
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusMd)),
      ),
    ),
  );
}
