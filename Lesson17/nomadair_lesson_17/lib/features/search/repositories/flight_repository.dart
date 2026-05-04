import '../models/flight_result.dart';
import '../models/search_criteria.dart';

/// Abstract contract for flight search.
/// MockFlightRepository (L17) and RealFlightRepository (L25) both
/// implement this — the UI never knows which is active.
abstract interface class FlightRepository {
  Future<List<FlightResult>> searchFlights(SearchCriteria criteria);
  Future<FlightResult?>      getFlightDetails(String flightId);
}
