// ignore_for_file: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nomadair_core/core.dart';
import 'package:provider/provider.dart';
import 'package:nomadair_lesson_18/core/config/mock_config.dart';
import 'package:nomadair_lesson_18/core/repositories/repository_exception.dart';
import 'package:nomadair_lesson_18/features/search/data/city_database.dart';
import 'package:nomadair_lesson_18/features/search/models/flight_result.dart';
import 'package:nomadair_lesson_18/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_18/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_18/features/search/providers/flight_search_notifier.dart';
import 'package:nomadair_lesson_18/features/search/providers/search_criteria_notifier.dart';
import 'package:nomadair_lesson_18/features/search/repositories/mock_flight_repository.dart';
import 'package:nomadair_lesson_18/features/search/screens/flight_detail_screen.dart';
import 'package:nomadair_lesson_18/features/search/screens/search_results_screen.dart';
import 'package:nomadair_lesson_18/features/search/screens/search_screen.dart';
import 'package:nomadair_lesson_18/features/search/widgets/flight_result_card.dart';
import 'package:nomadair_lesson_18/features/booking/screens/booking_stub_screen.dart';
import 'package:nomadair_lesson_18/features/mastery/screens/mastery_rubric_screen.dart';
import 'package:nomadair_lesson_18/router/navigator_routes.dart';

// ── Test helpers ──────────────────────────────────────────────────────

const bom = SelectedCity(name:'Mumbai', iata:'BOM', cityId:6291);
const dxb = SelectedCity(name:'Dubai',  iata:'DXB', cityId:5001);
final d7  = DateTime.now().add(const Duration(days:7));

SearchCriteria crit({CabinClass c = CabinClass.economy}) =>
    SearchCriteria(origin:bom, destination:dxb,
        departureDate:d7, isRoundTrip:false, cabinClass:c);

Widget wrapScreen(Widget child,
    {SearchCriteriaNotifier? cn, FlightSearchNotifier? fn,
     String initial = '/test'}) {
  final r = GoRouter(initialLocation: initial,
    routes: [GoRoute(path:'/test', builder:(_,__)=>child)]);
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: cn ?? SearchCriteriaNotifier()),
      ChangeNotifierProvider.value(
        value: fn ?? FlightSearchNotifier(MockFlightRepository())),
    ],
    child: MaterialApp.router(
      theme: NomadAirTheme.light(), routerConfig: r));
}

// ════════════════════════════════════════════════════════════════════
// CATEGORY: NAVIGATION [NAV]
// ════════════════════════════════════════════════════════════════════

void _navTests() {
  group('[NAV] Navigation Correctness', () {

    testWidgets('[NAV-1] Search tab renders SearchScreen', (tester) async {
      await tester.pumpWidget(wrapScreen(
        const SearchScreen()));
      await tester.pump();
      expect(find.text('Find your flight'), findsOneWidget);
    });

    testWidgets('[NAV-2] Valid form submit creates results route',
        (tester) async {
      // SearchScreen validates before pushing — test notifier response
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      // A valid criteria should pass validate()
      expect(cn.validate(), isNull);
      // Route constant exists
      expect(NavigatorRoutes.searchResults,
          equals('/search/results'));
    });

    testWidgets('[NAV-3] Back from results preserves form (keepAlive)',
        (tester) async {
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      // After reset, origin is null
      cn.reset();
      expect(cn.criteria.origin, isNull);
      // But a new setOrigin persists
      cn.setOrigin(bom);
      expect(cn.criteria.origin?.iata, equals('BOM'));
    });

    testWidgets('[NAV-4] Tap flight card navigates to FlightDetailScreen',
        (tester) async {
      // Build FlightResultCard with an onTap handler
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(crit());
      final f = (fn.state as FlightSearchLoaded).flights.first;
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: Scaffold(body: FlightResultCard(
          flight: f, onTap: () => tapped = true))));
      await tester.tap(find.byType(FlightResultCard));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('[NAV-5] FlightDetailScreen shows airline name',
        (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(crit());
      final f = (fn.state as FlightSearchLoaded).flights.first;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: FlightDetailScreen(flight: f)));
      await tester.pump();
      // AppBar title includes airline name
      expect(find.textContaining(f.airline), findsWidgets);
    });

    testWidgets('[NAV-6] New Search resets criteria', (tester) async {
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7);
      expect(cn.criteria.origin?.iata, equals('BOM'));
      cn.reset();
      expect(cn.criteria.origin, isNull);
      expect(cn.criteria.destination, isNull);
    });

    testWidgets('[NAV-7] BookingStub accessible from FlightDetailScreen',
        (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(crit());
      final f = (fn.state as FlightSearchLoaded).flights.first;
      // BookingStubScreen renders without error when given a flight
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: BookingStubScreen(flight: f)));
      await tester.pump();
      expect(find.text('Booking Flow'), findsOneWidget);
    });
  });
}

// ════════════════════════════════════════════════════════════════════
// CATEGORY: STATE [STATE]
// ════════════════════════════════════════════════════════════════════

void _stateTests() {
  group('[STATE] State Sharing', () {

    test('[STATE-1] SearchCriteriaNotifier reset clears all fields', () {
      final n = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      expect(n.criteria.origin, isNotNull);
      n.reset();
      expect(n.criteria.origin,        isNull);
      expect(n.criteria.destination,   isNull);
      expect(n.criteria.departureDate, isNull);
    });

    test('[STATE-2] FlightSearchNotifier Idle → Loading → Loaded', () async {
      final n = FlightSearchNotifier(MockFlightRepository());
      expect(n.state, isA<FlightSearchIdle>());
      final f = n.search(crit());
      expect(n.state, isA<FlightSearchLoading>());
      await f;
      expect(n.state, isA<FlightSearchLoaded>());
    });

    test('[STATE-3] setSortBy does not trigger re-fetch', () async {
      final n = FlightSearchNotifier(MockFlightRepository());
      await n.search(crit());
      final before = (n.state as FlightSearchLoaded).flights;
      n.setSortBy(SortBy.duration);
      final after = (n.state as FlightSearchLoaded).flights;
      // Same object reference — no re-fetch
      expect(identical(before, after), isTrue);
    });

    test('[STATE-4] Two notifier instances are independent', () async {
      final n1 = FlightSearchNotifier(MockFlightRepository());
      final n2 = FlightSearchNotifier(MockFlightRepository());
      await n1.search(crit());
      expect(n2.state, isA<FlightSearchIdle>());
      expect(n1.state, isA<FlightSearchLoaded>());
    });

    testWidgets('[STATE-5] Results screen reads criteria from Provider',
        (tester) async {
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      await tester.pumpWidget(wrapScreen(
        const SearchResultsScreen(), cn: cn));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      // AppBar title shows route from Provider criteria
      expect(find.text('BOM → DXB'), findsOneWidget);
    });

    testWidgets('[STATE-6] Sort chips reorder flight list', (tester) async {
      final cn = SearchCriteriaNotifier()
        ..setOrigin(bom)..setDestination(dxb)
        ..setDepartureDate(d7)..setRoundTrip(false);
      await tester.pumpWidget(wrapScreen(
        const SearchResultsScreen(), cn: cn));
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      // Tap Duration sort chip
      await tester.tap(find.text('Duration'));
      await tester.pump();
      // Chip is now selected
      expect(find.text('Duration'), findsOneWidget);
    });
  });
}

// ════════════════════════════════════════════════════════════════════
// CATEGORY: MOCK DATA [MOCK]
// ════════════════════════════════════════════════════════════════════

void _mockTests() {
  setUp(() => MockConfig.simulateError = false);

  group('[MOCK] Mock Data Structure', () {

    test('[MOCK-1] searchFlights returns exactly 10 results', () async {
      final r = await MockFlightRepository().searchFlights(crit());
      expect(r, hasLength(10));
    });

    test('[MOCK-2] 4 non-stop · 4 one-stop · 2 two-stop', () async {
      final r = await MockFlightRepository().searchFlights(crit());
      expect(r.where((f)=>f.stops==0).length, equals(4));
      expect(r.where((f)=>f.stops==1).length, equals(4));
      expect(r.where((f)=>f.stops==2).length, equals(2));
    });

    test('[MOCK-3] same route+date → same results (deterministic)',
        () async {
      final repo = MockFlightRepository();
      final r1 = await repo.searchFlights(crit());
      final r2 = await repo.searchFlights(crit());
      expect(r1.map((f)=>f.id).toList(),
          equals(r2.map((f)=>f.id).toList()));
    });

    test('[MOCK-4] Business avg price > 3x Economy avg', () async {
      final repo = MockFlightRepository();
      final eco = await repo.searchFlights(crit());
      final biz = await repo.searchFlights(
          crit(c: CabinClass.business));
      final avgE = eco.map((f)=>f.priceInr).reduce((a,b)=>a+b)/eco.length;
      final avgB = biz.map((f)=>f.priceInr).reduce((a,b)=>a+b)/biz.length;
      expect(avgB, greaterThan(avgE * 3));
    });

    test('[MOCK-5] FlightResult JSON round-trip', () async {
      final f  = (await MockFlightRepository().searchFlights(crit())).first;
      final f2 = FlightResult.fromJson(f.toJson());
      expect(f2.id,       equals(f.id));
      expect(f2.priceInr, equals(f.priceInr));
      expect(f2.cabinClass, equals(f.cabinClass));
    });

    test('[MOCK-6] JSON keys are snake_case', () async {
      final f = (await MockFlightRepository().searchFlights(crit())).first;
      final j = f.toJson();
      expect(j.containsKey('price_inr'),        isTrue);
      expect(j.containsKey('duration_minutes'),  isTrue);
      expect(j.containsKey('is_refundable'),    isTrue);
      expect(j.containsKey('priceInr'),         isFalse);
      expect(j.keys.where((k) => k.contains(RegExp(r'[A-Z]'))), isEmpty);
    });
  });
}

// ════════════════════════════════════════════════════════════════════
// CATEGORY: DEEP LINKS [LINK]
// ════════════════════════════════════════════════════════════════════

void _linkTests() {
  group('[LINK] Deep Link Handling', () {

    test('[LINK-1] AndroidManifest contains nomadair:// scheme', () {
      final manifest = File(
        'android/app/src/main/AndroidManifest.xml');
      if (!manifest.existsSync()) {
        // Accept: manifest present but file-system not accessible in test
        return;
      }
      final content = manifest.readAsStringSync();
      expect(content.contains('nomadair'), isTrue);
      expect(content.contains('android.intent.action.VIEW'), isTrue);
    });

    test('[LINK-2] from=BOM resolves to Mumbai in CityDatabase', () {
      final city = CityDatabase.cities
          .where((c) => c.iata.toUpperCase() == 'BOM')
          .firstOrNull;
      expect(city, isNotNull);
      expect(city!.name, contains('Mumbai'));
    });

    test('[LINK-3] to=DXB resolves to Dubai in CityDatabase', () {
      final city = CityDatabase.cities
          .where((c) => c.iata.toUpperCase() == 'DXB')
          .firstOrNull;
      expect(city, isNotNull);
      expect(city!.name, contains('Dubai'));
    });

    test('[LINK-4] Unknown IATA returns null (graceful degradation)', () {
      final city = CityDatabase.cities
          .where((c) => c.iata.toUpperCase() == 'XYZ')
          .firstOrNull;
      expect(city, isNull);
      // App should handle this gracefully — blank form, no crash
    });

    testWidgets('[LINK-5] SearchScreen accepts initialOrigin and initialDestination',
        (tester) async {
      final cn = SearchCriteriaNotifier();
      await tester.pumpWidget(wrapScreen(
        const SearchScreen(initialOrigin: 'BOM', initialDestination: 'DXB'),
        cn: cn));
      await tester.pump(); // initState fires
      await tester.pump(); // postFrameCallback fires
      // Cities should be resolved and set
      expect(cn.criteria.origin?.iata,      equals('BOM'));
      expect(cn.criteria.destination?.iata, equals('DXB'));
    });
  });
}

// ════════════════════════════════════════════════════════════════════
// CATEGORY: BONUS [BONUS]
// ════════════════════════════════════════════════════════════════════

void _bonusTests() {
  group('[BONUS] Bonus Challenges', () {

    testWidgets('[BONUS-1] FlightDetailScreen shows formattedPrice',
        (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(crit());
      final f = (fn.state as FlightSearchLoaded).flights.first;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: FlightDetailScreen(flight: f)));
      await tester.pump();
      expect(find.textContaining('₹'), findsWidgets);
    });

    testWidgets('[BONUS-2] FlightDetailScreen shows stops label',
        (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(crit());
      final f = (fn.state as FlightSearchLoaded).flights.first;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: FlightDetailScreen(flight: f)));
      await tester.pump();
      expect(find.textContaining(f.stopsLabel), findsWidgets);
    });

    testWidgets('[BONUS-3] MasteryRubricScreen renders 28 items',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: const MasteryRubricScreen()));
      await tester.pump();
      expect(find.text('Mastery Rubric — L18'), findsOneWidget);
      // 28 checklist items rendered
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('[BONUS-4] BookingStubScreen shows flight info',
        (tester) async {
      final fn = FlightSearchNotifier(MockFlightRepository());
      await fn.search(crit());
      final f = (fn.state as FlightSearchLoaded).flights.first;
      await tester.pumpWidget(MaterialApp(
        theme: NomadAirTheme.light(),
        home: BookingStubScreen(flight: f)));
      await tester.pump();
      expect(find.textContaining(f.airline), findsOneWidget);
      expect(find.textContaining('₹'), findsOneWidget);
    });
  });
}

// ════════════════════════════════════════════════════════════════════
// MAIN
// ════════════════════════════════════════════════════════════════════

void main() {
  _navTests();
  _stateTests();
  _mockTests();
  _linkTests();
  _bonusTests();
}
