import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.headline1,
    required this.bodyText1,
    required this.buttonText,
  });

  final TextStyle? headline1;
  final TextStyle? bodyText1;
  final TextStyle? buttonText;

  static const AppTypography light = AppTypography(
    headline1: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
    bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
    buttonText: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
  );

  @override
  AppTypography copyWith({
    TextStyle? headline1,
    TextStyle? bodyText1,
    TextStyle? buttonText,
  }) {
    return AppTypography(
      headline1: headline1 ?? this.headline1,
      bodyText1: bodyText1 ?? this.bodyText1,
      buttonText: buttonText ?? this.buttonText,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) {
      return this;
    }
    return AppTypography(
      headline1: TextStyle.lerp(headline1, other.headline1, t),
      bodyText1: TextStyle.lerp(bodyText1, other.bodyText1, t),
      buttonText: TextStyle.lerp(buttonText, other.buttonText, t),
    );
  }
}
