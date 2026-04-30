import 'dart:async';

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

/// Lesson 16 — SearchScreen migrated to Provider.
///
/// What changed from Lesson 15:
///   - [SearchCriteria _criteria] removed from local setState
///   - [SearchCriteriaNotifier] provides criteria via Provider
///   - build() reads: context.watch<SearchCriteriaNotifier>().criteria
///   - handlers write: context.read<SearchCriteriaNotifier>().setX()
///   - [AutomaticKeepAliveClientMixin] retained for local error/loading state
///   - GoRouter extra no longer needed for SearchResultsScreen
///   - addPostFrameCallback for safe deep-link prefill in initState
///
/// Lesson annotation:
///   L14: setState — state lost on tab switch
///   L15: setState + keepAlive — survives tab switch (local state)
///   L16: Provider — criteria in ChangeNotifier above widget tree ✓
///   L32: Riverpod — replaces Provider entirely
final class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    this.initialOrigin,
    this.initialDestination,
  });

  final String? initialOrigin;
  final String? initialDestination;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {

  // ── Keep-alive: preserves local UI state (error strings, loading)
  @override
  bool get wantKeepAlive => true;

  // ── Local state — only ephemeral UI state remains here ──────────
  // Criteria moved to SearchCriteriaNotifier (Provider).
  String? _originError;
  String? _destError;
  String? _departureDateError;
  String? _returnDateError;
  bool    _searching = false;

  @override
  void initState() {
    super.initState();
    // Provider is not available in initState — use addPostFrameCallback
    if (widget.initialOrigin != null ||
        widget.initialDestination != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _prefillFromDeepLink();
      });
    }
  }

  void _prefillFromDeepLink() {
    final notifier = context.read<SearchCriteriaNotifier>();
    if (widget.initialOrigin != null) {
      final city = CityDatabase.cities.where((c) =>
          c.iata.toUpperCase() ==
          widget.initialOrigin!.toUpperCase()).firstOrNull;
      if (city != null) notifier.setOrigin(city);
    }
    if (widget.initialDestination != null) {
      final city = CityDatabase.cities.where((c) =>
          c.iata.toUpperCase() ==
          widget.initialDestination!.toUpperCase()).firstOrNull;
      if (city != null) notifier.setDestination(city);
    }
  }

  bool _validateFields() {
    final error = context.read<SearchCriteriaNotifier>().validate();
    if (error == null) {
      setState(() {
        _originError = _destError =
        _departureDateError = _returnDateError = null;
      });
      return true;
    }
    setState(() {
      _originError = error.contains('departure city') ? error : null;
      _destError   = error.contains('destination city') ||
                     error.contains('same city') ? error : null;
      _departureDateError =
          error.contains('departure date') ? error : null;
      _returnDateError    =
          error.contains('return date') ||
          error.contains('Return date') ? error : null;
    });
    return false;
  }

  Future<void> _submit() async {
    if (!_validateFields()) return;
    setState(() => _searching = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    // No GoRouter extra needed — SearchResultsScreen reads from Provider
    context.push(NavigatorRoutes.searchResults);
    setState(() => _searching = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // required by AutomaticKeepAliveClientMixin

    // ── READ from Provider — subscribes, rebuilds on criteria change
    final criteria = context.watch<SearchCriteriaNotifier>().criteria;
    final notifier = context.read<SearchCriteriaNotifier>();

    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final hasPreFill = widget.initialOrigin != null ||
                       widget.initialDestination != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Find your flight',
            style: AppTypography.displayLarge.copyWith(
              color: t.onSurfaceColor)),
          const SizedBox(height: AppSpacing.xs),

          if (hasPreFill) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical:   AppSpacing.xs),
              decoration: BoxDecoration(
                color: t.brandSecondary.withAlpha(18),
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusFull),
                border: Border.all(
                  color: t.brandSecondary.withAlpha(80))),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                ExcludeSemantics(child: Icon(Icons.link,
                  size: 14, color: t.brandSecondary)),
                const SizedBox(width: AppSpacing.xs),
                Text('Pre-filled from deep link',
                  style: AppTypography.monoSmall.copyWith(
                    color: t.brandSecondary)),
              ])),
            const SizedBox(height: AppSpacing.sm),
          ],

          // ── Trip type toggle ──────────────────────────────────
          Row(children: [
            Expanded(child: NomadChip(
              label: 'Round Trip',
              variant: const FilterChipVariant(),
              selected: criteria.isRoundTrip,
              // WRITE to Provider — context.read, no subscription
              onTap: () => notifier.setRoundTrip(true))),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: NomadChip(
              label: 'One Way',
              variant: const FilterChipVariant(),
              selected: !criteria.isRoundTrip,
              onTap: () {
                notifier.setRoundTrip(false);
                setState(() => _returnDateError = null);
              })),
          ]),
          const SizedBox(height: AppSpacing.lg),

          // ── 1. Origin city ────────────────────────────────────
          CityPickerField(
            label:        'Departure City',
            prefixIcon:   Icons.flight_takeoff,
            initialValue: criteria.origin,
            errorText:    _originError,
            onChanged: (city) {
              notifier.setOrigin(city); // WRITE to Provider
              setState(() => _originError = null);
            }),
          const SizedBox(height: AppSpacing.md),

          // ── 2. Destination city ───────────────────────────────
          CityPickerField(
            label:        'Destination',
            prefixIcon:   Icons.flight_land,
            initialValue: criteria.destination,
            errorText:    _destError,
            onChanged: (city) {
              notifier.setDestination(city); // WRITE to Provider
              setState(() => _destError = null);
            }),
          const SizedBox(height: AppSpacing.md),

          // ── 3. Departure date ─────────────────────────────────
          DatePickerField(
            label:     'Departure Date',
            value:     criteria.departureDate,
            errorText: _departureDateError,
            onChanged: (date) {
              notifier.setDepartureDate(date); // WRITE to Provider
              setState(() {
                _departureDateError = null;
                _returnDateError    = null;
              });
            }),
          const SizedBox(height: AppSpacing.md),

          // ── 4. Return date (round trip only) ──────────────────
          if (criteria.isRoundTrip) ...[
            DatePickerField(
              label:     'Return Date',
              value:     criteria.returnDate,
              firstDate: criteria.departureDate?.add(
                const Duration(days: 1)),
              enabled:   criteria.departureDate != null,
              errorText: _returnDateError,
              onChanged: (date) {
                notifier.setReturnDate(date); // WRITE to Provider
                setState(() => _returnDateError = null);
              }),
            const SizedBox(height: AppSpacing.md),
          ],

          // ── 5. Passenger count ────────────────────────────────
          PassengerCountSelector(
            value:     criteria.passengers,
            onChanged: (pax) =>
                notifier.setPassengers(pax)), // WRITE to Provider
          const SizedBox(height: AppSpacing.md),

          // ── Cabin class ───────────────────────────────────────
          CabinClassSelector(
            value:     criteria.cabinClass,
            onChanged: (cabin) =>
                notifier.setCabinClass(cabin)), // WRITE to Provider
          const SizedBox(height: AppSpacing.xl),

          // ── Submit ────────────────────────────────────────────
          NomadButton(
            label:     'Search Flights',
            icon:      Icons.search,
            loading:   _searching,
            semanticLabel: 'Search for available flights',
            onPressed: _searching ? null : _submit),
          const SizedBox(height: AppSpacing.md),

          // ── Lesson state migration annotation ─────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: t.brandPrimary.withAlpha(10),
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusSm),
              border: Border.all(
                color: t.brandPrimary.withAlpha(50))),
            child: Text(
              'L14: setState · lost on tab switch\n'
              'L15: setState + keepAlive · local state preserved\n'
              'L16: Provider · criteria in ChangeNotifier ✓\n'
              'L32: Riverpod · replaces Provider entirely',
              style: AppTypography.monoSmall.copyWith(
                color: t.brandPrimary.withAlpha(180)))),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
