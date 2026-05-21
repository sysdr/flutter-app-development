// Sealed union for all booking-layer failures.
//
// FlightUnavailableError (404) — the flight offer has expired or sold out.
//   User action: go back to search results and pick another flight.
//
// PriceChangedError (412 / changed fare) — the price in the offer
//   no longer matches the current price.
//   User action: review the new price and confirm or decline.
//
// NetworkError — any transient network problem.
//   User action: retry.
sealed class BookingError {
  const BookingError();
}

final class FlightUnavailableError extends BookingError {
  const FlightUnavailableError(this.flightId);
  final String flightId;
  @override String toString() =>
      'FlightUnavailableError: flight $flightId no longer available';
}

final class PriceChangedError extends BookingError {
  const PriceChangedError({
    required this.originalPrice,
    required this.newPrice,
  });
  final double originalPrice;
  final double newPrice;
  bool   get priceIncreased  => newPrice > originalPrice;
  double get priceDelta      => newPrice - originalPrice;
  String get formattedDelta  =>
      '₹${priceDelta.abs().toStringAsFixed(0)}';
  @override String toString() =>
      'PriceChangedError: ₹$originalPrice → ₹$newPrice';
}

final class NetworkError extends BookingError {
  const NetworkError(this.message);
  final String message;
  @override String toString() => 'NetworkError: $message';
}
