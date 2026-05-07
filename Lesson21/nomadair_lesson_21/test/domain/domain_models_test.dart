// ignore_for_file: unused_import
import 'package:flutter_test/flutter_test.dart';

import 'package:nomadair_lesson_21/core/domain/flight.dart';
import 'package:nomadair_lesson_21/core/domain/hotel.dart';
import 'package:nomadair_lesson_21/core/domain/passenger.dart';
import 'package:nomadair_lesson_21/core/domain/price_breakdown.dart';
import 'package:nomadair_lesson_21/core/domain/itinerary.dart';
import 'package:nomadair_lesson_21/core/domain/booking_state.dart';
import 'package:nomadair_lesson_21/core/domain/travel_class.dart';
import 'package:nomadair_lesson_21/core/domain_converters.dart';
import 'package:nomadair_lesson_21/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_21/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_21/features/search/repositories/mock_flight_repository.dart';
import 'package:nomadair_lesson_21/features/search/repositories/mock_hotel_repository.dart';

// ── Fixtures ────────────────────────────────────────────────────────────

Flight _flight({
  String id = 'AI237',
  int stops = 0,
  int durationMinutes = 210,
  double priceInr = 18500,
  bool isFavourite = false,
}) =>
    Flight(
      id:               id,
      airline:          'Air India',
      airlineCode:      'AI',
      flightNumber:     'AI 237',
      originIata:       'BOM',
      destinationIata:  'DXB',
      originCity:       'Mumbai',
      destinationCity:  'Dubai',
      departureAt:      DateTime(2026, 6, 15, 6, 30),
      arrivalAt:        DateTime(2026, 6, 15, 10, 0),
      durationMinutes:  durationMinutes,
      travelClass:      TravelClass.economy,
      stops:            stops,
      baggageAllowance: '23 kg',
      isRefundable:     true,
      priceInr:         priceInr,
      seatsAvailable:   12,
      isFavourite:      isFavourite,
    );

Hotel _hotel({String id = 'hotel_1', bool isFavourite = false}) => Hotel(
  id:                   id,
  name:                 'Grand Hyatt Dubai',
  cityIata:             'DXB',
  countryCode:          'AE',
  starRating:           5,
  boardType:            'breakfastIncluded',
  distanceFromCentreKm: 2.5,
  isRefundable:         true,
  reviewScore:          9.2,
  reviewCount:          1450,
  isFavourite:          isFavourite,
);

Passenger _passenger({
  String first = 'Arjun',
  String last  = 'Mehta',
  PassengerType type = PassengerType.adult,
}) =>
    Passenger(
      firstName:   first,
      lastName:    last,
      dateOfBirth: DateTime(1990, 3, 15),
      type:        type,
    );

PriceBreakdown _price({double discount = 0}) => PriceBreakdown(
  baseFare:  14000,
  taxes:     2800,
  fees:      500,
  discount:  discount,
);

Itinerary _itinerary() => Itinerary(
  id:         'itin_001',
  outbound:   _flight(),
  passengers: [_passenger()],
  pricing:    _price(),
);

// ════════════════════════════════════════════════════════════════════════
// FLIGHT — 12 assertions
// ════════════════════════════════════════════════════════════════════════

void _flightTests() {
  group('Flight — copyWith', () {
    test('copyWith(isFavourite: true) updates field', () {
      final f1 = _flight();
      final f2 = f1.copyWith(isFavourite: true);
      expect(f2.isFavourite, isTrue);
      expect(f1.isFavourite, isFalse); // original unchanged
    });

    test('copyWith preserves unchanged fields', () {
      final f1 = _flight();
      final f2 = f1.copyWith(isFavourite: true);
      expect(f2.id,              f1.id);
      expect(f2.airline,         f1.airline);
      expect(f2.durationMinutes, f1.durationMinutes);
      expect(f2.priceInr,        f1.priceInr);
    });

    test('copyWith returns a different instance', () {
      final f = _flight();
      expect(identical(f, f.copyWith(isFavourite: true)), isFalse);
    });
  });

  group('Flight — equality', () {
    test('two identical constructors are equal', () {
      expect(_flight(), equals(_flight()));
    });

    test('same instance is equal to itself', () {
      final f = _flight();
      expect(f, equals(f));
    });

    test('flights with different id are not equal', () {
      expect(_flight(id: 'AI237'), isNot(equals(_flight(id: 'EK500'))));
    });

    test('hashCode matches for equal instances', () {
      expect(_flight().hashCode, equals(_flight().hashCode));
    });
  });

  group('Flight — computed getters', () {
    test('formattedDuration: 3h 30m for 210 min', () {
      expect(_flight(durationMinutes: 210).formattedDuration, '3h 30m');
    });

    test('formattedDuration: no minutes when exactly whole hours', () {
      expect(_flight(durationMinutes: 120).formattedDuration, '2h');
    });

    test('stopsLabel: Non-stop for stops == 0', () {
      expect(_flight(stops: 0).stopsLabel, 'Non-stop');
    });

    test('stopsLabel: singular for stops == 1', () {
      expect(_flight(stops: 1).stopsLabel, '1 stop');
    });

    test('stopsLabel: plural for stops == 2', () {
      expect(_flight(stops: 2).stopsLabel, '2 stops');
    });

    test('formattedPrice starts with rupee symbol', () {
      expect(_flight().formattedPrice, startsWith('₹'));
    });

    test('route arrow notation', () {
      expect(_flight().route, 'BOM → DXB');
    });
  });

  group('Flight — fromFlightResult', () {
    test('fromFlightResult maps all required fields', () async {
      final results = await MockFlightRepository().searchFlights(
          const SearchCriteria(
            origin: SelectedCity(name: 'Mumbai', iata: 'BOM', cityId: 6291),
            destination: SelectedCity(name: 'Dubai', iata: 'DXB', cityId: 5001),
            isRoundTrip: false,
          ));
      final r = results.first;
      final f = Flight.fromFlightResult(r);
      expect(f.id,              r.id);
      expect(f.airline,         r.airline);
      expect(f.originIata,      r.origin);
      expect(f.destinationIata, r.destination);
      expect(f.priceInr,        r.priceInr);
      expect(f.stops,           r.stops);
      expect(f.durationMinutes, r.durationMinutes);
      expect(f.isRefundable,    r.isRefundable);
    });

    test('fromFlightResult defaults isFavourite to false', () async {
      final results = await MockFlightRepository().searchFlights(
          const SearchCriteria(isRoundTrip: false));
      expect(Flight.fromFlightResult(results.first).isFavourite, isFalse);
    });

    test('toDomain() extension equals fromFlightResult()', () async {
      final results = await MockFlightRepository().searchFlights(
          const SearchCriteria(isRoundTrip: false));
      final r = results.first;
      expect(r.toDomain(), equals(Flight.fromFlightResult(r)));
    });

    test('TravelClass.fromCabinClass maps all four values', () {
      for (final cc in CabinClass.values) {
        expect(
          () => TravelClass.fromCabinClass(cc),
          returnsNormally,
        );
      }
    });
  });
}

// ════════════════════════════════════════════════════════════════════════
// HOTEL — 5 assertions
// ════════════════════════════════════════════════════════════════════════

void _hotelTests() {
  group('Hotel', () {
    test('copyWith isFavourite preserves other fields', () {
      final h1 = _hotel();
      final h2 = h1.copyWith(isFavourite: true);
      expect(h2.isFavourite, isTrue);
      expect(h2.name,        h1.name);
      expect(h2.reviewScore, h1.reviewScore);
    });

    test('equality is structural', () {
      expect(_hotel(), equals(_hotel()));
    });

    test('formattedStarRating returns 5 stars for starRating 5', () {
      expect(_hotel().formattedStarRating, '★★★★★');
    });

    test('reviewLabel: Exceptional for score >= 9.0', () {
      expect(_hotel().reviewLabel, 'Exceptional'); // reviewScore: 9.2
    });

    test('toDomain() maps HotelResult fields', () async {
      final results = await MockHotelRepository().searchHotels(
          const SearchCriteria(isRoundTrip: false));
      final r = results.first;
      final h = r.toDomain();
      expect(h.id,          r.id);
      expect(h.name,        r.name);
      expect(h.reviewScore, r.reviewScore);
      expect(h.reviewCount, r.reviewCount);
    });
  });
}

// ════════════════════════════════════════════════════════════════════════
// PASSENGER — 5 assertions
// ════════════════════════════════════════════════════════════════════════

void _passengerTests() {
  group('Passenger', () {
    test('fullName concatenates first + last', () {
      expect(_passenger().fullName, 'Arjun Mehta');
    });

    test('copyWith firstName preserves lastName', () {
      final p = _passenger().copyWith(firstName: 'Priya');
      expect(p.firstName, 'Priya');
      expect(p.lastName,  'Mehta');
    });

    test('equality is structural', () {
      expect(_passenger(), equals(_passenger()));
    });

    test('isMinor false for adult', () {
      expect(_passenger().isMinor, isFalse);
    });

    test('isMinor true for child', () {
      expect(_passenger(type: PassengerType.child).isMinor, isTrue);
    });
  });
}

// ════════════════════════════════════════════════════════════════════════
// PRICE BREAKDOWN — 8 assertions
// ════════════════════════════════════════════════════════════════════════

void _priceTests() {
  group('PriceBreakdown', () {
    test('total = baseFare + taxes + fees (no discount)', () {
      final p = _price(); // 14000 + 2800 + 500 = 17300
      expect(p.total, 17300.0);
    });

    test('total applies surcharges', () {
      final p = _price().copyWith(surcharges: 200);
      expect(p.total, 17500.0);
    });

    test('total deducts discount', () {
      final p = _price(discount: 1000);
      expect(p.total, 16300.0);
    });

    test('total: surcharges + discount combined', () {
      final p = PriceBreakdown(
        baseFare: 10000, taxes: 2000, fees: 500,
        surcharges: 300, discount: 800,
      );
      expect(p.total, 12000.0);
    });

    test('hasDiscount false when discount == 0', () {
      expect(_price().hasDiscount, isFalse);
    });

    test('hasDiscount true when discount > 0', () {
      expect(_price(discount: 500).hasDiscount, isTrue);
    });

    test('formattedTotal starts with rupee symbol', () {
      expect(_price().formattedTotal, startsWith('₹'));
    });

    test('perPerson divides total correctly', () {
      final p = _price(); // total 17300
      expect(p.perPerson(2), 8650.0);
    });
  });
}

// ════════════════════════════════════════════════════════════════════════
// ITINERARY — 6 assertions
// ════════════════════════════════════════════════════════════════════════

void _itineraryTests() {
  group('Itinerary', () {
    test('status defaults to draft', () {
      expect(_itinerary().status, ItineraryStatus.draft);
    });

    test('isRoundTrip false when no returnFlight', () {
      expect(_itinerary().isRoundTrip, isFalse);
    });

    test('isRoundTrip true after copyWith(returnFlight)', () {
      final itin = _itinerary()
          .copyWith(returnFlight: _flight(id: 'EK500'));
      expect(itin.isRoundTrip, isTrue);
    });

    test('includesHotel false by default', () {
      expect(_itinerary().includesHotel, isFalse);
    });

    test('includesHotel true after copyWith(hotel)', () {
      final itin = _itinerary().copyWith(hotel: _hotel());
      expect(itin.includesHotel, isTrue);
    });

    test('isConfirmed true after setting confirmed status', () {
      final itin = _itinerary()
          .copyWith(status: ItineraryStatus.confirmed);
      expect(itin.isConfirmed, isTrue);
      expect(itin.isCancelled, isFalse);
    });
  });
}

// ════════════════════════════════════════════════════════════════════════
// BOOKING STATE — when/maybeWhen — 6 assertions
// ════════════════════════════════════════════════════════════════════════

void _bookingStateTests() {
  group('BookingState.when', () {
    test('idle dispatches to idle branch', () {
      const state = BookingState.idle();
      final label = state.when(
        idle:      ()          => 'idle',
        loading:   (msg)       => 'loading',
        confirmed: (itin)      => 'confirmed',
        failed:    (err, code) => 'failed',
      );
      expect(label, 'idle');
    });

    test('loading dispatches with message', () {
      const state = BookingState.loading(message: 'Processing payment…');
      final msg = state.when(
        idle:      ()          => '',
        loading:   (m)         => m,
        confirmed: (itin)      => '',
        failed:    (err, code) => '',
      );
      expect(msg, 'Processing payment…');
    });

    test('confirmed dispatches with itinerary', () {
      final itin  = _itinerary();
      final state = BookingState.confirmed(itinerary: itin);
      final got = state.when(
        idle:      ()        => null,
        loading:   (m)       => null,
        confirmed: (i)       => i,
        failed:    (e, code) => null,
      );
      expect(got, itin);
    });

    test('failed dispatches with error and statusCode', () {
      const state = BookingState.failed(
          error: 'Payment declined', statusCode: 402);
      final (err, code) = state.when(
        idle:      ()          => ('', null),
        loading:   (m)         => ('', null),
        confirmed: (i)         => ('', null),
        failed:    (e, c)      => (e, c),
      );
      expect(err,  'Payment declined');
      expect(code, 402);
    });

    test('maybeWhen falls back to orElse for unhandled variant', () {
      const state = BookingState.loading(message: 'x');
      final result = state.maybeWhen(
        idle:   () => 'idle',
        orElse: () => 'other',
      );
      expect(result, 'other');
    });

    test('BookingState.idle equality', () {
      expect(
        const BookingState.idle(),
        equals(const BookingState.idle()),
      );
    });
  });
}

// ════════════════════════════════════════════════════════════════════════
// MAIN
// ════════════════════════════════════════════════════════════════════════

void main() {
  _flightTests();     // 12 assertions
  _hotelTests();      //  5 assertions
  _passengerTests();  //  5 assertions
  _priceTests();      //  8 assertions
  _itineraryTests();  //  6 assertions
  _bookingStateTests(); // 6 assertions  ── total: 42
}
