import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import '../../../main.dart';
final class AdaptiveShellScaffold extends StatelessWidget {
  const AdaptiveShellScaffold({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;
  @override Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AdaptiveScaffold(
      title: 'NomadAir',
      initialIndex: navigationShell.currentIndex,
      onTabChange: (i) => navigationShell.goBranch(i,
        initialLocation: i == navigationShell.currentIndex),
      actions: [
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => NomadAirApp.of(context).setMode(
            isDark ? ThemeMode.light : ThemeMode.dark)),
      ],
      destinations: [
        AdaptiveDestination(icon:Icons.explore_outlined, selectedIcon:Icons.explore,
          label:'Discover', semanticLabel:'Discover tab', builder:(_)=>navigationShell),
        AdaptiveDestination(icon:Icons.flight_outlined, selectedIcon:Icons.flight,
          label:'Search', semanticLabel:'Search tab', builder:(_)=>navigationShell),
        AdaptiveDestination(icon:Icons.luggage_outlined, selectedIcon:Icons.luggage,
          label:'Trips', semanticLabel:'Trips tab', builder:(_)=>navigationShell),
      ]);
  }
}
