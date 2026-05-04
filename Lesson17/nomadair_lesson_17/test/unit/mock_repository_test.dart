import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_17/core/config/mock_config.dart';
import 'package:nomadair_lesson_17/core/repositories/repository_exception.dart';
import 'package:nomadair_lesson_17/features/search/models/flight_result.dart';
import 'package:nomadair_lesson_17/features/search/models/hotel_result.dart';
import 'package:nomadair_lesson_17/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_17/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_17/features/search/providers/flight_search_notifier.dart';
import 'package:nomadair_lesson_17/features/search/repositories/mock_flight_repository.dart';
import 'package:nomadair_lesson_17/features/search/repositories/mock_hotel_repository.dart';

void main() {
  const bom = SelectedCity(name:'Mumbai', iata:'BOM', cityId:6291);
  const dxb = SelectedCity(name:'Dubai',  iata:'DXB', cityId:5001);
  final d7  = DateTime.now().add(const Duration(days:7));

  SearchCriteria crit({CabinClass c = CabinClass.economy}) =>
      SearchCriteria(origin:bom, destination:dxb,
          departureDate:d7, isRoundTrip:false, cabinClass:c);

  setUp(() {
    MockConfig.simulateError = false;
    MockConfig.useMock       = true;
  });

  group('MockFlightRepository', () {
    test('returns 10 flights', () async {
      final r = await MockFlightRepository().searchFlights(crit());
      expect(r, hasLength(10));
    });

    test('reproducible for same route+date', () async {
      final repo = MockFlightRepository();
      final r1 = await repo.searchFlights(crit());
      final r2 = await repo.searchFlights(crit());
      expect(r1.map((f) => f.id).toList(),
          equals(r2.map((f) => f.id).toList()));
    });

    test('4 non-stop flights', () async {
      final r = await MockFlightRepository().searchFlights(crit());
      expect(r.where((f) => f.stops == 0), hasLength(4));
    });

    test('4 one-stop flights', () async {
      final r = await MockFlightRepository().searchFlights(crit());
      expect(r.where((f) => f.stops == 1), hasLength(4));
    });

    test('2 two-stop flights', () async {
      final r = await MockFlightRepository().searchFlights(crit());
      expect(r.where((f) => f.stops == 2), hasLength(2));
    });

    test('all flights have correct origin/destination', () async {
      final r = await MockFlightRepository().searchFlights(crit());
      expect(r.every((f) => f.origin == 'BOM'), isTrue);
      expect(r.every((f) => f.destination == 'DXB'), isTrue);
    });

    test('business avg price > 3x economy avg', () async {
      final repo = MockFlightRepository();
      final eco = await repo.searchFlights(crit());
      final biz = await repo.searchFlights(crit(c: CabinClass.business));
      final avgE = eco.map((f)=>f.priceInr).reduce((a,b)=>a+b)/eco.length;
      final avgB = biz.map((f)=>f.priceInr).reduce((a,b)=>a+b)/biz.length;
      expect(avgB, greaterThan(avgE * 3));
    });

    test('throws RepositoryException on simulateError', () async {
      MockConfig.simulateError = true;
      expect(
        () => MockFlightRepository().searchFlights(crit()),
        throwsA(isA<RepositoryException>()));
    });
  });

  group('FlightResult JSON', () {
    test('round-trips through JSON', () async {
      final f  = (await MockFlightRepository().searchFlights(crit())).first;
      final f2 = FlightResult.fromJson(f.toJson());
      expect(f2.id,       equals(f.id));
      expect(f2.priceInr, equals(f.priceInr));
      expect(f2.departureTime.millisecondsSinceEpoch,
          equals(f.departureTime.millisecondsSinceEpoch));
    });

    test('JSON uses snake_case keys', () async {
      final f = (await MockFlightRepository().searchFlights(crit())).first;
      final j = f.toJson();
      expect(j.containsKey('price_inr'),       isTrue);
      expect(j.containsKey('duration_minutes'), isTrue);
      expect(j.containsKey('is_refundable'),   isTrue);
      expect(j.containsKey('priceInr'),        isFalse);
    });

    test('no camelCase keys in JSON', () async {
      final f = (await MockFlightRepository().searchFlights(crit())).first;
      final j = f.toJson();
      final bad = j.keys.where((k) => k.contains(RegExp(r'[A-Z]')));
      expect(bad, isEmpty);
    });
  });

  group('MockHotelRepository', () {
    test('returns 5 hotels', () async {
      final r = await MockHotelRepository().searchHotels(
          SearchCriteria(origin:bom, destination:dxb,
            departureDate:d7, isRoundTrip:false));
      expect(r, hasLength(5));
    });

    test('all hotels 3-5 stars', () async {
      final r = await MockHotelRepository().searchHotels(
          SearchCriteria(origin:bom, destination:dxb,
            departureDate:d7, isRoundTrip:false));
      expect(r.every((h) =>
        h.starRating == StarRating.three ||
        h.starRating == StarRating.four  ||
        h.starRating == StarRating.five), isTrue);
    });
  });

  group('FlightSearchNotifier', () {
    FlightSearchNotifier make() =>
        FlightSearchNotifier(MockFlightRepository());

    test('starts Idle', () => expect(make().state, isA<FlightSearchIdle>()));

    test('Loading during search', () async {
      final n = make();
      final f = n.search(crit());
      expect(n.state, isA<FlightSearchLoading>());
      await f;
    });

    test('Loaded after success', () async {
      final n = make(); await n.search(crit());
      expect(n.state, isA<FlightSearchLoaded>());
    });

    test('Loaded has 10 flights', () async {
      final n = make(); await n.search(crit());
      expect((n.state as FlightSearchLoaded).flights, hasLength(10));
    });

    test('Error on simulateError', () async {
      MockConfig.simulateError = true;
      final n = make(); await n.search(crit());
      expect(n.state, isA<FlightSearchError>());
    });

    test('setSortBy reorders without re-fetch', () async {
      final n = make(); await n.search(crit());
      n.setSortBy(SortBy.duration);
      expect((n.state as FlightSearchLoaded).sortBy,
          equals(SortBy.duration));
    });

    test('sorted by price is ascending', () async {
      final n = make(); await n.search(crit());
      n.setSortBy(SortBy.price);
      final s = (n.state as FlightSearchLoaded).sorted;
      for (int i=1; i<s.length; i++) {
        expect(s[i].priceInr, greaterThanOrEqualTo(s[i-1].priceInr));
      }
    });

    test('reset returns to Idle', () async {
      final n = make(); await n.search(crit());
      n.reset();
      expect(n.state, isA<FlightSearchIdle>());
    });

    test('notifies at least twice (Loading + Loaded)', () async {
      final n = make();
      var count = 0;
      n.addListener(() => count++);
      await n.search(crit());
      expect(count, greaterThanOrEqualTo(2));
    });
  });
}
