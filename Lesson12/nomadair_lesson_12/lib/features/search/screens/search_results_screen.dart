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
  ];
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(title: Text(criteria!=null?'${criteria!.origin} → ${criteria!.destination}':'Results'),surfaceTintColor:Colors.transparent,leading:BackButton(onPressed:()=>context.pop())),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
        ..._mock.map((f) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: NomadFlightCard(flight: f, onTap: () => context.push(NavigatorRoutes.seatMap)))),
      ]));
  }
}
