import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../router/navigator_routes.dart';
import '../models/destination_model.dart';
import '../state/discovery_state.dart';
import '../widgets/filter_chip_bar_widget.dart';
import '../widgets/destination_card_widget.dart';

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

    return Column(
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
              Text('GoRouter L11 · tab stack isolation',
                style: AppTypography.bodySmall.copyWith(
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
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: cols == 1 ? 1.4 : 0.85,
              ),
              itemCount: dest.length,
              itemBuilder: (_, i) => DestinationCardWidget(
                destination: dest[i],
                // context.go — GoRouter replaces Navigator.pushNamed
                onTap: () => context.go(
                  NavigatorRoutes.destinationDetail,
                  extra: dest[i],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
