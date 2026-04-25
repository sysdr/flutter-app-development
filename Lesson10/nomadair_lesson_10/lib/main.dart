import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/theme_preference_service.dart';
import 'features/feature_explorer/screens/feature_route_explorer_screen.dart';
import 'features/discovery/screens/discovery_screen.dart';
import 'features/discovery/screens/destination_detail_screen.dart';
import 'features/discovery/models/destination_model.dart';
import 'features/search/screens/search_screen.dart';
import 'features/search/screens/search_results_screen.dart';
import 'features/booking/screens/seat_map_screen.dart';
import 'features/booking/screens/passenger_form_screen.dart';
import 'features/booking/screens/payment_screen.dart';
import 'features/booking/screens/confirmation_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/saved_trips_screen.dart';
import 'features/profile/screens/settings_screen.dart';
import 'routes/navigator_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final svc   = await SharedPrefsThemeService.create();
  final saved = await svc.load();
  runApp(NomadAirApp(svc: svc, initialMode: saved));
}

final class NomadAirApp extends StatefulWidget {
  const NomadAirApp({super.key, required this.svc, required this.initialMode});
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
  void initState() { super.initState(); _mode = widget.initialMode; }

  ThemeMode get mode => _mode;
  ThemePreferenceService get svc => widget.svc;

  Future<void> setMode(ThemeMode m) async {
    await widget.svc.save(m);
    if (mounted) setState(() => _mode = m);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NomadAir — Lesson 10',
    debugShowCheckedModeBanner: false,
    theme:     NomadAirTheme.light(),
    darkTheme: NomadAirTheme.dark(),
    themeMode: _mode,
    initialRoute: '/',
    routes: {
      '/': (_) => const FeatureRouteExplorerScreen(),
    },
    onGenerateRoute: (settings) {
      // Named route dispatch — replaced by GoRouter in Lesson 11
      return MaterialPageRoute(
        settings: settings,
        builder: (ctx) => switch (settings.name) {
          NavigatorRoutes.discovery =>
            const DiscoveryScreen(),
          NavigatorRoutes.destinationDetail =>
            DestinationDetailScreen(
              destination: settings.arguments as DiscoveryDestination),
          NavigatorRoutes.search =>
            const SearchScreen(),
          NavigatorRoutes.searchResults =>
            const SearchResultsScreen(),
          NavigatorRoutes.seatMap =>
            const SeatMapScreen(),
          NavigatorRoutes.passengerForm =>
            const PassengerFormScreen(),
          NavigatorRoutes.payment =>
            const PaymentScreen(),
          NavigatorRoutes.confirmation =>
            const ConfirmationScreen(),
          NavigatorRoutes.profile =>
            const ProfileScreen(),
          NavigatorRoutes.savedTrips =>
            const SavedTripsScreen(),
          NavigatorRoutes.settings =>
            const SettingsScreen(),
          _ => const _NotFoundScreen(),
        },
      );
    },
  );
}

// Simple 404 fallback — replaced by GoRouter's errorBuilder in Lesson 11
final class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Not Found')),
    body: const Center(child: Text('Route not found — GoRouter in Lesson 11')));
}
