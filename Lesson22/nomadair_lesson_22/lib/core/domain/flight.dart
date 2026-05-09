import 'package:freezed_annotation/freezed_annotation.dart';
import '../../features/search/models/flight_result.dart';
import 'travel_class.dart';

part 'flight.freezed.dart';

/// Lesson 19 â€” Immutable domain model for a single flight leg.
///
/// Why distinct from [FlightResult]?
///   â€¢ [FlightResult] maps 1-to-1 with the API wire format
///   â€¢ [Flight] has UI semantics: computed labels, isFavourite flag,
///     origin/destination city names (not just IATA codes)
///
/// Freezed generates:
///   â€¢ [copyWith] â€” derive modified instances without mutation
///   â€¢ Structural [==] and [hashCode] (value equality, not identity)
///   â€¢ Readable [toString]
///
/// Custom getters work because of [const Flight._();] (private constructor).
@freezed
class Flight with _$Flight {
  const Flight._(); // required for custom getters with Freezed

  const factory Flight({
    required String id,
    required String airline,
    required String airlineCode,
    required String flightNumber,
    required String originIata,
    required String destinationIata,
    required String originCity,
    required String destinationCity,
    required DateTime departureAt,
    required DateTime arrivalAt,
    required int durationMinutes,
    required TravelClass travelClass,
    required int stops,
    required String baggageAllowance,
    required bool isRefundable,
    required double priceInr,
    required int seatsAvailable,
    @Default(false) bool isFavourite,
  }) = _Flight;

  // â”€â”€ Computed getters (enabled by const Flight._();) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  String get formattedDuration {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes  % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  String get formattedPrice => '₹${priceInr.toStringAsFixed(0)}';

  String get stopsLabel =>
      stops == 0 ? 'Non-stop' : '$stops stop${stops == 1 ? '' : 's'}';

  String get route => '$originIata → $destinationIata';

  Duration get flightDuration => Duration(minutes: durationMinutes);

  // â”€â”€ Factory: API model â†’ domain model â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Convert [FlightResult] (search API) to domain [Flight].
  ///
  /// City names use IATA codes as a placeholder â€” resolved from
  /// [CityDatabase] in Lesson 25 when the real API is integrated.
  factory Flight.fromFlightResult(FlightResult r) => Flight(
    id:               r.id,
    airline:          r.airline,
    airlineCode:      r.airlineCode,
    flightNumber:     r.flightNumber,
    originIata:       r.origin,
    destinationIata:  r.destination,
    originCity:       r.origin,       // L25: resolve full city name
    destinationCity:  r.destination,  // L25: resolve full city name
    departureAt:      r.departureTime,
    arrivalAt:        r.arrivalTime,
    durationMinutes:  r.durationMinutes,
    travelClass:      TravelClass.fromCabinClass(r.cabinClass),
    stops:            r.stops,
    baggageAllowance: r.baggageAllowance,
    isRefundable:     r.isRefundable,
    priceInr:         r.priceInr,
    seatsAvailable:   r.seatsLeft,
  );
}
