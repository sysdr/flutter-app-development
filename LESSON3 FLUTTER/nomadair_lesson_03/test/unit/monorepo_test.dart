import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_core/core.dart';
import 'package:nomadair_data/data.dart';

void main() {
  group('FlightModel (nomadair_core)', () {
    const flight = FlightModel(
      id: 'AI-101',
      airline: 'Air India',
      origin: 'BOM',
      destination: 'DEL',
      durationMinutes: 125,
      priceInr: 4200,
      stops: 0,
    );

    test('formattedDuration returns correct hours and minutes', () {
      expect(flight.formattedDuration, equals('2h 5m'));
    });

    test('formattedPrice uses Indian rupee symbol', () {
      expect(flight.formattedPrice, equals('₹4200'));
    });

    test('stopsLabel returns Non-stop for zero stops', () {
      expect(flight.stopsLabel, equals('Non-stop'));
    });

    test('stopsLabel returns plural for multiple stops', () {
      const connecting = FlightModel(
        id: 'X',
        airline: 'X',
        origin: 'A',
        destination: 'B',
        durationMinutes: 300,
        priceInr: 10000,
        stops: 2,
      );
      expect(connecting.stopsLabel, equals('2 stops'));
    });

    test('route getter concatenates origin and destination', () {
      expect(flight.route, equals('BOM → DEL'));
    });

    test('toString includes all key fields', () {
      final s = flight.toString();
      expect(s, contains('AI-101'));
      expect(s, contains('Air India'));
      expect(s, contains('BOM → DEL'));
    });
  });

  group('MockFlightRepository (nomadair_data)', () {
    const repo = MockFlightRepository();

    test('implements FlightRepository from core', () {
      // If this assignment compiles, the interface contract is satisfied
      const FlightRepository _ = MockFlightRepository();
      expect(true, isTrue); // compile-time guarantee
    });

    test('fetchFlights returns correct flights for BOM → DEL', () async {
      final flights = await repo.fetchFlights(
        origin: 'BOM',
        destination: 'DEL',
      );
      expect(flights, isNotEmpty);
      expect(flights.every((f) => f.origin == 'BOM'), isTrue);
      expect(flights.every((f) => f.destination == 'DEL'), isTrue);
    });

    test('fetchFlights returns empty list for unknown route', () async {
      final flights = await repo.fetchFlights(
        origin: 'XYZ',
        destination: 'ABC',
      );
      expect(flights, isEmpty);
    });

    test('fetchFlightById returns correct flight', () async {
      final flight = await repo.fetchFlightById('AI-101');
      expect(flight, isNotNull);
      expect(flight!.airline, equals('Air India'));
    });

    test('fetchFlightById returns null for unknown id', () async {
      final flight = await repo.fetchFlightById('UNKNOWN');
      expect(flight, isNull);
    });

    test('fetchFlights result prices are all positive', () async {
      final flights = await repo.fetchFlights(
        origin: 'BOM',
        destination: 'DEL',
      );
      expect(flights.every((f) => f.priceInr > 0), isTrue);
    });
  });

  group('Design tokens (nomadair_core)', () {
    test('AppColors.brandPrimary has expected hex value', () {
      expect(AppColors.brandPrimary.value, equals(0xFF1A73E8));
    });

    test('AppSpacing values are multiples of 4', () {
      expect(AppSpacing.xs  % 4, equals(0));
      expect(AppSpacing.sm  % 4, equals(0));
      expect(AppSpacing.md  % 4, equals(0));
      expect(AppSpacing.lg  % 4, equals(0));
    });
  });
}
