import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';
import '../../../router/navigator_routes.dart';
import '../data/city_database.dart';
import '../providers/search_criteria_notifier.dart';
import '../widgets/city_picker_field.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/passenger_count_selector.dart';
import '../widgets/cabin_class_selector.dart';

final class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialOrigin, this.initialDestination});
  final String? initialOrigin, initialDestination;
  @override State<SearchScreen> createState() => _SS();
}
final class _SS extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override bool get wantKeepAlive => true;
  String? _oe, _de, _dpe, _re;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialOrigin != null || widget.initialDestination != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final n = context.read<SearchCriteriaNotifier>();
        if (widget.initialOrigin != null) {
          final c = CityDatabase.cities.where((c) =>
            c.iata.toUpperCase() == widget.initialOrigin!.toUpperCase())
            .firstOrNull;
          if (c != null) n.setOrigin(c);
        }
        if (widget.initialDestination != null) {
          final c = CityDatabase.cities.where((c) =>
            c.iata.toUpperCase() == widget.initialDestination!.toUpperCase())
            .firstOrNull;
          if (c != null) n.setDestination(c);
        }
      });
    }
  }

  bool _validate() {
    final err = context.read<SearchCriteriaNotifier>().validate();
    if (err == null) {
      setState(() => _oe = _de = _dpe = _re = null);
      return true;
    }
    setState(() {
      _oe  = err.contains('departure city') ? err : null;
      _de  = err.contains('destination') || err.contains('same') ? err : null;
      _dpe = err.contains('departure date') ? err : null;
      _re  = err.contains('return') || err.contains('Return') ? err : null;
    });
    return false;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    context.push(NavigatorRoutes.searchResults);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cr = context.watch<SearchCriteriaNotifier>().criteria;
    final n  = context.read<SearchCriteriaNotifier>();
    final t  = Theme.of(context).extension<NomadThemeExtension>()!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Find your flight',
          style: AppTypography.displayLarge.copyWith(color: t.onSurfaceColor)),
        const SizedBox(height: AppSpacing.sm),
        Row(children: [
          Expanded(child: NomadChip(
            label: 'Round Trip', variant: const FilterChipVariant(),
            selected: cr.isRoundTrip, onTap: () => n.setRoundTrip(true))),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: NomadChip(
            label: 'One Way', variant: const FilterChipVariant(),
            selected: !cr.isRoundTrip,
            onTap: () { n.setRoundTrip(false); setState(() => _re = null); })),
        ]),
        const SizedBox(height: AppSpacing.lg),
        CityPickerField(
          label: 'Departure City', prefixIcon: Icons.flight_takeoff,
          initialValue: cr.origin, errorText: _oe,
          onChanged: (c) { n.setOrigin(c); setState(() => _oe = null); }),
        const SizedBox(height: AppSpacing.md),
        CityPickerField(
          label: 'Destination', prefixIcon: Icons.flight_land,
          initialValue: cr.destination, errorText: _de,
          onChanged: (c) { n.setDestination(c); setState(() => _de = null); }),
        const SizedBox(height: AppSpacing.md),
        DatePickerField(
          label: 'Departure Date', value: cr.departureDate, errorText: _dpe,
          onChanged: (d) { n.setDepartureDate(d);
            setState(() { _dpe = null; _re = null; }); }),
        const SizedBox(height: AppSpacing.md),
        if (cr.isRoundTrip) ...[
          DatePickerField(
            label: 'Return Date', value: cr.returnDate,
            firstDate: cr.departureDate?.add(const Duration(days: 1)),
            enabled: cr.departureDate != null, errorText: _re,
            onChanged: (d) { n.setReturnDate(d); setState(() => _re = null); }),
          const SizedBox(height: AppSpacing.md),
        ],
        PassengerCountSelector(
          value: cr.passengers, onChanged: n.setPassengers),
        const SizedBox(height: AppSpacing.md),
        CabinClassSelector(
          value: cr.cabinClass, onChanged: n.setCabinClass),
        const SizedBox(height: AppSpacing.xl),
        NomadButton(
          label: 'Search Flights', icon: Icons.search,
          loading: _loading,
          semanticLabel: 'Search for available flights',
          onPressed: _loading ? null : _submit),
        const SizedBox(height: AppSpacing.xl),
      ]),
    );
  }
}
