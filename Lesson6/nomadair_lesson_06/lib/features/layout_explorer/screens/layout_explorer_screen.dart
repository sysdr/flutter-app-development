import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../main.dart';

final class LayoutExplorerScreen extends StatefulWidget {
  const LayoutExplorerScreen({super.key});

  @override
  State<LayoutExplorerScreen> createState() => _LayoutExplorerScreenState();
}

final class _LayoutExplorerScreenState extends State<LayoutExplorerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  NavigationStyle? _forceStyle;

  static const _destinations = <AdaptiveDestination>[
    AdaptiveDestination(
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      label: 'Discover',
      builder: _discover,
    ),
    AdaptiveDestination(
      icon: Icons.flight_outlined,
      selectedIcon: Icons.flight,
      label: 'Search',
      builder: _search,
    ),
    AdaptiveDestination(
      icon: Icons.luggage_outlined,
      selectedIcon: Icons.luggage,
      label: 'Trips',
      builder: _trips,
    ),
  ];

  static Widget _discover(BuildContext context) =>
      const _PlaceholderPage(title: 'Discover', icon: Icons.explore);
  static Widget _search(BuildContext context) =>
      const _PlaceholderPage(title: 'Search', icon: Icons.flight);
  static Widget _trips(BuildContext context) =>
      const _PlaceholderPage(title: 'Trips', icon: Icons.luggage);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = Theme.of(context).brightness == Brightness.dark
        ? Icons.light_mode
        : Icons.dark_mode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Explorer'),
        actions: [
          IconButton(
            icon: Icon(icon),
            onPressed: () => NomadAirApp.of(context).toggleTheme(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Adaptive'),
            Tab(text: 'Breakpoints'),
            Tab(text: 'Features'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    ChoiceChip(
                      label: const Text('Auto'),
                      selected: _forceStyle == null,
                      onSelected: (_) => setState(() => _forceStyle = null),
                    ),
                    ChoiceChip(
                      label: const Text('Compact'),
                      selected: _forceStyle is CompactNav,
                      onSelected: (_) => setState(() => _forceStyle = const CompactNav()),
                    ),
                    ChoiceChip(
                      label: const Text('Medium'),
                      selected: _forceStyle is MediumNav,
                      onSelected: (_) => setState(() => _forceStyle = const MediumNav()),
                    ),
                    ChoiceChip(
                      label: const Text('Expanded'),
                      selected: _forceStyle is ExpandedNav,
                      onSelected: (_) => setState(() => _forceStyle = const ExpandedNav()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AdaptiveScaffold(
                  title: 'NomadAir',
                  destinations: _destinations,
                  forceStyle: _forceStyle,
                ),
              ),
            ],
          ),
          const _BreakpointsTab(),
          const _FeaturesTab(),
        ],
      ),
    );
  }
}

final class _BreakpointsTab extends StatelessWidget {
  const _BreakpointsTab();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final style = Breakpoints.styleFor(width);
    final zone = Breakpoints.zoneName(width).toUpperCase();
    final color = switch (style) {
      CompactNav() => const Color(0xFF4A90D9),
      MediumNav() => const Color(0xFF5BAD6F),
      ExpandedNav() => const Color(0xFFE8934A),
    };

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Center(
          child: Column(
            children: [
              Text(
                '${width.toStringAsFixed(1)} dp',
                style: AppTypography.displayLarge.copyWith(color: color),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: color.withAlpha(140)),
                ),
                child: Text(
                  zone,
                  style: AppTypography.labelLarge.copyWith(
                    color: color,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _BreakpointRuler(currentWidth: width),
        const SizedBox(height: AppSpacing.lg),
        _InfoRow(
          label: 'Navigation style',
          value: switch (style) {
            CompactNav() => 'Compact (<600)',
            MediumNav() => 'Medium (600-839)',
            ExpandedNav() => 'Expanded (>=840)',
          },
        ),
        _InfoRow(
          label: 'Navigation widget',
          value: switch (style) {
            CompactNav() => 'NavigationBar',
            MediumNav() => 'NavigationRail (compact)',
            ExpandedNav() => 'NavigationRail (extended)',
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _ThresholdRow(
          label: 'compact -> medium',
          value: '${Breakpoints.compact.toInt()} dp',
          active: width >= Breakpoints.compact,
          color: const Color(0xFF5BAD6F),
        ),
        _ThresholdRow(
          label: 'medium -> expanded',
          value: '${Breakpoints.medium.toInt()} dp',
          active: width >= Breakpoints.medium,
          color: const Color(0xFFE8934A),
        ),
      ],
    );
  }
}

final class _FeaturesTab extends StatelessWidget {
  const _FeaturesTab();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final features = mq.displayFeatures;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _InfoRow(
          label: 'Screen width',
          value: '${mq.size.width.toStringAsFixed(1)} dp',
        ),
        _InfoRow(
          label: 'Screen height',
          value: '${mq.size.height.toStringAsFixed(1)} dp',
        ),
        _InfoRow(
          label: 'Pixel ratio',
          value: mq.devicePixelRatio.toStringAsFixed(2),
        ),
        _InfoRow(
          label: 'Orientation',
          value: mq.orientation.name.toUpperCase(),
        ),
        _InfoRow(
          label: 'Text scale',
          value: mq.textScaler.toString(),
        ),
        _InfoRow(
          label: 'Keyboard inset',
          value: '${mq.viewInsets.bottom.toStringAsFixed(1)} dp',
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text('DISPLAY FEATURES', style: AppTypography.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        if (features.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Text(
              'No display features found. On foldables this shows hinge/cutout data.',
              style: AppTypography.bodyMedium,
            ),
          )
        else
          ...features.map((f) => _DisplayFeatureCard(feature: f)),
      ],
    );
  }
}

final class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final style = Breakpoints.styleFor(width);
    final navLabel = switch (style) {
      CompactNav() => 'NavigationBar',
      MediumNav() => 'NavigationRail (compact)',
      ExpandedNav() => 'NavigationRail (extended)',
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('${width.toInt()} dp', style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(navLabel, style: AppTypography.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

final class _BreakpointRuler extends StatelessWidget {
  const _BreakpointRuler({required this.currentWidth});

  final double currentWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final scale = maxWidth / 1000.0;
        final compactX = Breakpoints.compact * scale;
        final mediumX = Breakpoints.medium * scale;
        final cursorX = (currentWidth * scale).clamp(0.0, maxWidth);
        return SizedBox(
          height: 74,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 22,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 22,
                width: compactX,
                child: Container(height: 30, color: const Color(0xFF4A90D9).withAlpha(40)),
              ),
              Positioned(
                left: compactX,
                top: 22,
                width: mediumX - compactX,
                child: Container(height: 30, color: const Color(0xFF5BAD6F).withAlpha(40)),
              ),
              Positioned(
                left: mediumX,
                top: 22,
                width: maxWidth - mediumX,
                child: Container(height: 30, color: const Color(0xFFE8934A).withAlpha(40)),
              ),
              Positioned(
                left: cursorX - 1,
                top: 8,
                child: Container(width: 2, height: 52, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}

final class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodyMedium)),
          Text(value, style: AppTypography.monoSmall),
        ],
      ),
    );
  }
}

final class _ThresholdRow extends StatelessWidget {
  const _ThresholdRow({
    required this.label,
    required this.value,
    required this.active,
    required this.color,
  });

  final String label;
  final String value;
  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              color: active ? color : Colors.transparent,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.bodySmall)),
          Text(value, style: AppTypography.monoSmall.copyWith(color: color)),
        ],
      ),
    );
  }
}

final class _DisplayFeatureCard extends StatelessWidget {
  const _DisplayFeatureCard({required this.feature});

  final ui.DisplayFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('type: ${feature.type.name}', style: AppTypography.bodyMedium),
          Text('state: ${feature.state.name}', style: AppTypography.bodyMedium),
          Text('bounds: ${feature.bounds}', style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}
