import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'features/layout_explorer/screens/layout_explorer_screen.dart';

void main() => runApp(const NomadAirApp());

final class NomadAirApp extends StatefulWidget {
  const NomadAirApp({super.key});

  static NomadAirAppState of(BuildContext context) =>
      context.findAncestorStateOfType<NomadAirAppState>()!;

  @override
  State<NomadAirApp> createState() => NomadAirAppState();
}

final class NomadAirAppState extends State<NomadAirApp> {
  ThemeMode _mode = ThemeMode.light;

  void toggleTheme() => setState(
        () => _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NomadAir Lesson 06',
      debugShowCheckedModeBanner: false,
      theme: NomadAirTheme.light(),
      darkTheme: NomadAirTheme.dark(),
      themeMode: _mode,
      home: const LayoutExplorerScreen(),
    );
  }
}
