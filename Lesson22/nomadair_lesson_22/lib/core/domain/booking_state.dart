import 'package:freezed_annotation/freezed_annotation.dart';
import 'itinerary.dart';

part 'booking_state.freezed.dart';

/// Lesson 19 â€” Booking lifecycle as a Freezed union type.
///
/// Compare with the hand-written [FlightSearchState] sealed class in L17.
/// Freezed generates [when], [maybeWhen], [map], [maybeMap] for
/// exhaustive dispatch â€” a missing variant is a *compile error*.
///
/// Usage:
///   state.when(
///     idle:      ()       => const _IdleView(),
///     loading:   (msg)    => _LoadingView(message: msg),
///     confirmed: (itin)   => _ConfirmedView(itinerary: itin),
///     failed:    (err, _) => _FailedView(error: err),
///   );
@freezed
class BookingState with _$BookingState {
  const factory BookingState.idle()
      = Idle;
  const factory BookingState.loading({required String message})
      = Loading;
  const factory BookingState.confirmed({required Itinerary itinerary})
      = Confirmed;
  const factory BookingState.failed({
    required String error,
    int?            statusCode,
  }) = Failed;
}
