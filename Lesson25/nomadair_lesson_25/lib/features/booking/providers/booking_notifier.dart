import 'package:flutter/foundation.dart';
import '../../../core/network/network_exception.dart';
import '../../search/models/flight_result.dart';
import '../../search/repositories/flight_repository.dart';
import '../models/booking_error.dart';

// States for the booking confirmation flow.
sealed class BookingState { const BookingState(); }

final class BookingIdle    extends BookingState { const BookingIdle(); }
final class BookingLoading extends BookingState { const BookingLoading(); }

final class BookingConfirmed extends BookingState {
  const BookingConfirmed({
    required this.flight,
    required this.bookingRef,
    required this.confirmedAt,
  });
  final FlightResult flight;
  final String       bookingRef;
  final DateTime     confirmedAt;
}

final class BookingFailed extends BookingState {
  const BookingFailed(this.error);
  final BookingError error;
  bool get canRetry => error is NetworkError;
}

// Manages the booking confirmation flow.
//
// confirmBooking():
//   1. Set Loading state.
//   2. Call repository.getFlightDetails(flightId) to verify availability.
//   3a. If details returned and price unchanged → Confirmed.
//   3b. If details price differs from original price → PriceChangedError.
//   3c. If details is null (404) → FlightUnavailableError.
//   3d. Network exception → NetworkError.
//
// retry(): only valid when state is BookingFailed with canRetry == true.
final class BookingNotifier extends ChangeNotifier {
  BookingNotifier(this._repo);
  final FlightRepository _repo;

  BookingState _state = const BookingIdle();
  BookingState get state => _state;

  void _emit(BookingState s) { _state = s; notifyListeners(); }

  Future<void> confirmBooking(FlightResult flight) async {
    _emit(const BookingLoading());
    try {
      final details = await _repo.getFlightDetails(flight.id);
      if (details == null) {
        _emit(BookingFailed(
            FlightUnavailableError(flight.id)));
        return;
      }
      // Detect price change (>1% tolerance for float rounding)
      final delta = (details.priceInr - flight.priceInr).abs();
      if (delta / flight.priceInr > 0.01) {
        _emit(BookingFailed(
            PriceChangedError(
              originalPrice: flight.priceInr,
              newPrice:      details.priceInr,
            )));
        return;
      }
      _emit(BookingConfirmed(
        flight:      details,
        bookingRef:  'NA${DateTime.now().millisecondsSinceEpoch % 100000}',
        confirmedAt: DateTime.now(),
      ));
    } on HttpStatusException catch (e) {
      if (e.statusCode == 404) {
        _emit(BookingFailed(FlightUnavailableError(flight.id)));
      } else if (e.statusCode == 412) {
        // 412 Precondition Failed — price/availability changed
        _emit(BookingFailed(
            PriceChangedError(
              originalPrice: flight.priceInr,
              newPrice:      flight.priceInr * 1.05, // estimate
            )));
      } else {
        _emit(BookingFailed(
            NetworkError(e.message)));
      }
    } on NetworkException catch (e) {
      _emit(BookingFailed(NetworkError(e.message)));
    }
  }

  void retry(FlightResult flight) {
    if (_state case BookingFailed(canRetry: true)) {
      confirmBooking(flight);
    }
  }

  void reset() => _emit(const BookingIdle());
}
