import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../main.dart';
import '../../discover/screens/discover_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../trips/screens/trips_screen.dart';

/// NomadAir Shell — Module 1 Mastery Challenge deliverable.
///
/// Integrates all Module 1 patterns:
///   - AdaptiveScaffold  (Lesson 06)
///   - NomadThemeExtension toggle + persistence (Lessons 04, 07)
///   - Full Semantics on all nav destinations (Lesson 08)
///   - Cross-tab navigation (Trips → Search)
final class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

final class _ShellScreenState extends State<ShellScreen> {
  int _tabIndex = 0;

  void goToSearch() {
    setState(() => _tabIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app    = NomadAirApp.of(context);

    return AdaptiveScaffold(
      title: 'NomadAir',
      initialIndex: _tabIndex,
      onTabChange: (i) => setState(() => _tabIndex = i),
      actions: [
        Semantics(
          label: isDark ? 'Switch to light theme' : 'Switch to dark theme',
          button: true,
          child: IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            onPressed: () => app.setMode(
              isDark ? ThemeMode.light : ThemeMode.dark,
            ),
          ),
        ),
      ],
      destinations: [
        AdaptiveDestination(
          icon:         Icons.explore_outlined,
          selectedIcon: Icons.explore,
          label:        'Discover',
          semanticLabel: 'Discover tab — browse destinations',
          builder: (_) => const DiscoverScreen(),
        ),
        AdaptiveDestination(
          icon:         Icons.flight_outlined,
          selectedIcon: Icons.flight,
          label:        'Search',
          semanticLabel: 'Search tab — find flights',
          builder: (_) => const SearchScreen(),
        ),
        AdaptiveDestination(
          icon:         Icons.luggage_outlined,
          selectedIcon: Icons.luggage,
          label:        'Trips',
          semanticLabel: 'Trips tab — your saved trips',
          builder: (_) => TripsScreen(onSearchTap: goToSearch),
        ),
      ],
    );
  }
}
