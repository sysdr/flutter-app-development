import '../models/flight_model.dart';

/// Contract for all flight data operations in NomadAir.
///
/// Dart 3.x [abstract interface class]:
///   - [abstract]: cannot be instantiated directly
///   - [interface]: cannot be extended — only implemented
///
/// Living in [nomadair_core], this interface is the only symbol that
/// crosses the ui ↔ data boundary. [nomadair_ui] references this type
/// to accept a repository from above. [nomadair_data] provides the
/// concrete implementation. Neither depends on the other.
abstract interface class FlightRepository {
  /// Returns all flights matching the search criteria.
  ///
  /// Implementations must return an empty list — never throw — when no
  /// flights match. Errors surface via the Result type (Lesson 24).
  Future<List<FlightModel>> fetchFlights({
    required String origin,
    required String destination,
  });

  /// Returns a single flight by its airline-issued ID, or null if not found.
  Future<FlightModel?> fetchFlightById(String id);
}
