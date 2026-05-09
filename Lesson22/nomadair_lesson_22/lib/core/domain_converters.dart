import '../features/search/models/flight_result.dart';
import '../features/search/models/hotel_result.dart';
import 'domain/flight.dart';
import 'domain/hotel.dart';

/// Lesson 19 â€” Extension methods to convert search-layer API models
/// to domain models at the repositoryâ†’Provider boundary.
///
/// The conversion happens inside [FlightSearchNotifier] so that
/// the UI layer only ever imports from [lib/core/domain/].
extension FlightResultDomain on FlightResult {
  /// Convert [FlightResult] (search API) to [Flight] (domain).
  Flight toDomain() => Flight.fromFlightResult(this);
}

extension HotelResultDomain on HotelResult {
  /// Convert [HotelResult] (search API) to [Hotel] (domain).
  Hotel toDomain() => Hotel(
    id:                   id,
    name:                 name,
    cityIata:             city,
    countryCode:          countryCode,
    starRating:           starRating.index + 1,
    boardType:            boardType.name,
    distanceFromCentreKm: distanceFromCentreKm,
    isRefundable:         isRefundable,
    reviewScore:          reviewScore,
    reviewCount:          reviewCount,
  );
}
