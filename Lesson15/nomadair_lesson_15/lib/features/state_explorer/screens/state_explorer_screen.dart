        import 'package:flutter/material.dart';
        import 'package:nomadair_core/core.dart';
        import 'package:nomadair_ui/ui.dart';

        import '../widgets/rebuild_tracker_widget.dart';
        import '../widgets/prop_drilling_demo_widget.dart';

        /// Lesson 15 Visualizer — State Explorer.
        ///
        /// Tab 1 Rebuild  : RebuildTrackerWidget — isolated vs. anti-pattern
        /// Tab 2 Drilling : PropDrillingDemoWidget — relay cost with depth slider
        /// Tab 3 Rules    : setState three conditions + NomadAir state inventory
        final class StateExplorerScreen extends StatefulWidget {
          const StateExplorerScreen({super.key});
          @override
          State<StateExplorerScreen> createState() =>
              _StateExplorerScreenState();
        }

        final class _StateExplorerScreenState
            extends State<StateExplorerScreen>
            with SingleTickerProviderStateMixin {
          late final TabController _tab;

          @override
          void initState() {
            super.initState();
            _tab = TabController(length: 3, vsync: this);
          }

          @override
          void dispose() { _tab.dispose(); super.dispose(); }

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('State Explorer'),
                centerTitle: true,
                surfaceTintColor: Colors.transparent,
                bottom: TabBar(
                  controller: _tab,
                  tabs: const [
                    Tab(icon: Icon(Icons.refresh), text: 'Rebuild'),
                    Tab(icon: Icon(Icons.account_tree_outlined), text: 'Drilling'),
                    Tab(icon: Icon(Icons.rule), text: 'Rules'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tab,
                children: const [
                  _RebuildTab(),
                  _DrillingTab(),
                  _RulesTab(),
                ],
              ),
            );
          }
        }

        // ── Tab 1: Rebuild ────────────────────────────────────────────────

        final class _RebuildTab extends StatelessWidget {
          const _RebuildTab();
          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Text(
                    'Enable "Track widget rebuilds" in Flutter Inspector '
                    'to see rebuilds on the emulator screen.',
                    style: AppTypography.bodySmall.copyWith(
                      color: t.onSurfaceColor.withAlpha(160)))),
                const Expanded(child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: RebuildTrackerWidget())),
              ],
            );
          }
        }

        // ── Tab 2: Prop Drilling ──────────────────────────────────────────

        final class _DrillingTab extends StatelessWidget {
          const _DrillingTab();
          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Text(
                    'State lives at Level 0. Only the leaf widget uses it. '
                    'Adjust depth to see relay parameter cost grow.',
                    style: AppTypography.bodySmall.copyWith(
                      color: t.onSurfaceColor.withAlpha(160)))),
                const Expanded(child: PropDrillingDemoWidget()),
              ],
            );
          }
        }

        // ── Tab 3: Rules ──────────────────────────────────────────────────

        final class _RulesTab extends StatelessWidget {
          const _RulesTab();

          static const List<_StateRule> _rules = [
            _StateRule(
              number: '1',
              condition: 'Local',
              description:
                'State affects only this widget and its direct children. '
                'No sibling or parent widget reads or writes it.',
              example: '_shimmer AnimationController in DiscoveryFeedScreen',
              file: 'discovery/screens/discovery_feed_screen.dart',
              correct: true,
            ),
            _StateRule(
              number: '2',
              condition: 'Ephemeral',
              description:
                'State does not need to survive navigation, tab switches, '
                'or app restarts. A loading flag, a dialog open state.',
              example: '_searching bool in SearchScreen',
              file: 'search/screens/search_screen.dart',
              correct: true,
            ),
            _StateRule(
              number: '3',
              condition: 'Unshared',
              description:
                'No other widget at any level needs to read or write this state. '
                'If a sibling needs it, lift state or use Provider.',
              example: '_pageIndex in DiscoveryFeedScreen.PageView',
              file: 'discovery/screens/discovery_feed_screen.dart',
              correct: true,
            ),
          ];

          static const List<_StateInventoryItem> _inventory = [
            _StateInventoryItem('_shimmer AnimationController', 'DiscoveryFeedScreen', 'setState', 'L13'),
            _StateInventoryItem('_FeedMode grid/page toggle', 'DiscoveryFeedScreen', 'setState', 'L13'),
            _StateInventoryItem('_FeedState loading/data/error', 'DiscoveryFeedScreen', 'setState → AsyncNotifier L32', 'L13/32'),
            _StateInventoryItem('_searching loading flag', 'SearchScreen', 'setState', 'L14'),
            _StateInventoryItem('_criteria SearchCriteria', 'SearchScreen', 'setState + keepAlive → Provider L16', 'L15/16'),
            _StateInventoryItem('_adults/_children/_infants', '_PassengerSheetState', 'setState (always local)', 'L14'),
            _StateInventoryItem('_themeMode', 'NomadAirApp', 'setState at root', 'L07'),
            _StateInventoryItem('isLoggedIn', 'AppRouter', 'ValueNotifier → Firebase L25', 'L11'),
          ];

          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // Three conditions
                Text('When setState is correct',
                  style: AppTypography.headlineLarge.copyWith(
                    color: t.onSurfaceColor)),
                const SizedBox(height: AppSpacing.xs),
                Text('All three conditions must be true.',
                  style: AppTypography.bodySmall.copyWith(
                    color: t.onSurfaceColor.withAlpha(160))),
                const SizedBox(height: AppSpacing.md),
                ..._rules.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _RuleCard(rule: r))),

                const SizedBox(height: AppSpacing.md),
                Text('NomadAir State Inventory',
                  style: AppTypography.headlineLarge.copyWith(
                    color: t.onSurfaceColor)),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Column(
                    children: _inventory.asMap().entries.map((e) {
                      final i = e.value;
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm),
                          child: Row(children: [
                            Expanded(flex: 3, child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i.state,
                                  style: AppTypography.monoSmall.copyWith(
                                    color: t.brandPrimary,
                                    fontWeight: FontWeight.w700)),
                                Text(i.location,
                                  style: AppTypography.monoSmall.copyWith(
                                    color: t.onSurfaceColor.withAlpha(140),
                                    fontSize: 9)),
                              ])),
                            Expanded(flex: 3, child: Text(i.tool,
                              style: AppTypography.bodySmall.copyWith(
                                color: t.onSurfaceColor.withAlpha(180)))),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs, vertical: 2),
                              decoration: BoxDecoration(
                                color: t.brandPrimary.withAlpha(18),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull),
                                border: Border.all(
                                  color: t.brandPrimary.withAlpha(60))),
                              child: Text(i.lesson,
                                style: AppTypography.monoSmall.copyWith(
                                  color: t.brandPrimary, fontSize: 9))),
                          ])),
                        if (e.key < _inventory.length - 1)
                          Divider(height: 1, color: t.dividerColor),
                      ]);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // AutomaticKeepAliveClientMixin note
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.amber600.withAlpha(12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: AppColors.amber600.withAlpha(60))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AutomaticKeepAliveClientMixin',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.amber700)),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Keeps State alive across tab switches without Provider.\n\n'
                        'SearchScreen uses it in Lesson 15 — fill origin, '
                        'switch to Trips, return: form value persists.\n\n'
                        'Requirement: call super.build(context) as the FIRST '
                        'line of build(). Omitting it silently disables keep-alive.',
                        style: AppTypography.bodySmall.copyWith(
                          color: t.onSurfaceColor.withAlpha(180))),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1117),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm)),
                        child: Text(
                          'class _SearchScreenState extends State<SearchScreen>\n'
                          '    with AutomaticKeepAliveClientMixin {\n\n'
                          '  @override\n'
                          '  bool get wantKeepAlive => true;\n\n'
                          '  @override\n'
                          '  Widget build(BuildContext context) {\n'
                          '    super.build(context); // ← mandatory first line\n'
                          '    // ... rest of build\n'
                          '  }\n'
                          '}',
                          style: AppTypography.monoSmall.copyWith(
                            color: const Color(0xFFC9D1D9),
                            height: 1.6))),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            );
          }
        }

        final class _RuleCard extends StatelessWidget {
          const _RuleCard({super.key, required this.rule});
          final _StateRule rule;
          @override
          Widget build(BuildContext context) {
            final t = Theme.of(context).extension<NomadThemeExtension>()!;
            final color = rule.correct ? AppColors.green500 : AppColors.red500;
            return Card(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: color.withAlpha(18),
                    border: Border(bottom:
                      BorderSide(color: color.withAlpha(60)))),
                  child: Row(children: [
                    ExcludeSemantics(child: Icon(Icons.check_circle,
                      color: color, size: 16)),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Condition ${rule.number}: ${rule.condition}',
                      style: AppTypography.labelLarge.copyWith(
                        color: color)),
                  ])),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rule.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: t.onSurfaceColor.withAlpha(180))),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Example: ${rule.example}',
                        style: AppTypography.monoSmall.copyWith(
                          color: t.brandPrimary, fontSize: 10)),
                      Text(rule.file,
                        style: AppTypography.monoSmall.copyWith(
                          color: t.onSurfaceColor.withAlpha(120), fontSize: 9)),
                    ])),
              ]),
            );
          }
        }

        final class _StateRule {
          const _StateRule({
            required this.number,
            required this.condition,
            required this.description,
            required this.example,
            required this.file,
            required this.correct,
          });
          final String number, condition, description, example, file;
          final bool correct;
        }

        final class _StateInventoryItem {
          const _StateInventoryItem(
            this.state, this.location, this.tool, this.lesson);
          final String state, location, tool, lesson;
        }
