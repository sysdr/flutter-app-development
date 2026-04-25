import 'package:flutter/material.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_ui/ui.dart';

import '../../../routes/navigator_routes.dart';

/// Search results **screen** — placeholder.
///
/// L17: populated with mock FlightRepository data.
/// L31: Riverpod AsyncNotifier drives loading/error/data states.
final class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  static const List<FlightModel> _mockFlights = [
    FlightModel(id:'AI-101',airline:'Air India',origin:'BOM',
      destination:'DXB',durationMinutes:215,priceInr:18500,stops:0),
    FlightModel(id:'EK-501',airline:'Emirates',origin:'BOM',
      destination:'DXB',durationMinutes:200,priceInr:22000,stops:0),
    FlightModel(id:'IX-251',airline:'Air Arabia',origin:'BOM',
      destination:'DXB',durationMinutes:240,priceInr:14200,stops:1),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<NomadThemeExtension>()!;
    return Scaffold(
      appBar: AppBar(title: const Text('Results'), surfaceTintColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _PlaceholderNote('search/screens/search_results_screen.dart\n'
            'L17: MockFlightRepository · L31: Riverpod AsyncNotifier'),
          const SizedBox(height: AppSpacing.md),
          ..._mockFlights.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: NomadFlightCard(
              flight: f,
              onTap: () => Navigator.of(context)
                  .pushNamed(NavigatorRoutes.seatMap),
            ),
          )),
        ],
      ),
    );
  }
}

class _PlaceholderNote extends StatelessWidget {
  const _PlaceholderNote(this.text);
  final String text;
  @override
  Widget build(BuildContext context){
    final t=Theme.of(context).extension<NomadThemeExtension>()!;
    return Container(padding:const EdgeInsets.all(AppSpacing.sm),
      decoration:BoxDecoration(color:t.brandPrimary.withAlpha(12),
        borderRadius:BorderRadius.circular(AppSpacing.radiusSm),
        border:Border.all(color:t.brandPrimary.withAlpha(60))),
      child:Text(text,style:AppTypography.monoSmall.copyWith(
        color:t.brandPrimary.withAlpha(200))));
  }
}
