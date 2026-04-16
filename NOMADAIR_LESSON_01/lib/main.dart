import 'package:flutter/material.dart';

import 'core/theme/nomadair_theme.dart';
import 'features/env_check/screens/env_check_screen.dart';

void main() {
  runApp(const NomadAirApp());
}

final class NomadAirApp extends StatelessWidget {
  const NomadAirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NomadAir — Lesson 01',
      debugShowCheckedModeBanner: false,
      theme: NomadAirTheme.light(),
      darkTheme: NomadAirTheme.dark(),
      themeMode: ThemeMode.system,
      home: const EnvCheckScreen(),
    );
  }
}
