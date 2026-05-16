import 'package:nomadair_lesson_24/features/search/models/flight_result.dart';
import 'package:nomadair_lesson_24/features/search/models/hotel_result.dart';
import 'package:nomadair_lesson_24/core/domain/flight.dart';
import 'package:nomadair_lesson_24/core/domain/hotel.dart';

/// Lesson 19 — Extension methods to convert search-layer API models
/// to domain models at the repository→Provider boundary.
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
