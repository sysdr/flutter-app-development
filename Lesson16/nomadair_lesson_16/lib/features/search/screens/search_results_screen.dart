import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';
import 'package:provider/provider.dart';

import '../providers/search_criteria_notifier.dart';

/// Lesson 16 — SearchResultsScreen reads from Provider.
///
/// What changed from Lesson 15:
///   - No GoRouter [extra] parameter
///   - Criteria read from context.watch<SearchCriteriaNotifier>()
///   - "New Search" button calls notifier.reset() + context.pop()
final class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  static final _fmt = DateFormat('dd MMM');

  static const List<FlightModel> _mockFlights = [
    FlightModel(id:'AI-101',airline:'Air India',origin:'BOM',
      destination:'DXB',durationMinutes:215,priceInr:18500,stops:0),
    FlightModel(id:'EK-501',airline:'Emirates',origin:'BOM',
      destination:'DXB',durationMinutes:200,priceInr:22000,stops:0),
    FlightModel(id:'IX-251',airline:'Air Arabia',origin:'BOM',
      destination:'DXB',durationMinutes:240,priceInr:14200,stops:1),
    FlightModel(id:'9W-301',airline:'IndiGo',origin:'BOM',
      destination:'DXB',durationMinutes:225,priceInr:16800,stops:0),
  ];

  @override
  Widget build(BuildContext context) {
    // ── READ from Provider — no GoRouter extra needed ─────────────
    final criteria = context.watch<SearchCriteriaNotifier>().criteria;
    final t = Theme.of(context).extension<NomadThemeExtension>()!;

    final title = criteria.origin != null && criteria.destination != null
        ? '${criteria.origin!.iata} → ${criteria.destination!.iata}'
        : 'Search Results';

    final subtitle = criteria.departureDate != null
        ? _fmt.format(criteria.departureDate!)
            + (criteria.isRoundTrip && criteria.returnDate != null
                ? ' – ${_fmt.format(criteria.returnDate!)}' : '')
            + '  ·  ${criteria.passengers.summary}'
            + '  ·  ${criteria.cabinClass.label}'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          // "New Search" — resets Provider state and pops back
          Semantics(
            label: 'Start a new search',
            button: true,
            child: TextButton.icon(
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('New Search'),
              onPressed: () {
                context.read<SearchCriteriaNotifier>().reset();
                context.pop();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Criteria summary bar
          if (subtitle.isNotEmpty)
            Container(
              width: double.infinity,
              color: t.brandPrimary.withAlpha(10),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical:   AppSpacing.sm),
              child: Text(subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: t.brandPrimary))),

          // Flight results
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _mockFlights.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => NomadFlightCard(
                flight:  _mockFlights[i],
                onTap:   () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
