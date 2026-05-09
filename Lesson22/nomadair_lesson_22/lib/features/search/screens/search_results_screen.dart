import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';
import '../../../router/navigator_routes.dart';
import '../providers/flight_search_notifier.dart';
import '../providers/search_criteria_notifier.dart';
import '../widgets/flight_result_card.dart';

final class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});
  @override State<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

final class _SearchResultsScreenState
    extends State<SearchResultsScreen> {
  @override void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final criteria =
          context.read<SearchCriteriaNotifier>().criteria;
      context.read<FlightSearchNotifier>().search(criteria);
    });
  }

  @override Widget build(BuildContext context) {
    final t       = Theme.of(context).extension<NomadThemeExtension>()!;
    final notifier = context.watch<FlightSearchNotifier>();
    final state    = notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () {
          context.read<FlightSearchNotifier>().reset();
          context.go(NavigatorRoutes.search);
        }),
        actions: [
          if (state is FlightSearchLoaded)
            PopupMenuButton<SortBy>(
              icon: const Icon(Icons.sort),
              tooltip: 'Sort by',
              onSelected: notifier.setSortBy,
              itemBuilder: (_) => SortBy.values
                  .map((s) => PopupMenuItem(
                      value: s, child: Text(s.label)))
                  .toList()),
        ]),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey(state.runtimeType),
          child: switch (state) {
            FlightSearchIdle() => const Center(
                child: CircularProgressIndicator()),
            FlightSearchLoading() => _buildShimmer(t),
            FlightSearchLoaded(:final sorted) => _buildList(sorted, t),
            FlightSearchError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message,
                      style: AppTypography.bodyLarge.copyWith(
                        color: t.errorColor)),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(width: 160,
                      child: NomadButton(
                        label: 'Retry',
                        icon: Icons.refresh,
                        onPressed: () {
                          final c = context
                              .read<SearchCriteriaNotifier>()
                              .criteria;
                          context
                              .read<FlightSearchNotifier>()
                              .search(c);
                        })),
                  ])),
          })));
  }

  Widget _buildShimmer(NomadThemeExtension t) =>
      ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: 6,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, __) => Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 200,
                  color: t.dividerColor),
                const SizedBox(height: AppSpacing.sm),
                Container(height: 12, width: 140,
                  color: t.dividerColor),
              ]))));

  Widget _buildList(List flights, NomadThemeExtension t) =>
      ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: flights.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (ctx, i) => FlightResultCard(
          flight: flights[i],
          onTap: () => ctx.push(
            NavigatorRoutes.flightDetail,
            extra: flights[i])));
}
