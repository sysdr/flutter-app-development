        import 'dart:async';

        import 'package:flutter/material.dart';
        import 'package:go_router/go_router.dart';
        import 'package:nomadair_core/core.dart';
        import 'package:nomadair_ui/ui.dart';

        import '../../../router/navigator_routes.dart';
        import '../data/city_database.dart';
        import '../models/search_criteria.dart';
        import '../models/selected_city.dart';
        import '../widgets/city_picker_field.dart';
        import '../widgets/date_picker_field.dart';
        import '../widgets/passenger_count_selector.dart';
        import '../widgets/cabin_class_selector.dart';

        /// Lesson 15 — SearchScreen with AutomaticKeepAliveClientMixin.
        ///
        /// Changes from Lesson 14:
        ///   + [AutomaticKeepAliveClientMixin] — keeps form state alive across tabs
        ///   + [wantKeepAlive] = true
        ///   + super.build(context) called as first line of build()
        ///
        /// The lesson note below documents the state problem and the migration path:
        ///   L14: setState — state lost on tab switch (deliberate)
        ///   L15: setState + AutomaticKeepAliveClientMixin — survives tab switch
        ///   L16: Provider — state shared between Search + Results screens
        final class SearchScreen extends StatefulWidget {
          const SearchScreen({
            super.key,
            this.initialOrigin,
            this.initialDestination,
          });
          final String? initialOrigin, initialDestination;

          @override
          State<SearchScreen> createState() => _SearchScreenState();
        }

        final class _SearchScreenState extends State<SearchScreen>
            with AutomaticKeepAliveClientMixin {
          // ── Keep-alive: form state survives tab switches ────────────────
          @override
          bool get wantKeepAlive => true;

          // ── Form state ─────────────────────────────────────────────────
          SearchCriteria _criteria = const SearchCriteria();

          // ── Per-field error strings ────────────────────────────────────
          String? _originError;
          String? _destError;
          String? _departureDateError;
          String? _returnDateError;

          bool _searching = false;

          @override
          void initState() {
            super.initState();
            if (widget.initialOrigin != null ||
                widget.initialDestination != null) {
              _prefillFromDeepLink();
            }
          }

          void _prefillFromDeepLink() {
            final origin = widget.initialOrigin != null
                ? CityDatabase.cities.where((c) =>
                    c.iata.toUpperCase() ==
                    widget.initialOrigin!.toUpperCase())
                    .firstOrNull
                : null;
            final destination = widget.initialDestination != null
                ? CityDatabase.cities.where((c) =>
                    c.iata.toUpperCase() ==
                    widget.initialDestination!.toUpperCase())
                    .firstOrNull
                : null;
            if (origin != null || destination != null) {
              _criteria = _criteria.copyWith(
                origin: origin, destination: destination);
            }
          }

          bool _validateFields() {
            final error = _criteria.validate();
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
            context.push(NavigatorRoutes.searchResults, extra: _criteria);
            setState(() => _searching = false);
          }

          @override
          Widget build(BuildContext context) {
            // ── Required by AutomaticKeepAliveClientMixin ─────────────
            super.build(context);

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

                  // Trip type toggle
                  Row(children: [
                    Expanded(child: NomadChip(
                      label: 'Round Trip',
                      variant: const FilterChipVariant(),
                      selected: _criteria.isRoundTrip,
                      onTap: () => setState(() =>
                          _criteria = _criteria.copyWith(isRoundTrip: true)))),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: NomadChip(
                      label: 'One Way',
                      variant: const FilterChipVariant(),
                      selected: !_criteria.isRoundTrip,
                      onTap: () => setState(() {
                        _criteria = _criteria.copyWith(
                          isRoundTrip: false, returnDate: null);
                        _returnDateError = null;
                      }))),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  CityPickerField(
                    label: 'Departure City',
                    prefixIcon: Icons.flight_takeoff,
                    initialValue: _criteria.origin,
                    errorText: _originError,
                    onChanged: (city) => setState(() {
                      _criteria = _criteria.copyWith(origin: city);
                      _originError = null;
                    })),
                  const SizedBox(height: AppSpacing.md),

                  CityPickerField(
                    label: 'Destination',
                    prefixIcon: Icons.flight_land,
                    initialValue: _criteria.destination,
                    errorText: _destError,
                    onChanged: (city) => setState(() {
                      _criteria = _criteria.copyWith(destination: city);
                      _destError = null;
                    })),
                  const SizedBox(height: AppSpacing.md),

                  DatePickerField(
                    label: 'Departure Date',
                    value: _criteria.departureDate,
                    errorText: _departureDateError,
                    onChanged: (date) => setState(() {
                      _criteria = _criteria.copyWith(
                        departureDate: date,
                        returnDate: _criteria.returnDate != null &&
                            date != null &&
                            _criteria.returnDate!.isBefore(date)
                            ? null : _criteria.returnDate);
                      _departureDateError = _returnDateError = null;
                    })),
                  const SizedBox(height: AppSpacing.md),

                  if (_criteria.isRoundTrip) ...[
                    DatePickerField(
                      label: 'Return Date',
                      value: _criteria.returnDate,
                      firstDate: _criteria.departureDate?.add(
                        const Duration(days: 1)),
                      enabled: _criteria.departureDate != null,
                      errorText: _returnDateError,
                      onChanged: (date) => setState(() {
                        _criteria = _criteria.copyWith(returnDate: date);
                        _returnDateError = null;
                      })),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  PassengerCountSelector(
                    value: _criteria.passengers,
                    onChanged: (pax) => setState(() =>
                        _criteria = _criteria.copyWith(passengers: pax))),
                  const SizedBox(height: AppSpacing.md),

                  CabinClassSelector(
                    value: _criteria.cabinClass,
                    onChanged: (cabin) => setState(() =>
                        _criteria = _criteria.copyWith(cabinClass: cabin))),
                  const SizedBox(height: AppSpacing.xl),

                  NomadButton(
                    label: 'Search Flights',
                    icon: Icons.search,
                    loading: _searching,
                    semanticLabel: 'Search for available flights',
                    onPressed: _searching ? null : _submit),
                  const SizedBox(height: AppSpacing.md),

                  // ── Lesson state annotation ───────────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: t.brandPrimary.withAlpha(10),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusSm),
                      border: Border.all(
                        color: t.brandPrimary.withAlpha(50))),
                    child: Text(
                      'L14: setState · state lost on tab switch (deliberate)\n'
                      'L15: + AutomaticKeepAliveClientMixin · form survives tab switch\n'
                      'L16: Provider · state shared with SearchResultsScreen',
                      style: AppTypography.monoSmall.copyWith(
                        color: t.brandPrimary.withAlpha(180)))),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          }
        }
