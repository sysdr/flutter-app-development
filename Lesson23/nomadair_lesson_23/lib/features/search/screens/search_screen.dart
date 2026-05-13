import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../router/navigator_routes.dart';
import '../data/city_database.dart';
import '../models/recent_search.dart';
import '../models/search_criteria.dart';
import '../models/selected_city.dart';
import '../providers/search_criteria_notifier.dart';
import '../widgets/cabin_class_selector.dart';
import '../widgets/city_picker_field.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/passenger_count_selector.dart';
import '../widgets/recent_searches_widget.dart';

final class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialOrigin, this.initialDestination, this.initialDate});
  final String? initialOrigin, initialDestination, initialDate;
  @override State<SearchScreen> createState() => _SearchScreenState();
}

final class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override bool get wantKeepAlive => true;
  String? _error;
  bool    _submitted  = false;
  List<RecentSearch> _recents = const [];

  @override void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRecents());
  }

  Future<void> _loadRecents() async {
    if (!mounted) return;
    final list =
        await context.read<LocalStorageService>().loadRecentSearches();
    if (mounted) setState(() => _recents = list);
  }

  Future<void> _persistSearch(SearchCriteria c) async {
    if (c.origin == null || c.destination == null) return;
    await context.read<LocalStorageService>().addRecentSearch(
      RecentSearch(
        originIata:      c.origin!.iata,
        originName:      c.origin!.name,
        destinationIata: c.destination!.iata,
        destinationName: c.destination!.name,
        searchedAt:      DateTime.now(),
        cabinClassLabel: c.cabinClass.label,
        passengerCount:  c.passengers.total,
      ),
    );
    await _loadRecents();
  }

  void _applyRecent(RecentSearch r, SearchCriteriaNotifier n) {
    n.setOrigin(SelectedCity(
        name: r.originName, iata: r.originIata, cityId: 0));
    n.setDestination(SelectedCity(
        name: r.destinationName, iata: r.destinationIata, cityId: 0));
  }

  SelectedCity? _resolveIata(String? iata) {
    if (iata == null) return null;
    return CityDatabase.cities
        .where((c) => c.iata == iata.toUpperCase())
        .firstOrNull;
  }

  @override void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_submitted) {
      final n = context.read<SearchCriteriaNotifier>();
      final o = _resolveIata(widget.initialOrigin);
      final d = _resolveIata(widget.initialDestination);
      if (o != null) n.setOrigin(o);
      if (d != null) n.setDestination(d);
      // L23: pre-fill date from deep link
      if (widget.initialDate != null) {
        try {
          final dt = DateTime.parse(widget.initialDate!);
          if (dt.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
            n.setDepartureDate(dt);
          }
        } catch (_) {}
      }
    }
  }

  void _submit() {
    final n   = context.read<SearchCriteriaNotifier>();
    final err = n.validate();
    if (err != null) { setState(() => _error = err); return; }
    setState(() { _error = null; _submitted = true; });
    _persistSearch(n.criteria);
    context.go(NavigatorRoutes.searchResults);
  }

  @override Widget build(BuildContext context) {
    super.build(context);
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final n = context.watch<SearchCriteriaNotifier>();
    final c = n.criteria;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.xl),
        children: [
          Text('Search Flights',
            style: AppTypography.displayLarge.copyWith(
              color: t.onSurfaceColor)),
          const SizedBox(height: AppSpacing.md),
          RecentSearchesWidget(
            searches: _recents,
            onSelected: (r) => _applyRecent(r, n),
            onClear: () async {
              await context.read<LocalStorageService>()
                  .clearRecentSearches();
              _loadRecents();
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            const Text('One way'),
            Switch(value: c.isRoundTrip, onChanged: n.setRoundTrip),
            const Text('Round trip'),
          ]),
          const SizedBox(height: AppSpacing.md),
          CityPickerField(
            label: 'From',
            prefixIcon: Icons.flight_takeoff,
            initialValue: c.origin,
            onChanged: n.setOrigin),
          const SizedBox(height: AppSpacing.md),
          CityPickerField(
            label: 'To',
            prefixIcon: Icons.flight_land,
            initialValue: c.destination,
            onChanged: n.setDestination),
          const SizedBox(height: AppSpacing.md),
          DatePickerField(
            label: 'Departure',
            value: c.departureDate,
            firstDate: DateTime.now(),
            onChanged: n.setDepartureDate),
          if (c.isRoundTrip) ...[
            const SizedBox(height: AppSpacing.md),
            DatePickerField(
              label: 'Return',
              value: c.returnDate,
              firstDate: c.departureDate ?? DateTime.now(),
              enabled: c.departureDate != null,
              onChanged: n.setReturnDate),
          ],
          const SizedBox(height: AppSpacing.md),
          PassengerCountSelector(
            value: c.passengers, onChanged: n.setPassengers),
          const SizedBox(height: AppSpacing.md),
          CabinClassSelector(
            value: c.cabinClass, onChanged: n.setCabinClass),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_error!,
              style: AppTypography.bodyMedium.copyWith(
                color: t.errorColor)),
          ],
          const SizedBox(height: AppSpacing.xl),
          NomadButton(
            label: 'Search Flights',
            icon: Icons.search,
            onPressed: _submit),
        ]),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'mastery_fab',
        onPressed: () => context.push(NavigatorRoutes.masteryRubric),
        tooltip: 'Mastery Rubric',
        child: const Icon(Icons.checklist_rtl, size: 20)));
  }
}
