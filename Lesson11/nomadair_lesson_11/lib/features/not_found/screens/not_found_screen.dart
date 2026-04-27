import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../router/navigator_routes.dart';

/// 404 fallback — shown for unmatched or malformed deep links.
///
/// GoRouter [errorBuilder] directs all unknown routes here.
/// In Lesson 25, this also logs to Firebase Crashlytics.
final class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.location});

  /// The unmatched location string.
  final String location;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found'),
        surfaceTintColor: Colors.transparent),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ExcludeSemantics(child: Icon(Icons.error_outline, size: 72,
              color: t.errorColor.withAlpha(160))),
            const SizedBox(height: AppSpacing.lg),
            Text('404 — Not Found', style: AppTypography.headlineLarge.copyWith(
              color: t.onSurfaceColor)),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: t.errorColor.withAlpha(12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: t.errorColor.withAlpha(60))),
              child: Text(location,
                style: AppTypography.monoSmall.copyWith(
                  color: t.errorColor.withAlpha(200)),
                textAlign: TextAlign.center)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This route is not defined in AppRouter.\n'
              'GoRouter.errorBuilder handles all unmatched paths.',
              style: AppTypography.bodySmall.copyWith(
                color: t.onSurfaceColor.withAlpha(160)),
              textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(width: 220,
              child: NomadButton(
                label: 'Go to Discovery',
                icon: Icons.explore,
                semanticLabel: 'Navigate to the Discovery screen',
                onPressed: () => context.go(NavigatorRoutes.discovery),
              )),
          ]),
        ),
      ),
    );
  }
}
