import 'dart:ui' show SemanticsFlag;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../models/search_criteria.dart';

/// Search Results — receives [SearchCriteria] via GoRouter extra.
///
/// Lesson 14: mock results. Lesson 17: MockFlightRepository.
final class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key, this.criteria});

  final SearchCriteria? criteria;

  static final _fmt = DateFormat('dd MMM');

  static const List<FlightModel> _mockFlights = [
    FlightModel(id:'AI-101',airline:'Air India',origin:'BOM',destination:'DXB',durationMinutes:215,priceInr:18500,stops:0),
    FlightModel(id:'EK-501',airline:'Emirates',origin:'BOM',destination:'DXB',durationMinutes:200,priceInr:22000,stops:0),
    FlightModel(id:'IX-251',airline:'Air Arabia',origin:'BOM',destination:'DXB',durationMinutes:240,priceInr:14200,stops:1),
    FlightModel(id:'9W-301',airline:'IndiGo',origin:'BOM',destination:'DXB',durationMinutes:225,priceInr:16800,stops:0),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final c = criteria;
    final title = c != null && c.origin != null && c.destination != null
        ? '${c.origin!.iata} → ${c.destination!.iata}'
        : 'Search Results';
    final subtitle = c?.departureDate != null
        ? _fmt.format(c!.departureDate!)
            + (c.isRoundTrip && c.returnDate != null
                ? ' – ${_fmt.format(c.returnDate!)}' : '')
            + '  ·  ${c.passengers.summary}'
            + '  ·  ${c.cabinClass.label}'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Column(
        children: [
          if (subtitle.isNotEmpty)
            Container(
              width: double.infinity,
              color: t.brandPrimary.withAlpha(10),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical:   AppSpacing.sm),
              child: Text(subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: t.brandPrimary)),
            ),
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
