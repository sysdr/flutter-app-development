import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';

import 'features/component_showcase/screens/component_showcase_screen.dart';

void main() => runApp(const NomadAirApp());

final class NomadAirApp extends StatefulWidget {
  const NomadAirApp({super.key});

  static _NomadAirAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_NomadAirAppState>()!;

  @override
  State<NomadAirApp> createState() => _NomadAirAppState();
}

final class _NomadAirAppState extends State<NomadAirApp> {
  ThemeMode _mode = ThemeMode.light;

  void toggleTheme() => setState(
    () => _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
  );

  bool get isDark => _mode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NomadAir — Lesson 05',
      debugShowCheckedModeBanner: false,
      theme: NomadAirTheme.light(),
      darkTheme: NomadAirTheme.dark(),
      themeMode: _mode,
      home: const ComponentShowcaseScreen(),
    );
  }
}
