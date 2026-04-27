import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

/// NomadAir declarative router — Lesson 11.
///
/// Single source of truth for all navigation in the app.
/// Replace Navigator.pushNamed with context.go / context.push.
///
/// Architecture:
///   StatefulShellRoute   — three tab branches with independent stacks
///   redirect guard       — auth gate skeleton (Firebase Auth in L25)
///   errorBuilder         — 404 for unknown / malformed deep links
///   debugLogDiagnostics  — console route tracing (disable in release)
abstract final class AppRouter {
  /// Auth state — simple bool for Lesson 11.
  ///
  /// In Lesson 25, replaced by Firebase Auth's [ValueNotifier<User?>]
  /// wired to [GoRouter.refreshListenable].
  static final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

  static final GoRouter router = GoRouter(
    initialLocation: NavigatorRoutes.discovery,
    debugLogDiagnostics: true,

    // ── Auth redirect guard ──────────────────────────────────────
    // Returns null to proceed; returns a path string to redirect.
    // Lesson 25: replace isLoggedIn.value with Firebase Auth check.
    redirect: (BuildContext context, GoRouterState state) {
      final protected = state.matchedLocation.startsWith('/profile');
      if (protected && !isLoggedIn.value) {
        return NavigatorRoutes.discovery;
      }
      return null;
    },

    // ── 404 fallback ─────────────────────────────────────────────
    errorBuilder: (context, state) => NotFoundScreen(
      location: state.uri.toString(),
    ),

    // ── Route tree ───────────────────────────────────────────────
    routes: [
      // Shell: three tabs with independent back stacks
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveShellScaffold(navigationShell: navigationShell);
        },
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
                    final dest = state.extra as DiscoveryDestination;
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
              builder: (context, state) => const SearchScreen(),
              routes: [
                GoRoute(
                  path: 'results',
                  builder: (context, state) {
                    final criteria =
                        state.extra as SearchCriteria?;
                    return SearchResultsScreen(
                      criteria: criteria);
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

      // ── Booking (off-shell — full-screen) ──────────────────────
      GoRoute(
        path: NavigatorRoutes.seatMap,
        builder: (context, state) => const SeatMapScreen(),
        routes: [
          GoRoute(
            path: 'passengers',
            builder: (context, state) => const PassengerFormScreen(),
            routes: [
              GoRoute(
                path: 'payment',
                builder: (context, state) => const PaymentScreen(),
                routes: [
                  GoRoute(
                    path: 'confirmation',
                    builder: (context, state) =>
                        const ConfirmationScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ── Profile (protected) ────────────────────────────────────
      GoRoute(
        path: NavigatorRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
