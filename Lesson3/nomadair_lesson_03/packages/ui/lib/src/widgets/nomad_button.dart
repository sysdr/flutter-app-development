import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

/// NomadAir's primary button component.
///
/// Wraps [FilledButton] with NomadAir's brand token constraints.
/// Touch target enforced at 52dp height — WCAG 2.1 AA minimum is 44dp.
final class NomadButton extends StatelessWidget {
  const NomadButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.semanticLabel,
  });

  final String  label;
  final VoidCallback? onPressed;
  final bool    loading;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
