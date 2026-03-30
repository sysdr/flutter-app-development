import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/typography_tokens.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData.light().copyWith(
      extensions: <ThemeExtension<dynamic>>[
        AppColors.light,
        AppTypography.light,
      ],
      colorScheme: ColorScheme.light(
        primary: AppColors.light.primary,
        onPrimary: AppColors.light.onPrimary,
        surface: AppColors.light.background,
        onSurface: AppColors.light.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.light.primary,
        foregroundColor: AppColors.light.onPrimary,
        titleTextStyle: AppTypography.light.headline1?.copyWith(color: AppColors.light.onPrimary),
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.light.headline1,
        bodyLarge: AppTypography.light.bodyText1,
        labelLarge: AppTypography.light.buttonText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.light.primary,
          foregroundColor: AppColors.light.onPrimary,
          textStyle: AppTypography.light.buttonText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
