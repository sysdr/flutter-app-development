import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/nomad_theme_extension.dart';

abstract final class NomadAirTheme {
  static ThemeData light() => _base(
        Brightness.light,
        NomadThemeExtension.light,
        AppColors.white,
      );
  static ThemeData dark() => _base(
        Brightness.dark,
        NomadThemeExtension.dark,
        AppColors.darkBackground,
      );

  static ThemeData _base(Brightness b, NomadThemeExtension ext, Color scaffold) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue600, brightness: b),
      scaffoldBackgroundColor: scaffold,
      extensions: <ThemeExtension<dynamic>>[ext],
    );
  }
}
