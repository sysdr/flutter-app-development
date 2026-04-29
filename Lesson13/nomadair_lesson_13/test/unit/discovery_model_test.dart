import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_13/features/discovery/models/destination_model.dart';

void main() {
  group('DiscoveryDestination', () {
    test('samples contains 6 destinations', () =>
        expect(DiscoveryDestination.samples.length, equals(6)));

    test('all samples have unique IDs', () {
      final ids = DiscoveryDestination.samples.map((d) => d.id).toSet();
      expect(ids.length, equals(6));
    });

    test('all samples have non-empty accessibility labels', () {
      for (final d in DiscoveryDestination.samples) {
        expect(d.accessibilityLabel.trim().isNotEmpty, isTrue,
            reason: '${d.city} has empty label');
      }
    });

    test('isTrending true when trendingRank set', () {
      const d = DiscoveryDestination(
        id:'test',city:'X',country:'Y',iataCode:'XYZ',tagline:'T',
        priceFromInr:1000,category:'flights',
        skyColorTop:0xFF000000,skyColorBottom:0xFF000000,trendingRank:1);
      expect(d.isTrending, isTrue);
    });

    test('isTrending false when trendingRank null', () {
      const d = DiscoveryDestination(
        id:'t2',city:'Z',country:'W',iataCode:'ZZZ',tagline:'T',
        priceFromInr:999,category:'hotels',
        skyColorTop:0xFF000000,skyColorBottom:0xFF000000);
      expect(d.isTrending, isFalse);
    });

    test('flights filter retains flights and both categories', () {
      final flights = DiscoveryDestination.samples.where(
          (d) => d.category == 'flights' || d.category == 'both').toList();
      expect(flights.isNotEmpty, isTrue);
      for (final d in flights) {
        expect(d.category == 'flights' || d.category == 'both', isTrue);
      }
    });

    test('hotels filter retains hotels and both categories', () {
      final hotels = DiscoveryDestination.samples.where(
          (d) => d.category == 'hotels' || d.category == 'both').toList();
      // At least one hotel exists
      expect(hotels.isNotEmpty, isTrue);
    });

    test('formattedPrice contains rupee symbol', () {
      for (final d in DiscoveryDestination.samples) {
        expect(d.formattedPrice, contains('₹'));
      }
    });
  });
}
