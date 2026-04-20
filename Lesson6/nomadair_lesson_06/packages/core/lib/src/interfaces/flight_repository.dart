import '../models/flight_model.dart';

abstract interface class FlightRepository {
  Future<List<FlightModel>> fetchFlights({
    required String origin,
    required String destination,
  });
  Future<FlightModel?> fetchFlightById(String id);
}
