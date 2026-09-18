import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../models/env_check_result.dart';

/// Renders a single environment check as a card row.
///
/// The widget is driven entirely by [EnvCheckResult]. Pattern matching
/// in the build method is exhaustive — the compiler rejects any switch
/// that omits a case.
final class CheckTile extends StatelessWidget {
  const CheckTile({
    super.key,
    required this.result,
  });

  final EnvCheckResult result;

  @override
  Widget build(BuildContext context) {
    // Dart 3.x: record destructuring from an exhaustive switch expression.
    // The compiler verifies all four cases are covered at compile time.
    final (icon, color, subtitle) = switch (result) {
      CheckPending() => (
        Icons.radio_button_unchecked,
        Colors.grey,
        'Waiting...',
      ),
      CheckRunning() => (
        Icons.sync,
        AppColors.info,
        'Running...',
      ),
      CheckPassing(value: final v) => (
        Icons.check_circle,
        AppColors.success,
        v,
      ),
      CheckFailing(error: final e) => (
        Icons.cancel,
        AppColors.error,
        e,
      ),
    };

    final statusLabel = switch (result) {
      CheckPending() => 'pending',
      CheckRunning() => 'running',
      CheckPassing() => 'passed',
      CheckFailing() => 'failed',
    };

    return Semantics(
      label: '${result.name}: $statusLabel',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                excludeSemantics: true,
                child: result is CheckRunning
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: color,
                        ),
                      )
                    : Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      style: AppTypography.labelMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTypography.monoSmall.copyWith(
                        color: color,
                      ),
                    ),
                    // Dart 3.x: if-case pattern — binds `fix` only
                    // when result IS a CheckFailing. No cast required.
                    if (result case CheckFailing(fix: final f)) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Fix: $f',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.warning,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
