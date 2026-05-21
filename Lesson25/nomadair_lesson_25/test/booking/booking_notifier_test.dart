import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_25/features/booking/models/booking_error.dart';
import 'package:nomadair_lesson_25/features/booking/providers/booking_notifier.dart';
import 'package:nomadair_lesson_25/features/search/models/flight_result.dart';
import 'package:nomadair_lesson_25/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_25/features/search/repositories/flight_repository.dart';
import 'package:nomadair_lesson_25/core/network/network_exception.dart';

// ── Minimal stub FlightRepository ────────────────────────────────────────
final class _StubRepo implements FlightRepository {
  _StubRepo({this.detailResult, this.detailError});
  final FlightResult?   detailResult;
  final Exception?      detailError;

  @override Future<List<FlightResult>> searchFlights(
      SearchCriteria _) async => [];

  @override Future<FlightResult?> getFlightDetails(String id) async {
    if (detailError != null) throw detailError!;
    return detailResult;
  }
}

// ── Test flight ───────────────────────────────────────────────────────────
FlightResult _flight({double price = 12500.0}) => FlightResult(
  id: 'FL001', airline: 'Air India', airlineCode: 'AI',
  flightNumber: 'AI 237', baggageAllowance: '23 kg',
  origin: 'BOM', destination: 'DXB',
  departureTime: DateTime(2025, 8, 15, 10),
  arrivalTime:   DateTime(2025, 8, 15, 13),
  durationMinutes: 180, stops: 0,
  cabinClass: CabinClass.economy,
  priceInr: price, seatsLeft: 5, isRefundable: true);

void main() {
  group('BookingNotifier', () {

    group('initial state', () {
      test('starts as BookingIdle', () {
        final n = BookingNotifier(_StubRepo());
        expect(n.state, isA<BookingIdle>());
      });
    });

    group('confirmBooking — success', () {
      test('transitions Idle → Loading → Confirmed', () async {
        final states = <BookingState>[];
        final n = BookingNotifier(
            _StubRepo(detailResult: _flight()));
        n.addListener(() => states.add(n.state));
        await n.confirmBooking(_flight());
        expect(states[0], isA<BookingLoading>());
        expect(states[1], isA<BookingConfirmed>());
      });

      test('Confirmed state has a booking reference', () async {
        final n = BookingNotifier(
            _StubRepo(detailResult: _flight()));
        await n.confirmBooking(_flight());
        final c = n.state as BookingConfirmed;
        expect(c.bookingRef, isNotEmpty);
      });

      test('Confirmed state contains the flight', () async {
        final f = _flight();
        final n = BookingNotifier(_StubRepo(detailResult: f));
        await n.confirmBooking(f);
        expect((n.state as BookingConfirmed).flight.id, 'FL001');
      });

      test('confirmedAt is recent (within 5s)', () async {
        final n = BookingNotifier(
            _StubRepo(detailResult: _flight()));
        await n.confirmBooking(_flight());
        final dt = (n.state as BookingConfirmed).confirmedAt;
        expect(
          DateTime.now().difference(dt).inSeconds,
          lessThan(5));
      });
    });

    group('confirmBooking — 404 flight unavailable', () {
      test('null detailResult → FlightUnavailableError', () async {
        final n = BookingNotifier(_StubRepo(detailResult: null));
        await n.confirmBooking(_flight());
        expect(n.state, isA<BookingFailed>());
        expect((n.state as BookingFailed).error,
            isA<FlightUnavailableError>());
      });

      test('FlightUnavailableError carries flightId', () async {
        final n = BookingNotifier(_StubRepo(detailResult: null));
        await n.confirmBooking(_flight());
        final err = (n.state as BookingFailed).error
            as FlightUnavailableError;
        expect(err.flightId, 'FL001');
      });

      test('canRetry is false for FlightUnavailableError', () async {
        final n = BookingNotifier(_StubRepo(detailResult: null));
        await n.confirmBooking(_flight());
        expect((n.state as BookingFailed).canRetry, isFalse);
      });
    });

    group('confirmBooking — price changed', () {
      test('>1% price increase → PriceChangedError', () async {
        // original 12500, returned 13500 → 8% increase
        final n = BookingNotifier(
            _StubRepo(detailResult: _flight(price: 13500)));
        await n.confirmBooking(_flight(price: 12500));
        expect((n.state as BookingFailed).error,
            isA<PriceChangedError>());
      });

      test('PriceChangedError carries original and new price', () async {
        final n = BookingNotifier(
            _StubRepo(detailResult: _flight(price: 13500)));
        await n.confirmBooking(_flight(price: 12500));
        final e = (n.state as BookingFailed).error as PriceChangedError;
        expect(e.originalPrice, 12500.0);
        expect(e.newPrice,      13500.0);
      });

      test('priceIncreased is true when new > original', () async {
        final e = PriceChangedError(
            originalPrice: 12500, newPrice: 13500);
        expect(e.priceIncreased, isTrue);
      });

      test('price within 1% tolerance → Confirmed', () async {
        // 0.5% increase — within tolerance
        final n = BookingNotifier(
            _StubRepo(detailResult: _flight(price: 12563)));
        await n.confirmBooking(_flight(price: 12500));
        expect(n.state, isA<BookingConfirmed>());
      });
    });

    group('network error + retry', () {
      test('NetworkException → NetworkError in BookingFailed', () async {
        final n = BookingNotifier(
            _StubRepo(detailError: const NetworkTimeoutException()));
        await n.confirmBooking(_flight());
        expect((n.state as BookingFailed).error, isA<NetworkError>());
      });

      test('canRetry is true for NetworkError', () async {
        final n = BookingNotifier(
            _StubRepo(detailError: const NetworkTimeoutException()));
        await n.confirmBooking(_flight());
        expect((n.state as BookingFailed).canRetry, isTrue);
      });
    });

    group('reset', () {
      test('reset returns to BookingIdle', () async {
        final n = BookingNotifier(_StubRepo(detailResult: null));
        await n.confirmBooking(_flight());
        n.reset();
        expect(n.state, isA<BookingIdle>());
      });
    });

  });
}
