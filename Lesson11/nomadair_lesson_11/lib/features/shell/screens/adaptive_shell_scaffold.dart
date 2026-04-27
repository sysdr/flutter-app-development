import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../main.dart';
import '../../../router/navigator_routes.dart';

/// Shell scaffold for the three main tabs.
///
/// Wraps [StatefulNavigationShell] in [AdaptiveScaffold].
/// The current tab index comes from GoRouter's [StatefulNavigationShell]
/// — not from local setState. This is the key architectural difference:
/// GoRouter owns the tab state, not the widget.
///
/// When [navigationShell.currentIndex] changes (user taps a tab),
/// GoRouter's [StatefulShellRoute] switches the active branch navigator
/// and preserves each branch's back stack independently.
final class AdaptiveShellScaffold extends StatelessWidget {
  const AdaptiveShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AdaptiveScaffold(
      title: 'NomadAir',
      initialIndex: navigationShell.currentIndex,
      // Tab change: GoRouter's goBranch preserves each tab's stack
      onTabChange: (index) =>
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
      actions: [
        Semantics(
          label: isDark ? 'Switch to light theme' : 'Switch to dark theme',
          button: true,
          child: IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            onPressed: () => NomadAirApp.of(context).setMode(
              isDark ? ThemeMode.light : ThemeMode.dark),
          ),
        ),
      ],
      destinations: [
        AdaptiveDestination(
          icon: Icons.explore_outlined,
          selectedIcon: Icons.explore,
          label: 'Discover',
          semanticLabel: 'Discover tab',
          builder: (_) => navigationShell,
        ),
        AdaptiveDestination(
          icon: Icons.flight_outlined,
          selectedIcon: Icons.flight,
          label: 'Search',
          semanticLabel: 'Search tab',
          builder: (_) => navigationShell,
        ),
        AdaptiveDestination(
          icon: Icons.luggage_outlined,
          selectedIcon: Icons.luggage,
          label: 'Trips',
          semanticLabel: 'Trips tab',
          builder: (_) => navigationShell,
        ),
      ],
    );
  }
}
