import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/mock_config.dart';
import 'core/services/theme_preference_service.dart';
import 'features/search/providers/search_criteria_notifier.dart';
import 'features/search/providers/flight_search_notifier.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final svc    = await SharedPrefsThemeService.create();
  final saved  = await svc.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchCriteriaNotifier()),
        ChangeNotifierProvider(
          create: (_) =>
              FlightSearchNotifier(MockConfig.flightRepository)),
      ],
      child: NomadAirApp(svc: svc, initialMode: saved)));
}

final class NomadAirApp extends StatefulWidget {
  const NomadAirApp({super.key, required this.svc, required this.initialMode});
  final ThemePreferenceService svc;
  final ThemeMode initialMode;
  static _NomadAirAppState of(BuildContext ctx) =>
      ctx.findAncestorStateOfType<_NomadAirAppState>()!;
  @override State<NomadAirApp> createState() => _NomadAirAppState();
}

final class _NomadAirAppState extends State<NomadAirApp> {
  late ThemeMode _mode;
  @override void initState() { super.initState(); _mode = widget.initialMode; }
  ThemeMode get mode => _mode;
  Future<void> setMode(ThemeMode m) async {
    await widget.svc.save(m);
    if (mounted) setState(() => _mode = m);
  }
  @override Widget build(BuildContext context) => MaterialApp.router(
    title: 'NomadAir',
    debugShowCheckedModeBanner: false,
    theme:     NomadAirTheme.light(),
    darkTheme: NomadAirTheme.dark(),
    themeMode: _mode,
    routerConfig: AppRouter.router);
}
