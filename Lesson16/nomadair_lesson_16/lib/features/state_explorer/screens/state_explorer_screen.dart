import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';

import '../widgets/rebuild_tracker_widget.dart';
import '../widgets/prop_drilling_demo_widget.dart';

/// Lesson 16 — StateExplorer with 4th Provider tab.
///
/// Tab 1 Rebuild  : RebuildTrackerWidget (from L15)
/// Tab 2 Drilling : PropDrillingDemoWidget (from L15)
/// Tab 3 Rules    : setState conditions + inventory (from L15)
/// Tab 4 Provider : ChangeNotifier live demo + comparison table (NEW)
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
    _tab = TabController(length: 4, vsync: this);
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
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.refresh),        text: 'Rebuild'),
            Tab(icon: Icon(Icons.account_tree_outlined), text: 'Drilling'),
            Tab(icon: Icon(Icons.rule),           text: 'Rules'),
            Tab(icon: Icon(Icons.hub_outlined),   text: 'Provider'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _RebuildTab(),
          _DrillingTab(),
          _RulesTab(),
          _ProviderTab(), // NEW in L16
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
    return Column(children: [
      Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Text(
          'Enable "Track widget rebuilds" in Flutter Inspector.',
          style: AppTypography.bodySmall.copyWith(
            color: t.onSurfaceColor.withAlpha(160)))),
      const Expanded(child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: RebuildTrackerWidget())),
    ]);
  }
}

// ── Tab 2: Prop Drilling ──────────────────────────────────────────

final class _DrillingTab extends StatelessWidget {
  const _DrillingTab();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Column(children: [
      Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Text(
          'State at Level 0. Only leaf uses it. Adjust depth.',
          style: AppTypography.bodySmall.copyWith(
            color: t.onSurfaceColor.withAlpha(160)))),
      const Expanded(child: PropDrillingDemoWidget()),
    ]);
  }
}

// ── Tab 3: Rules ──────────────────────────────────────────────────

final class _RulesTab extends StatelessWidget {
  const _RulesTab();
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text('setState three conditions',
          style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        ..._conditions.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _ConditionCard(cond: c))),
        const SizedBox(height: AppSpacing.md),
        Text('NomadAir State Inventory',
          style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        Card(child: Column(
          children: _inventory.asMap().entries.map((e) {
            final item = e.value;
            return Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: Row(children: [
                  Expanded(flex:3, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.state, style: AppTypography.monoSmall
                          .copyWith(color: t.brandPrimary,
                              fontWeight: FontWeight.w700)),
                      Text(item.location, style: AppTypography
                          .monoSmall.copyWith(
                              color: t.onSurfaceColor.withAlpha(130),
                              fontSize: 9)),
                    ])),
                  Expanded(flex:4, child: Text(item.tool,
                    style: AppTypography.bodySmall.copyWith(
                      color: item.tool.contains('Provider')
                          ? t.successColor
                          : t.onSurfaceColor.withAlpha(180)))),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs, vertical: 2),
                    decoration: BoxDecoration(
                      color: t.brandPrimary.withAlpha(18),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull),
                      border: Border.all(
                        color: t.brandPrimary.withAlpha(60))),
                    child: Text(item.lesson, style: AppTypography
                        .monoSmall.copyWith(
                            color: t.brandPrimary, fontSize: 9))),
                ])),
              if (e.key < _inventory.length - 1)
                Divider(height: 1, color: t.dividerColor),
            ]);
          }).toList())),
      ],
    );
  }

  static const List<_Cond> _conditions = [
    _Cond('1', 'Local',
      'Only this widget + direct children. No sibling or parent reads it.',
      '_shimmer AnimationController · DiscoveryFeedScreen'),
    _Cond('2', 'Ephemeral',
      'Does not survive navigation or app restarts.',
      '_searching bool · SearchScreen'),
    _Cond('3', 'Unshared',
      'No other widget at any level needs to read or write it.',
      '_pageIndex in PageView dots · DiscoveryFeedScreen'),
  ];

  static const List<_Inv> _inventory = [
    _Inv('_shimmer AnimationController', 'DiscoveryFeedScreen',
      'setState (L13)', 'L13'),
    _Inv('_FeedState loading/data/error', 'DiscoveryFeedScreen',
      'setState → AsyncNotifier (L32)', 'L13/32'),
    _Inv('_searching flag', 'SearchScreen',
      'setState (local, ephemeral)', 'L14'),
    _Inv('_originError / _destError', 'SearchScreen',
      'setState (local UI state)', 'L14'),
    _Inv('_criteria SearchCriteria', 'SearchCriteriaNotifier',
      'Provider ChangeNotifier ✓', 'L16'),
    _Inv('_adults/_children/_infants', '_PassengerSheetState',
      'setState (always local)', 'L14'),
    _Inv('_themeMode', 'NomadAirApp',
      'setState at root', 'L07'),
    _Inv('isLoggedIn', 'AppRouter',
      'ValueNotifier → Firebase (L25)', 'L11'),
  ];
}

final class _Cond {
  const _Cond(this.num, this.name, this.desc, this.example);
  final String num, name, desc, example;
}
final class _Inv {
  const _Inv(this.state, this.location, this.tool, this.lesson);
  final String state, location, tool, lesson;
}
final class _ConditionCard extends StatelessWidget {
  const _ConditionCard({required this.cond});
  final _Cond cond;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Card(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: t.successColor.withAlpha(18),
            border: Border(bottom: BorderSide(
              color: t.successColor.withAlpha(60)))),
          child: Text('Condition ${cond.num}: ${cond.name}',
            style: AppTypography.labelLarge.copyWith(
              color: t.successColor))),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cond.desc,
                style: AppTypography.bodySmall.copyWith(
                  color: t.onSurfaceColor.withAlpha(180))),
              const SizedBox(height: AppSpacing.xs),
              Text('Example: ${cond.example}',
                style: AppTypography.monoSmall.copyWith(
                  color: t.brandPrimary, fontSize: 10)),
            ])),
      ]));
  }
}

// ── Tab 4: Provider (NEW in L16) ──────────────────────────────────

final class _ProviderTab extends StatelessWidget {
  const _ProviderTab();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _DemoNotifier(),
      child: const _ProviderTabBody(),
    );
  }
}

final class _DemoNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void increment() { _count++; notifyListeners(); }
  void reset()     { _count = 0; notifyListeners(); }
}

final class _ProviderTabBody extends StatelessWidget {
  const _ProviderTabBody();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    // This entire widget does NOT rebuild on notifier change
    // Only the Consumer inside does
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // ── Provider architecture diagram ──────────────────────
        Text('Provider Tree',
          style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        Card(child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'MultiProvider\n'
            '  └── ChangeNotifierProvider<SearchCriteriaNotifier>\n'
            '        └── MaterialApp.router\n'
            '              ├── SearchScreen\n'
            '              │     context.watch → rebuild on change\n'
            '              │     context.read  → write, no rebuild\n'
            '              └── SearchResultsScreen\n'
            '                    context.watch → criteria from Provider\n'
            '                    no GoRouter extra needed',
            style: AppTypography.monoSmall.copyWith(
              color: t.onSurfaceColor, height: 1.7)))),
        const SizedBox(height: AppSpacing.lg),

        // ── Live demo ──────────────────────────────────────────
        Text('Live Demo — Consumer vs non-Consumer',
          style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        _NonConsumerWidget(), // never rebuilds on count change
        const SizedBox(height: AppSpacing.sm),
        Consumer<_DemoNotifier>(
          builder: (ctx, notifier, _) => _ConsumerWidget(
            count: notifier.count,
            onIncrement: notifier.increment,
            onReset: notifier.reset)),
        const SizedBox(height: AppSpacing.lg),

        // ── context.read vs .watch ─────────────────────────────
        Text('context.read vs context.watch',
          style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        Card(child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(children: [
            _ReadWatchRow(
              method: 'context.watch<T>()',
              location: 'build()',
              effect: 'Subscribes + rebuilds on change',
              correct: true),
            Divider(color: t.dividerColor),
            _ReadWatchRow(
              method: 'context.read<T>()',
              location: 'onPressed, onChange',
              effect: 'Reads once, no subscription',
              correct: true),
            Divider(color: t.dividerColor),
            _ReadWatchRow(
              method: 'context.read<T>() in build()',
              location: 'build()',
              effect: 'Stale data — widget never rebuilds',
              correct: false),
            Divider(color: t.dividerColor),
            _ReadWatchRow(
              method: 'context.watch<T>() in handler',
              location: 'onPressed',
              effect: 'Causes unexpected rebuilds',
              correct: false),
          ]))),
        const SizedBox(height: AppSpacing.lg),

        // ── Comparison table ───────────────────────────────────
        Text('setState vs Provider vs Riverpod',
          style: AppTypography.headlineLarge.copyWith(
            color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        Card(child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2.2),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
            },
            border: TableBorder(
              horizontalInside: BorderSide(
                color: t.dividerColor, width: 0.5)),
            children: [
              _tableHeader(t),
              _tableRow(t, 'Survives tab switch', '✗ (need mixin)', '✓', '✓'),
              _tableRow(t, 'Survives route push', '✗', '✓', '✓'),
              _tableRow(t, 'Cross-screen sharing', '✗', '✓', '✓'),
              _tableRow(t, 'Works outside widget', '✓', '✗', '✓'),
              _tableRow(t, 'Async state built-in', '—', '✗', '✓'),
              _tableRow(t, 'Testable sans widget', '✓', 'ProviderContainer', '✓'),
            ]))),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  TableRow _tableHeader(NomadThemeExtension t) => TableRow(
    decoration: BoxDecoration(
      color: t.brandPrimary.withAlpha(18)),
    children: ['Dimension', 'setState', 'Provider', 'Riverpod']
        .map((h) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Text(h, style: AppTypography.monoSmall.copyWith(
            color: t.brandPrimary, fontWeight: FontWeight.w700))))
        .toList());

  TableRow _tableRow(NomadThemeExtension t, String dim,
      String s, String p, String r) => TableRow(children: [dim, s, p, r]
      .asMap()
      .entries
      .map((e) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Text(e.value,
          style: AppTypography.bodySmall.copyWith(
            color: e.key == 0
                ? t.onSurfaceColor
                : e.value == '✓'
                ? t.successColor
                : e.value == '✗'
                ? t.errorColor
                : t.onSurfaceColor.withAlpha(160)))))
      .toList());
}

final class _NonConsumerWidget extends StatefulWidget {
  @override
  State<_NonConsumerWidget> createState() => _NonConsumerWidgetState();
}

final class _NonConsumerWidgetState
    extends State<_NonConsumerWidget> {
  int _builds = 0;
  @override
  Widget build(BuildContext context) {
    _builds++;
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: t.successColor.withAlpha(12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: t.successColor.withAlpha(60))),
      child: Row(children: [
        ExcludeSemantics(child: Icon(Icons.check_circle,
          color: t.successColor, size: 14)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Text('Non-Consumer — NEVER rebuilds on count change',
          style: AppTypography.bodySmall.copyWith(
            color: t.onSurfaceColor))),
        Text('builds: $_builds',
          style: AppTypography.monoSmall.copyWith(
            color: t.successColor, fontWeight: FontWeight.w700)),
      ]));
  }
}

final class _ConsumerWidget extends StatefulWidget {
  const _ConsumerWidget({
    required this.count,
    required this.onIncrement,
    required this.onReset,
  });
  final int count;
  final VoidCallback onIncrement, onReset;
  @override
  State<_ConsumerWidget> createState() => _ConsumerWidgetState();
}

final class _ConsumerWidgetState extends State<_ConsumerWidget> {
  int _builds = 0;
  Color _flash = Colors.transparent;

  @override
  void didUpdateWidget(_ConsumerWidget old) {
    super.didUpdateWidget(old);
    if (old.count != widget.count) {
      setState(() => _flash =
          AppColors.blue600.withAlpha(80));
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _flash = Colors.transparent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _builds++;
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: _flash,
      child: Card(child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(children: [
          Row(children: [
            ExcludeSemantics(child: Icon(Icons.hub_outlined,
              color: t.brandPrimary, size: 14)),
            const SizedBox(width: AppSpacing.xs),
            Expanded(child: Text(
              'Consumer<_DemoNotifier> — rebuilds on notifyListeners()',
              style: AppTypography.bodySmall.copyWith(
                color: t.onSurfaceColor))),
            Text('builds: $_builds',
              style: AppTypography.monoSmall.copyWith(
                color: t.brandPrimary, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: AppSpacing.md),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Semantics(label: 'Increment Provider counter', button: true,
              child: IconButton(
                icon: Icon(Icons.add_circle,
                  color: t.brandPrimary, size: 36),
                onPressed: widget.onIncrement)),
            Text('${widget.count}',
              style: AppTypography.displayLarge.copyWith(
                color: t.onSurfaceColor)),
            Semantics(label: 'Reset Provider counter', button: true,
              child: IconButton(
                icon: Icon(Icons.refresh,
                  color: t.onSurfaceColor.withAlpha(140), size: 24),
                onPressed: widget.onReset)),
          ]),
          Text('(Non-Consumer above NEVER rebuilds)',
            style: AppTypography.bodySmall.copyWith(
              color: t.onSurfaceColor.withAlpha(140))),
        ]))));
  }
}

final class _ReadWatchRow extends StatelessWidget {
  const _ReadWatchRow({
    required this.method,
    required this.location,
    required this.effect,
    required this.correct,
  });
  final String method, location, effect;
  final bool correct;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final color = correct ? t.successColor : t.errorColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(children: [
        ExcludeSemantics(child: Icon(
          correct ? Icons.check_circle : Icons.cancel,
          color: color, size: 16)),
        const SizedBox(width: AppSpacing.xs),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(method, style: AppTypography.monoSmall.copyWith(
              color: t.brandPrimary, fontWeight: FontWeight.w700)),
            Text('In: $location',
              style: AppTypography.bodySmall.copyWith(
                color: t.onSurfaceColor.withAlpha(140), fontSize: 10)),
            Text(effect,
              style: AppTypography.bodySmall.copyWith(
                color: color.withAlpha(200), fontSize: 10)),
          ])),
      ]));
  }
}
