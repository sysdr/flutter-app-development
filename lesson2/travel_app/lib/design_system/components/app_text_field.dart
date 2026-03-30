import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';
import '../tokens/typography_tokens.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText = '',
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;
    final AppTypography appTypography = Theme.of(context).extension<AppTypography>()!;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: appTypography.bodyText1?.copyWith(color: appColors.textSecondary),
        hintStyle: appTypography.bodyText1?.copyWith(color: appColors.textSecondary.withValues(alpha: 0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appColors.textSecondary.withValues(alpha: 0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appColors.textSecondary.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: appColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: appTypography.bodyText1?.copyWith(color: appColors.textPrimary),
    );
  }
}
