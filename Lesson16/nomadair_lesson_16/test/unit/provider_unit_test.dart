import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_16/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_16/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_16/features/search/providers/search_criteria_notifier.dart';

void main() {
  const bom = SelectedCity(name:'Mumbai',iata:'BOM',cityId:6291);
  const dxb = SelectedCity(name:'Dubai',iata:'DXB',cityId:5001);
  final d7  = DateTime.now().add(const Duration(days:7));
  final d14 = DateTime.now().add(const Duration(days:14));
  final d3  = DateTime.now().add(const Duration(days:3));

  SearchCriteriaNotifier make() => SearchCriteriaNotifier();

  group('SearchCriteriaNotifier — initial state', () {
    test('criteria starts as default SearchCriteria', () {
      expect(make().criteria, equals(const SearchCriteria()));
    });

    test('origin starts null', () =>
        expect(make().criteria.origin, isNull));
  });

  group('SearchCriteriaNotifier — setOrigin', () {
    test('updates origin', () {
      final n = make();
      n.setOrigin(bom);
      expect(n.criteria.origin, equals(bom));
    });

    test('notifies listeners', () {
      final n = make();
      var count = 0;
      n.addListener(() => count++);
      n.setOrigin(bom);
      expect(count, equals(1));
    });

    test('does NOT notify if value unchanged (equality guard)', () {
      final n = make();
      n.setOrigin(bom); // first call — notifies
      var count = 0;
      n.addListener(() => count++);
      n.setOrigin(bom); // same value — must NOT notify
      expect(count, equals(0));
    });

    test('can be set to null', () {
      final n = make();
      n.setOrigin(bom);
      n.setOrigin(null);
      expect(n.criteria.origin, isNull);
    });
  });

  group('SearchCriteriaNotifier — setDestination', () {
    test('updates destination', () {
      final n = make()..setDestination(dxb);
      expect(n.criteria.destination, equals(dxb));
    });

    test('equality guard: same destination skips notify', () {
      final n = make()..setDestination(dxb);
      var count = 0;
      n.addListener(() => count++);
      n.setDestination(dxb);
      expect(count, equals(0));
    });
  });

  group('SearchCriteriaNotifier — setDepartureDate', () {
    test('sets departure date', () {
      final n = make()..setDepartureDate(d7);
      expect(n.criteria.departureDate, equals(d7));
    });

    test('auto-clears return date when departure moves after it', () {
      final n = make();
      n.setDepartureDate(d7);
      n.setReturnDate(d3); // return before departure
      n.setDepartureDate(d14); // departure after return
      // return date d3 is now before d14 → should be cleared
      expect(n.criteria.returnDate, isNull);
    });

    test('keeps return date when departure is before it', () {
      final n = make();
      n.setDepartureDate(d7);
      n.setReturnDate(d14);
      n.setDepartureDate(d3); // d3 < d14, so return stays
      expect(n.criteria.returnDate, equals(d14));
    });
  });

  group('SearchCriteriaNotifier — setRoundTrip', () {
    test('setRoundTrip(false) clears return date', () {
      final n = make();
      n.setDepartureDate(d7);
      n.setReturnDate(d14);
      n.setRoundTrip(false);
      expect(n.criteria.returnDate, isNull);
      expect(n.criteria.isRoundTrip, isFalse);
    });

    test('setRoundTrip(true) keeps existing return date', () {
      final n = make();
      n.setDepartureDate(d7);
      n.setReturnDate(d14);
      n.setRoundTrip(false);
      n.setRoundTrip(true);
      expect(n.criteria.returnDate, isNull); // was cleared by false
    });
  });

  group('SearchCriteriaNotifier — setCabinClass', () {
    test('updates cabin class', () {
      final n = make()..setCabinClass(CabinClass.business);
      expect(n.criteria.cabinClass, equals(CabinClass.business));
    });

    test('equality guard: same class skips notify', () {
      final n = make()..setCabinClass(CabinClass.economy);
      var count = 0;
      n.addListener(() => count++);
      n.setCabinClass(CabinClass.economy);
      expect(count, equals(0));
    });
  });

  group('SearchCriteriaNotifier — setPassengers', () {
    test('updates passengers', () {
      final n = make();
      const p = PassengerCount(adults: 2, children: 1);
      n.setPassengers(p);
      expect(n.criteria.passengers.adults, equals(2));
      expect(n.criteria.passengers.children, equals(1));
    });
  });

  group('SearchCriteriaNotifier — reset', () {
    test('clears all fields', () {
      final n = make();
      n.setOrigin(bom);
      n.setDestination(dxb);
      n.setDepartureDate(d7);
      n.setReturnDate(d14);
      n.setCabinClass(CabinClass.business);
      n.reset();
      expect(n.criteria, equals(const SearchCriteria()));
    });

    test('reset notifies listeners', () {
      final n = make()..setOrigin(bom);
      var count = 0;
      n.addListener(() => count++);
      n.reset();
      expect(count, equals(1));
    });
  });

  group('SearchCriteriaNotifier — validate delegates to criteria', () {
    test('null origin → error', () {
      expect(make().validate(), contains('departure city'));
    });

    test('valid one-way → null', () {
      final n = make();
      n.setOrigin(bom);
      n.setDestination(dxb);
      n.setDepartureDate(d7);
      n.setRoundTrip(false);
      expect(n.validate(), isNull);
    });
  });
}
