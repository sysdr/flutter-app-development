import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../router/app_router.dart';
import '../../../router/navigator_routes.dart';
import '../../discovery/models/destination_model.dart';

/// Lesson 11 Visualizer — Navigation Explorer.
///
/// Accessible from AppBar menu on the Discovery tab.
/// Tab 1 Routes  : full route tree with navigate buttons
/// Tab 2 Concepts: declarative vs imperative + redirect guard demo
final class NavigationExplorerScreen extends StatefulWidget {
  const NavigationExplorerScreen({super.key});

  @override
  State<NavigationExplorerScreen> createState() =>
      _NavigationExplorerScreenState();
}

final class _NavigationExplorerScreenState
    extends State<NavigationExplorerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Explorer'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tab,
          tabs: const [Tab(text: 'Routes'), Tab(text: 'Concepts')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [_RoutesTab(), _ConceptsTab()],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 1: Routes
// ══════════════════════════════════════════════════════════════════════

final class _RoutesTab extends StatelessWidget {
  const _RoutesTab();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('GoRouter Route Tree',
          style: AppTypography.headlineLarge.copyWith(color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.xs),
        Text('${NavigatorRoutes.all.length} routes · StatefulShellRoute (3 tabs)',
          style: AppTypography.bodySmall.copyWith(
            color: t.onSurfaceColor.withAlpha(160))),
        const SizedBox(height: AppSpacing.lg),

        _RouteGroup(
          title: 'Shell Tab 0 — Discovery',
          color: AppColors.blue600,
          routes: [
            _RouteEntry(
              path: NavigatorRoutes.discovery,
              screen: 'DiscoveryScreen',
              note: 'Shell branch 0 root',
              onNavigate: () => context.go(NavigatorRoutes.discovery),
            ),
            _RouteEntry(
              path: NavigatorRoutes.destinationDetail,
              screen: 'DestinationDetailScreen',
              note: 'extra: DiscoveryDestination',
              onNavigate: () => context.go(
                NavigatorRoutes.destinationDetail,
                extra: DiscoveryDestination.samples.first),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _RouteGroup(
          title: 'Shell Tab 1 — Search',
          color: AppColors.green500,
          routes: [
            _RouteEntry(
              path: NavigatorRoutes.search,
              screen: 'SearchScreen',
              note: 'Shell branch 1 root',
              onNavigate: () => context.go(NavigatorRoutes.search),
            ),
            _RouteEntry(
              path: NavigatorRoutes.searchResults,
              screen: 'SearchResultsScreen',
              note: 'extra: SearchCriteria?',
              onNavigate: () => context.push(NavigatorRoutes.searchResults),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _RouteGroup(
          title: 'Shell Tab 2 — Trips',
          color: AppColors.amber600,
          routes: [
            _RouteEntry(
              path: NavigatorRoutes.trips,
              screen: 'TripsScreen',
              note: 'Shell branch 2 root',
              onNavigate: () => context.go(NavigatorRoutes.trips),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _RouteGroup(
          title: 'Booking (off-shell)',
          color: AppColors.amber700,
          routes: [
            _RouteEntry(
              path: NavigatorRoutes.seatMap,
              screen: 'SeatMapScreen',
              note: 'Full-screen push (L40: CustomPainter)',
              onNavigate: () => context.push(NavigatorRoutes.seatMap),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _RouteGroup(
          title: 'Profile (redirect-protected)',
          color: AppColors.semanticOverlay,
          routes: [
            _RouteEntry(
              path: NavigatorRoutes.profile,
              screen: 'ProfileScreen',
              note: 'Redirects to /discovery (not logged in)',
              onNavigate: () {
                context.go(NavigatorRoutes.profile);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Redirect: not logged in → /discovery'),
                    duration: Duration(seconds: 2)));
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // 404 test
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Error Route (404)',
                  style: AppTypography.labelLarge.copyWith(
                    color: t.errorColor)),
                const SizedBox(height: AppSpacing.xs),
                Text('/unknown/route → NotFoundScreen (errorBuilder)',
                  style: AppTypography.monoSmall.copyWith(
                    color: t.onSurfaceColor.withAlpha(160))),
                const SizedBox(height: AppSpacing.sm),
                NomadButton(
                  label: 'Test 404 Route',
                  variant: const OutlinedVariant(),
                  onPressed: () =>
                      context.push('/unknown/route/xyz'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

final class _RouteGroup extends StatelessWidget {
  const _RouteGroup({
    super.key,
    required this.title,
    required this.color,
    required this.routes,
  });
  final String title;
  final Color  color;
  final List<_RouteEntry> routes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            border: Border(bottom: BorderSide(color: color.withAlpha(60))),
          ),
          child: Text(title,
            style: AppTypography.labelLarge.copyWith(
              color: color, fontWeight: FontWeight.w700)),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: routes.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: r,
            )).toList(),
          ),
        ),
      ]),
    );
  }
}

final class _RouteEntry extends StatelessWidget {
  const _RouteEntry({
    super.key,
    required this.path,
    required this.screen,
    required this.note,
    required this.onNavigate,
  });
  final String path, screen, note;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Row(children: [
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(path,
            style: AppTypography.monoSmall.copyWith(
              color: t.brandPrimary, fontWeight: FontWeight.w700)),
          Text('$screen · $note',
            style: AppTypography.monoSmall.copyWith(
              color: t.onSurfaceColor.withAlpha(160), fontSize: 9)),
        ])),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          side: BorderSide(color: t.brandPrimary.withAlpha(120)),
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
        ),
        onPressed: onNavigate,
        child: Text('Go',
          style: AppTypography.monoSmall.copyWith(color: t.brandPrimary))),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════
// TAB 2: Concepts
// ══════════════════════════════════════════════════════════════════════

final class _ConceptsTab extends StatelessWidget {
  const _ConceptsTab();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('Declarative vs Imperative',
          style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.lg),

        _ComparisonCard(
          title: 'Navigator.pushNamed (Lesson 10)',
          color: AppColors.red500,
          icon: Icons.close,
          code:
            'Navigator.of(context).pushNamed(\n'
            '  '/discovery/detail',\n'
            '  arguments: destination,  // Object?\n'
            ');\n'
            '// receiver: state.arguments as Dest? — runtime cast',
          problems: [
            'Type safety: Object? argument → runtime crash on wrong type',
            'Tab stacks: single Navigator loses tabs back history',
            'Deep links: separate URL-parsing layer needed',
            '404: no built-in fallback for unknown routes',
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _ComparisonCard(
          title: 'context.go with GoRouter (Lesson 11)',
          color: AppColors.green500,
          icon: Icons.check,
          code:
            'context.go(\n'
            '  NavigatorRoutes.destinationDetail,\n'
            '  extra: destination,  // DiscoveryDestination\n'
            ');\n'
            '// receiver: state.extra as DiscoveryDestination',
          problems: [
            'Tab stacks: StatefulShellRoute per-tab back stacks',
            'Deep links: URL = source of truth (Lesson 12)',
            '404: GoRouter.errorBuilder handles all unmatched routes',
            'Redirect: auth guard in one place, applied to all routes',
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Auth redirect demo
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Redirect Guard — Auth Demo',
                  style: AppTypography.headlineSmall.copyWith(
                    color: t.onSurfaceColor)),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'AppRouter.isLoggedIn is currently false.\n'
                  'Any navigation to /profile is redirected to /discovery.',
                  style: AppTypography.bodySmall.copyWith(
                    color: t.onSurfaceColor.withAlpha(160))),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
                  child: Text(
                    'redirect: (context, state) {\n'
                    '  final protected = state.matchedLocation\n'
                    '      .startsWith('/profile');\n'
                    '  if (protected && !isLoggedIn.value)\n'
                    '    return NavigatorRoutes.discovery;\n'
                    '  return null; // proceed\n'
                    '}',
                    style: AppTypography.monoSmall.copyWith(
                      color: const Color(0xFFC9D1D9), height: 1.6))),
                const SizedBox(height: AppSpacing.sm),
                Row(children: [
                  Expanded(
                    child: NomadButton(
                      label: 'Try /profile (redirected)',
                      variant: const OutlinedVariant(),
                      onPressed: () {
                        context.go(NavigatorRoutes.profile);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                            'Redirect fired → /discovery'),
                            duration: Duration(seconds: 2)));
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: NomadButton(
                      label: 'Simulate Login',
                      onPressed: () {
                        AppRouter.isLoggedIn.value = true;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                            'isLoggedIn = true · try /profile now'),
                            duration: Duration(seconds: 2)));
                      },
                    ),
                  ),
                ]),
                const SizedBox(height: AppSpacing.sm),
                // Homework note
                Text(
                  'Homework: Wire isLoggedIn ValueNotifier to\n'
                  'GoRouter.refreshListenable to auto-refresh.',
                  style: AppTypography.monoSmall.copyWith(
                    color: t.brandAccent.withAlpha(200), fontSize: 9)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

final class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.code,
    required this.problems,
  });
  final String title, code;
  final Color  color;
  final IconData icon;
  final List<String> problems;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            border: Border(bottom: BorderSide(color: color.withAlpha(60)))),
          child: Row(children: [
            ExcludeSemantics(child: Icon(icon, color: color, size: 16)),
            const SizedBox(width: AppSpacing.xs),
            Text(title,
              style: AppTypography.labelLarge.copyWith(color: color)),
          ])),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
              child: Text(code,
                style: AppTypography.monoSmall.copyWith(
                  color: const Color(0xFFC9D1D9), height: 1.6))),
            const SizedBox(height: AppSpacing.sm),
            ...problems.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(p,
                  style: AppTypography.bodySmall.copyWith(
                    color: t.onSurfaceColor.withAlpha(200)))),
              ]))),
          ])),
      ]),
    );
  }
}
