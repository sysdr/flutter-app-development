import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../deep_links/deep_link_handler.dart';
import '../features/discovery/models/destination_model.dart';
import '../features/discovery/screens/discovery_screen.dart';
import '../features/discovery/screens/destination_detail_screen.dart';
import '../features/search/models/search_criteria.dart';
import '../features/search/screens/search_screen.dart';
import '../features/search/screens/search_results_screen.dart';
import '../features/trips/screens/trips_screen.dart';
import '../features/booking/screens/seat_map_screen.dart';
import '../features/booking/screens/passenger_form_screen.dart';
import '../features/booking/screens/payment_screen.dart';
import '../features/booking/screens/confirmation_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/shell/screens/adaptive_shell_scaffold.dart';
import '../features/not_found/screens/not_found_screen.dart';
import 'navigator_routes.dart';

/// NomadAir AppRouter — Lesson 12: deep link support added.
///
/// Changes from Lesson 11:
///   1. /search accepts ?from= and ?to= query parameters
///      for pre-filling the SearchScreen from deep links.
///   2. /discovery/detail accepts ?iata= for destination deep links.
///   3. Cold start: [initialLocation] is derived synchronously from
///      [ui.PlatformDispatcher.defaultRouteName] (the intent URI from the
///      engine) so the first frame matches the deep link — no Discovery
///      flash. Warm start continues to use Flutter's navigation channel.
abstract final class AppRouter {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  /// Intent URI from the embedder (Android/iOS), available before [runApp].
  static String _initialLocationFromEngine() {
    final raw = ui.PlatformDispatcher.instance.defaultRouteName.trim();
    if (raw.isEmpty || raw == '/') {
      return NavigatorRoutes.discovery;
    }
    final uri = Uri.tryParse(raw);
    if (uri == null) {
      return NavigatorRoutes.discovery;
    }
    final translated = DeepLinkHandler.translate(uri);
    if (translated != null) {
      return translated;
    }
    // Engine may pass an internal path already (e.g. /search?from=BOM&to=DXB).
    if (raw.startsWith('/')) {
      return raw;
    }
    return NavigatorRoutes.discovery;
  }

  static final GoRouter router = GoRouter(
    initialLocation: _initialLocationFromEngine(),
    debugLogDiagnostics: true,

    redirect: (BuildContext context, GoRouterState state) {
      final protected =
          state.matchedLocation.startsWith('/profile');
      if (protected && !isLoggedIn.value) {
        return NavigatorRoutes.discovery;
      }
      return null;
    },

    errorBuilder: (context, state) => NotFoundScreen(
      location: state.uri.toString(),
    ),

    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdaptiveShellScaffold(navigationShell: navigationShell),
        branches: [
          // ── Branch 0: Discovery ──────────────────────────────
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.discovery,
              builder: (context, state) => const DiscoveryScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (context, state) {
                    // Support two ways to arrive:
                    // 1. context.go(path, extra: dest) — from tap
                    // 2. ?iata=DXB — from deep link
                    final extra = state.extra;
                    if (extra is DiscoveryDestination) {
                      return DestinationDetailScreen(
                          destination: extra);
                    }
                    // Deep link: look up by IATA code
                    final iata =
                        state.uri.queryParameters['iata'] ?? '';
                    final dest = DiscoveryDestination.samples
                        .where((d) => d.iataCode == iata.toUpperCase())
                        .firstOrNull;
                    if (dest == null) {
                      return NotFoundScreen(
                        location: 'Destination $iata not found');
                    }
                    return DestinationDetailScreen(destination: dest);
                  },
                ),
              ],
            ),
          ]),

          // ── Branch 1: Search ─────────────────────────────────
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.search,
              builder: (context, state) {
                // Deep link query params for pre-filling the form
                final from = state.uri.queryParameters['from'];
                final to   = state.uri.queryParameters['to'];
                return SearchScreen(
                  initialOrigin:      from,
                  initialDestination: to,
                );
              },
              routes: [
                GoRoute(
                  path: 'results',
                  builder: (context, state) {
                    final criteria =
                        state.extra as SearchCriteria?;
                    return SearchResultsScreen(criteria: criteria);
                  },
                ),
              ],
            ),
          ]),

          // ── Branch 2: Trips ──────────────────────────────────
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.trips,
              builder: (context, state) => TripsScreen(
                onSearchTap: () =>
                    context.go(NavigatorRoutes.search)),
            ),
          ]),
        ],
      ),

      // ── Booking ────────────────────────────────────────────────
      GoRoute(
        path: NavigatorRoutes.seatMap,
        builder: (context, state) => const SeatMapScreen(),
        routes: [
          GoRoute(path: 'passengers',
            builder: (_, __) => const PassengerFormScreen(),
            routes: [GoRoute(path: 'payment',
              builder: (_, __) => const PaymentScreen(),
              routes: [GoRoute(path: 'confirmation',
                builder: (_, __) => const ConfirmationScreen())])]),
        ],
      ),

      // ── Profile ────────────────────────────────────────────────
      GoRoute(
        path: NavigatorRoutes.profile,
        builder: (_, __) => const ProfileScreen(),
        routes: [GoRoute(path: 'settings',
          builder: (_, __) => const SettingsScreen())],
      ),
    ],
  );
}
