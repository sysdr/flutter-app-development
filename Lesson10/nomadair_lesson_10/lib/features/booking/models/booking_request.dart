/// Booking domain model — Lesson 10 placeholder.
///
/// In Lesson 19, this becomes a Freezed-generated immutable model
/// with copyWith, equality, and JSON serialization for local caching.
final class SeatSelection {
  const SeatSelection({required this.row, required this.column});
  final int row, column;
  String get seatCode => String.fromCharCode(64 + column) + row.toString();
}

final class BookingRequest {
  const BookingRequest({
    required this.flightId,
    this.seat,
    this.passengerName = '',
    this.passengerEmail = '',
  });
  final String         flightId;
  final SeatSelection? seat;
  final String         passengerName;
  final String         passengerEmail;

  bool get hasPassengerDetails =>
      passengerName.trim().isNotEmpty &&
      passengerEmail.trim().isNotEmpty;
}
