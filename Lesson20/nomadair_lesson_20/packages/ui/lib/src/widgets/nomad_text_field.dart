import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

final class NomadTextField extends StatelessWidget {
  const NomadTextField({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.controller,
    this.prefixIcon,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final String? hint;
  final String? error;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<NomadThemeExtension>()!;
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: error,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: theme.onSurfaceColor) : null,
      ),
    );
  }
}
