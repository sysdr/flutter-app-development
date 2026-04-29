import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_14/features/search/data/city_database.dart';
import 'package:nomadair_lesson_14/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_14/features/search/models/search_criteria.dart';

void main() {
  group('CityDatabase.search', () {
    test('returns results for valid query', () {
      final r = CityDatabase.search('Mum');
      expect(r, isNotEmpty);
      expect(r.first.iata, equals('BOM'));
    });

    test('returns empty for short query (< 2 chars)', () =>
        expect(CityDatabase.search('M'), isEmpty));

    test('returns empty for no match', () =>
        expect(CityDatabase.search('XYZ99'), isEmpty));

    test('search is case-insensitive', () {
      final upper = CityDatabase.search('DUBAI');
      final lower = CityDatabase.search('dubai');
      expect(upper, isNotEmpty);
      expect(lower.length, equals(upper.length));
    });

    test('search by IATA code', () {
      final r = CityDatabase.search('BOM');
      expect(r.any((c) => c.iata == 'BOM'), isTrue);
    });

    test('returns at most 6 results', () {
      // 'a' matches many — should cap at 6
      final r = CityDatabase.search('a');
      expect(r.length, lessThanOrEqualTo(6));
    });
  });

  group('SelectedCity', () {
    const bom = SelectedCity(
      name: 'Mumbai Chhatrapati Shivaji', iata: 'BOM', cityId: 6291);
    const dxb = SelectedCity(
      name: 'Dubai International', iata: 'DXB', cityId: 5001);

    test('displayName formats correctly', () =>
        expect(bom.displayName,
            equals('Mumbai Chhatrapati Shivaji (BOM)')));

    test('equality by IATA', () {
      const bom2 = SelectedCity(
        name: 'Mumbai', iata: 'BOM', cityId: 6291);
      expect(bom, equals(bom2));
    });

    test('different IATAs not equal', () =>
        expect(bom == dxb, isFalse));
  });

  group('PassengerCount', () {
    test('default: 1 adult, total = 1', () {
      const p = PassengerCount();
      expect(p.total, equals(1));
    });

    test('summary for 2 adults 1 child', () {
      const p = PassengerCount(adults: 2, children: 1);
      expect(p.summary, contains('2 Adults'));
      expect(p.summary, contains('1 Child'));
    });

    test('infant singular form', () {
      const p = PassengerCount(adults: 1, infants: 1);
      expect(p.summary, contains('1 Infant'));
    });

    test('children plural form', () {
      const p = PassengerCount(adults: 2, children: 2);
      expect(p.summary, contains('2 Children'));
    });
  });

  group('SearchCriteria.validate', () {
    const bom = SelectedCity(
      name: 'Mumbai', iata: 'BOM', cityId: 6291);
    const dxb = SelectedCity(
      name: 'Dubai', iata: 'DXB', cityId: 5001);
    final future7 = DateTime.now().add(const Duration(days: 7));
    final future14 = DateTime.now().add(const Duration(days: 14));

    test('null origin → error', () {
      const c = SearchCriteria(destination: dxb);
      expect(c.validate(), contains('departure city'));
    });

    test('null destination → error', () {
      final c = SearchCriteria(origin: bom, departureDate: future7);
      expect(c.validate(), contains('destination city'));
    });

    test('same origin and destination → error', () {
      final c = SearchCriteria(
        origin: bom, destination: bom, departureDate: future7);
      expect(c.validate(), contains('same city'));
    });

    test('null departure date → error', () {
      const c = SearchCriteria(origin: bom, destination: dxb);
      expect(c.validate(), contains('departure date'));
    });

    test('return before departure → error', () {
      final c = SearchCriteria(
        origin: bom, destination: dxb,
        departureDate: future14, returnDate: future7,
        isRoundTrip: true);
      expect(c.validate(), contains('Return date'));
    });

    test('valid one-way → null', () {
      final c = SearchCriteria(
        origin: bom, destination: dxb,
        departureDate: future7, isRoundTrip: false);
      expect(c.validate(), isNull);
    });

    test('valid round-trip → null', () {
      final c = SearchCriteria(
        origin: bom, destination: dxb,
        departureDate: future7, returnDate: future14,
        isRoundTrip: true);
      expect(c.validate(), isNull);
    });

    test('departureDateDisplay formats correctly', () {
      final c = SearchCriteria(
        departureDate: DateTime(2025, 3, 15));
      expect(c.departureDateDisplay, equals('15 Mar 2025'));
    });
  });
}
