import '../models/booking_request.dart';

/// Booking feature state — placeholder.
///
/// Replaced by CheckoutBloc in Lesson 35.
/// The seven sealed states (CheckoutIdle, CheckoutLoading, SeatSelected,
/// PassengerFilled, PaymentPending, BookingConfirmed, BookingFailed)
/// will be defined in Lesson 35.
final class BookingState {
  const BookingState({this.request, this.loading=false, this.error});
  final BookingRequest? request;
  final bool            loading;
  final String?         error;
  BookingState copyWith({BookingRequest? request, bool? loading, String? error})=>
      BookingState(
        request: request ?? this.request,
        loading: loading ?? this.loading,
        error:   error);
}
