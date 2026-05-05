import '../models/flight_result.dart';
import '../models/search_criteria.dart';
abstract interface class FlightRepository{Future<List<FlightResult>> searchFlights(SearchCriteria criteria);Future<FlightResult?> getFlightDetails(String flightId);}
