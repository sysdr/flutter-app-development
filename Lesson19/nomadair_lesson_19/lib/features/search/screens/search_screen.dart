import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';
import '../../../router/navigator_routes.dart';
import '../data/city_database.dart';
import '../models/selected_city.dart';
import '../providers/search_criteria_notifier.dart';
import '../widgets/cabin_class_selector.dart';
import '../widgets/city_picker_field.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/passenger_count_selector.dart';

final class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialOrigin, this.initialDestination});
  final String? initialOrigin, initialDestination;
  @override State<SearchScreen> createState() => _SearchScreenState();
}

final class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override bool get wantKeepAlive => true;
  String? _error;
  bool    _submitted = false;

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
    }
  }

  void _submit() {
    final n = context.read<SearchCriteriaNotifier>();
    final err = n.validate();
    if (err != null) { setState(() => _error = err); return; }
    setState(() { _error = null; _submitted = true; });
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
          const SizedBox(height: AppSpacing.lg),
          Row(children: [
            const Text('One way'),
            Switch(value: c.isRoundTrip,
              onChanged: n.setRoundTrip),
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
