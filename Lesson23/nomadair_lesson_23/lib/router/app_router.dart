import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/discovery/models/destination_model.dart';
import '../features/discovery/screens/discovery_feed_screen.dart';
import '../features/discovery/screens/destination_detail_screen.dart';
import '../features/search/models/flight_result.dart';
import '../features/search/screens/search_screen.dart';
import '../features/search/screens/search_results_screen.dart';
import '../features/search/screens/flight_detail_screen.dart';
import '../features/booking/screens/booking_stub_screen.dart';
import '../features/mastery/screens/mastery_rubric_screen.dart';
import '../features/trips/screens/trips_screen.dart';
import '../features/shell/screens/adaptive_shell_scaffold.dart';
import '../features/not_found/screens/not_found_screen.dart';
import 'navigator_routes.dart';

abstract final class AppRouter {
  /// Used by [DeepLinkHandler] / app_links so intents resolve under Provider scope.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: NavigatorRoutes.discovery,
    errorBuilder: (ctx, state) =>
        NotFoundScreen(location: state.uri.toString()),
    routes: [
      GoRoute(
        path: NavigatorRoutes.bookingStub,
        builder: (_, state) =>
            BookingStubScreen(flight: state.extra as FlightResult?)),
      GoRoute(
        path: NavigatorRoutes.masteryRubric,
        builder: (_, __) => const MasteryRubricScreen()),
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) =>
            AdaptiveShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.discovery,
              builder: (_, __) => const DiscoveryFeedScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (_, state) {
                    final extra = state.extra;
                    if (extra is DiscoveryDestination) {
                      return DestinationDetailScreen(destination: extra);
                    }
                    final ia = state.uri.queryParameters['iata'] ?? '';
                    final d = DiscoveryDestination.samples
                        .where((x) => x.iataCode == ia.toUpperCase())
                        .firstOrNull;
                    return d != null
                        ? DestinationDetailScreen(destination: d)
                        : NotFoundScreen(location: 'Destination $ia');
                  }),
              ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.search,
              builder: (_, state) {
                // Accept params from both query string (deep link)
                // and extra map (DeepLinkHandler pre-fill).
                final qp    = state.uri.queryParameters;
                final extra = state.extra as Map<String, dynamic>?;
                return SearchScreen(
                  initialOrigin:      extra?['from'] ?? qp['from'],
                  initialDestination: extra?['to']   ?? qp['to'],
                  initialDate:        extra?['date'],
                );
              },
              routes: [
                GoRoute(
                  path: 'results',
                  builder: (_, __) => const SearchResultsScreen(),
                  routes: [
                    GoRoute(
                      path: 'detail',
                      builder: (_, state) {
                        final f = state.extra;
                        if (f is FlightResult) {
                          return FlightDetailScreen(flight: f);
                        }
                        return const NotFoundScreen(
                          location: 'FlightDetail: missing extra');
                      }),
                  ]),
              ]),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.trips,
              builder: (_, __) => const TripsScreen()),
          ]),
        ]),
    ]);
}
