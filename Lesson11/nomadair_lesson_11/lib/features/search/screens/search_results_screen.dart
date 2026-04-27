import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../router/navigator_routes.dart';
import '../models/search_criteria.dart';

final class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key, this.criteria});

  final SearchCriteria? criteria;

  static const List<FlightModel> _mock = [
    FlightModel(id:'AI-101',airline:'Air India',origin:'BOM',destination:'DXB',durationMinutes:215,priceInr:18500,stops:0),
    FlightModel(id:'EK-501',airline:'Emirates',origin:'BOM',destination:'DXB',durationMinutes:200,priceInr:22000,stops:0),
    FlightModel(id:'IX-251',airline:'Air Arabia',origin:'BOM',destination:'DXB',durationMinutes:240,priceInr:14200,stops:1),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    final title = criteria != null
        ? '${criteria!.origin} → ${criteria!.destination}'
        : 'Results';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        surfaceTintColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: t.brandPrimary.withAlpha(12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: t.brandPrimary.withAlpha(60))),
            child: Text(
              'search/results?  ·  criteria received via state.extra\n'
              'L17: MockFlightRepository  ·  L32: Riverpod AsyncNotifier',
              style: AppTypography.monoSmall.copyWith(
                color: t.brandPrimary.withAlpha(200)))),
          const SizedBox(height: AppSpacing.md),
          ..._mock.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: NomadFlightCard(
              flight: f,
              onTap: () => context.push(NavigatorRoutes.seatMap),
            ),
          )),
        ],
      ),
    );
  }
}
