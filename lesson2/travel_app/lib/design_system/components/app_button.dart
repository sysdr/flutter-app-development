import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/typography_tokens.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    final AppTypography appTypography = Theme.of(context).extension<AppTypography>()!;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? appColors.primary : appColors.accent,
        foregroundColor: isPrimary ? appColors.onPrimary : appColors.textPrimary,
        textStyle: appTypography.buttonText,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
