import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/discovery/models/destination_model.dart';
import '../features/discovery/screens/discovery_feed_screen.dart';
import '../features/discovery/screens/destination_detail_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/search/screens/search_results_screen.dart';
import '../features/trips/screens/trips_screen.dart';
import '../features/shell/screens/adaptive_shell_scaffold.dart';
import '../features/not_found/screens/not_found_screen.dart';
import 'navigator_routes.dart';

abstract final class AppRouter {
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  static final GoRouter router = GoRouter(
    initialLocation: NavigatorRoutes.discovery,
    debugLogDiagnostics: false,
    redirect: (_, state) {
      if (state.matchedLocation.startsWith('/profile') &&
          !isLoggedIn.value) return NavigatorRoutes.discovery;
      return null;
    },
    errorBuilder: (ctx, state) =>
        NotFoundScreen(location: state.uri.toString()),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) =>
            AdaptiveShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.discovery,
              builder: (_, __) => const DiscoveryFeedScreen(),
              routes: [GoRoute(path: 'detail',
                builder: (_, state) {
                  final extra = state.extra;
                  if (extra is DiscoveryDestination) {
                    return DestinationDetailScreen(destination: extra);
                  }
                  final iata =
                      state.uri.queryParameters['iata'] ?? '';
                  final dest = DiscoveryDestination.samples
                      .where((d) =>
                          d.iataCode == iata.toUpperCase())
                      .firstOrNull;
                  return dest == null
                      ? NotFoundScreen(
                          location: 'Destination $iata not found')
                      : DestinationDetailScreen(destination: dest);
                })])]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigatorRoutes.search,
              builder: (_, state) => SearchScreen(
                initialOrigin:
                    state.uri.queryParameters['from'],
                initialDestination:
                    state.uri.queryParameters['to']),
              routes: [
                GoRoute(
                  path: 'results',
                  // L16: SearchResultsScreen reads from Provider
                  // No GoRouter extra needed
                  builder: (_, __) => const SearchResultsScreen()),
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
