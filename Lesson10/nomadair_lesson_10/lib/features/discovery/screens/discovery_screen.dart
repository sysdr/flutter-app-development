import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../routes/navigator_routes.dart';
import '../models/destination_model.dart';
import '../state/discovery_state.dart';
import '../widgets/filter_chip_bar_widget.dart';
import '../widgets/destination_card_widget.dart';

/// Discovery **screen** — root layout for the discovery feature.
///
/// Lesson 10: placeholder with correct folder structure and state shape.
/// Lesson 13: real content, shimmer loading, PageView.builder feed.
///
/// Naming convention:
///   - [DiscoveryScreen] is a **screen** (owns Scaffold, never reused inside another screen)
///   - Sub-widgets live in discovery/widgets/ with _widget.dart suffix
///   - Route target page lives in discovery/pages/ (added in Lesson 11)
final class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

final class _DiscoveryScreenState extends State<DiscoveryScreen> {
  DiscoveryState _state = const DiscoveryState();

  void _onFilterChanged(DiscoveryFilter f) =>
      setState(() => _state = _state.copyWith(filter: f));

  @override
  Widget build(BuildContext context) {
    final t    = Theme.of(context).extension<NomadThemeExtension>()!;
    final dest = _state.filtered(DiscoveryDestination.samples);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Discover',
                  style: AppTypography.displayLarge.copyWith(
                    color: t.onSurfaceColor)),
                const SizedBox(height: AppSpacing.xs),
                Text('Module 2 · Lesson 10 scaffold',
                  style: AppTypography.bodyMedium.copyWith(
                    color: t.onSurfaceColor.withAlpha(140))),
                const SizedBox(height: AppSpacing.sm),
                FilterChipBarWidget(
                  active: _state.filter,
                  onChanged: _onFilterChanged,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: LayoutBuilder(builder: (ctx, cs) {
              final cols = cs.maxWidth >= 576 ? 2 : 1;
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: cols == 1 ? 1.4 : 0.85,
                ),
                itemCount: dest.length,
                itemBuilder: (_, i) => DestinationCardWidget(
                  destination: dest[i],
                  onTap: () => Navigator.of(context).pushNamed(
                    NavigatorRoutes.destinationDetail,
                    arguments: dest[i],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
