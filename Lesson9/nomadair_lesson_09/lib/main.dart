import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'core/services/theme_preference_service.dart';
import 'features/shell/screens/shell_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final svc   = await SharedPrefsThemeService.create();
  final saved = await svc.load();
  runApp(NomadAirApp(svc: svc, initialMode: saved));
}

final class NomadAirApp extends StatefulWidget {
  const NomadAirApp({
    super.key,
    required this.svc,
    required this.initialMode,
  });

  final ThemePreferenceService svc;
  final ThemeMode              initialMode;

  static _NomadAirAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_NomadAirAppState>()!;

  @override
  State<NomadAirApp> createState() => _NomadAirAppState();
}

final class _NomadAirAppState extends State<NomadAirApp> {
  late ThemeMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  ThemeMode get mode    => _mode;
  ThemePreferenceService get svc => widget.svc;

  Future<void> setMode(ThemeMode m) async {
    await widget.svc.save(m);
    if (mounted) setState(() => _mode = m);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title:                   'NomadAir',
    debugShowCheckedModeBanner: false,
    theme:     NomadAirTheme.light(),
    darkTheme: NomadAirTheme.dark(),
    themeMode: _mode,
    home:      const ShellScreen(),
  );
}
