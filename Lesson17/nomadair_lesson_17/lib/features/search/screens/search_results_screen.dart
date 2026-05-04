import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';

import '../providers/flight_search_notifier.dart';
import '../providers/search_criteria_notifier.dart';
import '../widgets/flight_result_card.dart';

/// Lesson 17 — SearchResultsScreen with real mock flight data.
///
/// Changes from L16:
///   StatefulWidget — initState triggers search via addPostFrameCallback
///   switch(FlightSearchState): Idle / Loading(shimmer) / Loaded / Error
///   Sort chips: Price / Duration / Departure
///   FlightResultCard replaces NomadFlightCard placeholder
///   Error view with Retry + New Search buttons
final class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});
  @override
  State<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

final class _SearchResultsScreenState
    extends State<SearchResultsScreen> {
  static final _fmt = DateFormat('dd MMM');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final criteria =
          context.read<SearchCriteriaNotifier>().criteria;
      context.read<FlightSearchNotifier>().search(criteria);
    });
  }

  @override
  Widget build(BuildContext context) {
    final criteria = context.watch<SearchCriteriaNotifier>().criteria;
    final notifier = context.watch<FlightSearchNotifier>();
    final t = Theme.of(context).extension<NomadThemeExtension>()!;

    final title = criteria.origin != null && criteria.destination != null
        ? '${criteria.origin!.iata} → ${criteria.destination!.iata}'
        : 'Search Results';

    final sub = criteria.departureDate != null
        ? '${_fmt.format(criteria.departureDate!)}'
          '${criteria.isRoundTrip && criteria.returnDate != null ? ' – ${_fmt.format(criteria.returnDate!)}' : ''}'
          '  ·  ${criteria.passengers.summary}'
          '  ·  ${criteria.cabinClass.label}'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          Semantics(
            label: 'Start a new search', button: true,
            child: TextButton.icon(
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('New Search'),
              onPressed: () {
                context.read<SearchCriteriaNotifier>().reset();
                context.read<FlightSearchNotifier>().reset();
                context.pop();
              })),
        ]),
      body: Column(children: [
        if (sub.isNotEmpty)
          Container(
            width: double.infinity,
            color: t.brandPrimary.withAlpha(10),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Text(sub,
              style: AppTypography.bodySmall.copyWith(
                color: t.brandPrimary))),
        Expanded(child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey(switch (notifier.state) {
              FlightSearchLoaded() => 'loaded',
              FlightSearchError(:final message) => 'error_$message',
              _ => 'loading',
            }),
            child: switch (notifier.state) {
              FlightSearchIdle() => const _ShimmerList(),
              FlightSearchLoading() => const _ShimmerList(),
              FlightSearchLoaded() => _results(notifier, t),
              FlightSearchError(:final message) =>
                _error(message, criteria, notifier, t),
            }))),
      ]),
    );
  }

  Widget _results(FlightSearchNotifier notifier,
      NomadThemeExtension t) {
    final loaded = notifier.state as FlightSearchLoaded;
    final sorted = loaded.sorted;
    return Column(children: [
      // sort chips
      Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Row(children: [
          Text('Sort: ', style: AppTypography.bodySmall.copyWith(
            color: t.onSurfaceColor.withAlpha(150))),
          ...SortBy.values.map((s) => Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: NomadChip(
              label: s.label,
              variant: const FilterChipVariant(),
              selected: loaded.sortBy == s,
              onTap: () => notifier.setSortBy(s)))),
        ])),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('${sorted.length} flights found',
            style: AppTypography.bodySmall.copyWith(
              color: t.onSurfaceColor.withAlpha(150))))),
      Expanded(child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        itemCount: sorted.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, i) => FlightResultCard(
          key: ValueKey(sorted[i].id),
          flight: sorted[i],
          onTap: () {}),
      )),
    ]);
  }

  Widget _error(String msg, criteria, FlightSearchNotifier n,
      NomadThemeExtension t) =>
      Center(child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ExcludeSemantics(child: Icon(Icons.wifi_off_outlined,
            size: 64, color: t.errorColor.withAlpha(160))),
          const SizedBox(height: AppSpacing.md),
          Text("Couldn't load flights",
            style: AppTypography.headlineMedium.copyWith(
              color: t.onSurfaceColor)),
          const SizedBox(height: AppSpacing.xs),
          Text(msg, textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: t.onSurfaceColor.withAlpha(160))),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(width: 200, child: NomadButton(
            label: 'Retry', icon: Icons.refresh,
            onPressed: () => n.search(criteria))),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: 200, child: NomadButton(
            label: 'New Search', variant: const OutlinedVariant(),
            onPressed: () {
              context.read<SearchCriteriaNotifier>().reset();
              context.read<FlightSearchNotifier>().reset();
              context.pop();
            })),
        ])));
}

// ── Shimmer list ──────────────────────────────────────────────────

final class _ShimmerList extends StatefulWidget {
  const _ShimmerList();
  @override State<_ShimmerList> createState() => _ShimmerListState();
}
final class _ShimmerListState extends State<_ShimmerList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1400))..repeat();
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(AppSpacing.md),
    itemCount: 6,
    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
    itemBuilder: (_, __) => _ShimmerCard(animation: _c));
}

final class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.animation});
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) => Card(child: Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        ShimmerBox(animation: animation, width: 160, height: 14),
        const Spacer(),
        ShimmerBox(animation: animation, width: 60, height: 14),
      ]),
      const SizedBox(height: AppSpacing.md),
      Row(children: [
        ShimmerBox(animation: animation, width: 52, height: 38),
        const Spacer(),
        ShimmerBox(animation: animation, width: 80, height: 18),
        const Spacer(),
        ShimmerBox(animation: animation, width: 52, height: 38),
      ]),
      const SizedBox(height: AppSpacing.md),
      Row(children: [
        ShimmerBox(animation: animation, width: 90, height: 22),
        const Spacer(),
        ShimmerBox(animation: animation, width: 68, height: 14),
      ]),
    ])));
}
