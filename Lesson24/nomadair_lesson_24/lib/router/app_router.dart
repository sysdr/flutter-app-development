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
import '../core/deeplink/deep_link_resolver.dart';
import '../core/transitions/nom_transitions.dart';
import '../core/transitions/transition_config.dart';
import 'navigator_routes.dart';

abstract final class AppRouter {
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
                  pageBuilder: (_, state) {
                    final extra = state.extra;
                    DiscoveryDestination? dest;
                    if (extra is DiscoveryDestination) {
                      dest = extra;
                    } else {
                      final ia = state.uri.queryParameters['iata'] ?? '';
                      dest = DiscoveryDestination.samples
                          .where((x) => x.iataCode == ia.toUpperCase())
                          .firstOrNull;
                    }
                    return CustomTransitionPage<void>(
                      key:  state.pageKey,
                      child: dest != null
                          ? DestinationDetailScreen(destination: dest)
                          : NotFoundScreen(
                              location: 'Destination unknown'),
                      transitionDuration: TransitionConfig.enterDuration,
                      reverseTransitionDuration: TransitionConfig.exitDuration,
                      transitionsBuilder: NomadTransitions.slideRight);
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
                      pageBuilder: (_, state) {
                        final f = state.extra;
                        if (f is FlightResult) {
                          return CustomTransitionPage<void>(
                            key:  state.pageKey,
                            child: FlightDetailScreen(flight: f),
                            transitionDuration:
                                TransitionConfig.enterDuration,
                            reverseTransitionDuration:
                                TransitionConfig.exitDuration,
                            transitionsBuilder:
                                NomadTransitions.slideUp);
                        }
                        return CustomTransitionPage<void>(
                            key: state.pageKey,
                            child: const NotFoundScreen(
                                location: 'FlightDetail: missing extra'),
                            transitionsBuilder: NomadTransitions.fadeScale);
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
