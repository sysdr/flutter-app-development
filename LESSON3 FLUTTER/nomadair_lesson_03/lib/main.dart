import 'package:flutter/material.dart';
import 'package:nomadair_ui/ui.dart';

import 'features/package_explorer/screens/package_explorer_screen.dart';

void main() {
  runApp(const NomadAirApp());
}

final class NomadAirApp extends StatelessWidget {
  const NomadAirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NomadAir — Lesson 03',
      debugShowCheckedModeBanner: false,
      theme: NomadAirTheme.light(),
      darkTheme: NomadAirTheme.dark(),
      themeMode: ThemeMode.system,
      home: const PackageExplorerScreen(),
    );
  }
}
