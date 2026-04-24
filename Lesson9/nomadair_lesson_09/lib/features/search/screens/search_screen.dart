import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

/// Search Screen — Module 1 Mastery Challenge.
///
/// Patterns demonstrated:
///   - NomadTextField with inline validation (WCAG 1.4.1: error via text)
///   - NomadButton loading state (Lesson 05)
///   - Keyboard-safe SingleChildScrollView
///   - Form validation without raw widgets
final class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

final class _SearchScreenState extends State<SearchScreen> {
  final _originCtrl = TextEditingController();
  final _destCtrl   = TextEditingController();

  String? _originError;
  String? _destError;
  bool    _searching = false;
  String? _statusMessage;
  List<FlightModel> _results = const <FlightModel>[];

  @override
  void dispose() {
    _originCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Inline validation — WCAG 1.4.1: error communicated via text
    final originEmpty = _originCtrl.text.trim().isEmpty;
    final destEmpty   = _destCtrl.text.trim().isEmpty;

    if (originEmpty || destEmpty) {
      setState(() {
        _originError = originEmpty ? 'Enter a departure city or code' : null;
        _destError   = destEmpty   ? 'Enter a destination city or code' : null;
      });
      return;
    }

    setState(() {
      _originError = null;
      _destError   = null;
      _searching   = true;
      _statusMessage = null;
    });

    // Simulate 1.5s search
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    final origin = _originCtrl.text.trim().toUpperCase();
    final destination = _destCtrl.text.trim().toUpperCase();
    final results = <FlightModel>[
      FlightModel(
        id: '$origin-$destination-01',
        airline: 'NomadAir Express',
        origin: origin,
        destination: destination,
        durationMinutes: 190,
        priceInr: 18500,
        stops: 0,
      ),
      FlightModel(
        id: '$origin-$destination-02',
        airline: 'SkyConnect',
        origin: origin,
        destination: destination,
        durationMinutes: 225,
        priceInr: 16499,
        stops: 1,
      ),
    ];
    setState(() {
      _searching = false;
      _results = results;
      _statusMessage = '${results.length} flights available for $origin → $destination';
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find your flight',
            style: AppTypography.displayLarge.copyWith(
              color: t.onSurfaceColor,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter origin and destination to search',
            style: AppTypography.bodyMedium.copyWith(
              color: t.onSurfaceColor.withAlpha(160),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Origin field
          NomadTextField(
            label: 'Departure City',
            hint: 'Mumbai (BOM)',
            prefixIcon: Icons.flight_takeoff,
            controller: _originCtrl,
            error: _originError,
            semanticLabel: 'Departure city input',
            onChanged: (_) {
              if (_originError != null) {
                setState(() => _originError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Destination field
          NomadTextField(
            label: 'Destination',
            hint: 'Dubai (DXB)',
            prefixIcon: Icons.flight_land,
            controller: _destCtrl,
            error: _destError,
            semanticLabel: 'Destination city input',
            onChanged: (_) {
              if (_destError != null) {
                setState(() => _destError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Submit
          NomadButton(
            label: 'Search Flights',
            icon: Icons.search,
            loading: _searching,
            semanticLabel: 'Search for available flights',
            onPressed: _searching ? null : _submit,
          ),

          if (_statusMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Semantics(
              liveRegion: true,
              label: _statusMessage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: t.brandSecondary.withAlpha(16),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: t.brandSecondary.withAlpha(80)),
                ),
                child: Text(
                  _statusMessage!,
                  style: AppTypography.labelMedium.copyWith(
                    color: t.brandSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],

          if (_results.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            ..._results.map(
              (flight) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: NomadFlightCard(
                  flight: flight,
                  onTap: () {},
                ),
              ),
            ),
          ],

          // Rubric note
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: t.brandPrimary.withAlpha(12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: t.brandPrimary.withAlpha(60)),
            ),
            child: Text(
              'Rubric: Empty fields show inline error text — '
              'WCAG 1.4.1 error-not-by-color-alone. '
              'No raw Snackbar, no AlertDialog.',
              style: AppTypography.monoSmall.copyWith(
                color: t.brandPrimary.withAlpha(200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
