import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_10/routes/navigator_routes.dart';
import 'package:nomadair_lesson_10/features/discovery/models/destination_model.dart';
import 'package:nomadair_lesson_10/features/discovery/state/discovery_state.dart';
import 'package:nomadair_lesson_10/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_10/features/search/state/search_state.dart';
import 'package:nomadair_lesson_10/features/booking/models/booking_request.dart';

void main() {
  group('NavigatorRoutes constants', () {
    test('all route paths start with /', () {
      for (final r in NavigatorRoutes.all) {
        expect(r.startsWith('/'), isTrue,
            reason: '$r must start with /');
      }
    });

    test('all 11 routes are defined', () =>
        expect(NavigatorRoutes.all.length, equals(11)));

    test('routes are unique', () {
      final set = NavigatorRoutes.all.toSet();
      expect(set.length, equals(NavigatorRoutes.all.length));
    });

    test('feature prefixes are correct', () {
      expect(NavigatorRoutes.discovery,      startsWith('/discovery'));
      expect(NavigatorRoutes.search,         startsWith('/search'));
      expect(NavigatorRoutes.seatMap,        startsWith('/booking'));
      expect(NavigatorRoutes.profile,        startsWith('/profile'));
    });
  });

  group('DiscoveryDestination', () {
    test('samples not empty', () =>
        expect(DiscoveryDestination.samples, isNotEmpty));

    test('isTrending uses trendingRank', () {
      const d = DiscoveryDestination(
        id:'test',city:'X',country:'Y',iataCode:'XYZ',tagline:'t',
        priceFromInr:1000,category:'flights',
        skyColorTop:0xFF000000,skyColorBottom:0xFF000000,
        trendingRank:1);
      expect(d.isTrending, isTrue);
    });

    test('isTrending false when no rank', () {
      const d = DiscoveryDestination(
        id:'t2',city:'Z',country:'W',iataCode:'ZZZ',tagline:'t',
        priceFromInr:999,category:'hotels',
        skyColorTop:0xFF000000,skyColorBottom:0xFF000000);
      expect(d.isTrending, isFalse);
    });
  });

  group('DiscoveryState', () {
    test('all filter returns all samples', () {
      const s = DiscoveryState(filter: DiscoveryFilter.all);
      expect(s.filtered(DiscoveryDestination.samples).length,
          equals(DiscoveryDestination.samples.length));
    });

    test('flights filter keeps flights and both categories', () {
      const s = DiscoveryState(filter: DiscoveryFilter.flights);
      final result = s.filtered(DiscoveryDestination.samples);
      for (final d in result) {
        expect(d.category == 'flights' || d.category == 'both', isTrue);
      }
    });

    test('copyWith preserves unchanged fields', () {
      const s = DiscoveryState(filter: DiscoveryFilter.all, loading: false);
      final s2 = s.copyWith(loading: true);
      expect(s2.filter, equals(DiscoveryFilter.all));
      expect(s2.loading, isTrue);
    });
  });

  group('SearchCriteria', () {
    test('isValid false when fields empty', () =>
        expect(const SearchCriteria().isValid, isFalse));

    test('isValid requires origin, dest, and date', () {
      const c = SearchCriteria(origin: 'BOM', destination: 'DXB');
      expect(c.isValid, isFalse); // no date
    });

    test('isValid true when all required fields set', () {
      final c = SearchCriteria(
        origin: 'BOM', destination: 'DXB',
        departureDate: DateTime.now().add(const Duration(days: 7)));
      expect(c.isValid, isTrue);
    });

    test('PassengerCount.total is sum of all types', () {
      const p = PassengerCount(adults: 2, children: 1, infants: 1);
      expect(p.total, equals(4));
    });
  });

  group('BookingRequest', () {
    test('hasPassengerDetails false when empty', () {
      const r = BookingRequest(flightId: 'AI-101');
      expect(r.hasPassengerDetails, isFalse);
    });

    test('SeatSelection.seatCode formats correctly', () {
      const s = SeatSelection(row: 12, column: 1);
      expect(s.seatCode, equals('A12'));
    });

    test('SeatSelection column 3 = C', () {
      const s = SeatSelection(row: 5, column: 3);
      expect(s.seatCode, equals('C5'));
    });
  });
}
