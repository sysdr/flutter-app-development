import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:provider/provider.dart';
import 'package:nomadair_lesson_17/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_17/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_17/features/search/providers/flight_search_notifier.dart';
import 'package:nomadair_lesson_17/features/search/providers/search_criteria_notifier.dart';
import 'package:nomadair_lesson_17/core/config/mock_config.dart';
import 'package:nomadair_lesson_17/features/search/repositories/mock_flight_repository.dart';
import 'package:nomadair_lesson_17/features/search/screens/search_results_screen.dart';
import 'package:nomadair_lesson_17/features/search/widgets/flight_result_card.dart';

Widget _wrap(Widget child,
    {SearchCriteriaNotifier? crit, FlightSearchNotifier? flight}) {
  final router = GoRouter(initialLocation:'/t',
    routes:[GoRoute(path:'/t', builder:(_, __)=>child)]);
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: crit ?? SearchCriteriaNotifier()),
      ChangeNotifierProvider.value(
        value: flight ?? FlightSearchNotifier(MockFlightRepository())),
    ],
    child: MaterialApp.router(
      theme: NomadAirTheme.light(), routerConfig: router));
}

void main() {
  const bom = SelectedCity(name:'Mumbai', iata:'BOM', cityId:6291);
  const dxb = SelectedCity(name:'Dubai',  iata:'DXB', cityId:5001);
  final d7  = DateTime.now().add(const Duration(days:7));

  setUp(() {
    MockConfig.minDelayMs = 0;
    MockConfig.maxDelayMs = 0;
  });
  tearDown(() {
    MockConfig.minDelayMs = 300;
    MockConfig.maxDelayMs = 800;
  });

  group('SearchResultsScreen', () {
    testWidgets('search completes from initState', (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);

      await tester.pumpWidget(_wrap(
        const SearchResultsScreen(), crit:cn, flight:fn));
      await tester.pumpAndSettle();
      expect(fn.state, isA<FlightSearchLoaded>());
    });

    testWidgets('loaded state has 10 flights (ListView is lazy)', (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      await tester.pumpWidget(_wrap(
        const SearchResultsScreen(), crit:cn, flight:fn));
      await tester.pumpAndSettle();
      final loaded = fn.state as FlightSearchLoaded;
      expect(loaded.flights, hasLength(10));
      expect(find.byType(FlightResultCard), findsWidgets);
    });

    testWidgets('AppBar shows route from Provider', (tester) async {
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      await tester.pumpWidget(_wrap(
        const SearchResultsScreen(), crit:cn));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds:2));
      expect(find.text('BOM → DXB'), findsOneWidget);
    });

    testWidgets('sort chips present after load', (tester) async {
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      await tester.pumpWidget(_wrap(
        const SearchResultsScreen(), crit:cn));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds:2));
      expect(find.text('Price ↑'), findsOneWidget);
      expect(find.text('Duration'),    findsOneWidget);
      expect(find.text('Departure'),   findsOneWidget);
    });

    testWidgets('"X flights found" label shown', (tester) async {
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      await tester.pumpWidget(_wrap(
        const SearchResultsScreen(), crit:cn));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds:2));
      expect(find.text('10 flights found'), findsOneWidget);
    });
  });

  group('FlightResultCard', () {
    testWidgets('renders airline name and price', (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(SearchCriteria(
        origin:bom, destination:dxb, departureDate:d7,
        isRoundTrip:false));
      final f = (fn.state as FlightSearchLoaded).flights.first;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: Scaffold(body: FlightResultCard(flight:f))));
      expect(find.textContaining(f.airline), findsOneWidget);
      expect(find.textContaining('₹'),  findsOneWidget);
    });

    testWidgets('low-seat warning shown when seatsLeft <= 5',
        (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(SearchCriteria(
        origin:bom, destination:dxb, departureDate:d7,
        isRoundTrip:false));
      final low = (fn.state as FlightSearchLoaded)
          .flights.where((f) => f.seatsLeft <= 5).toList();
      if (low.isEmpty) return;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: Scaffold(body: FlightResultCard(flight:low.first))));
      expect(find.textContaining('left!'), findsOneWidget);
    });
  });
}
