import '../../features/search/repositories/flight_repository.dart';
import '../../features/search/repositories/hotel_repository.dart';
import '../../features/search/repositories/mock_flight_repository.dart';
import '../../features/search/repositories/mock_hotel_repository.dart';

abstract final class MockConfig {
  static bool useMock       = true;
  static bool simulateError = false;
  static const int minDelayMs = 300;
  static const int maxDelayMs = 800;

  static FlightRepository get flightRepository => useMock
      ? MockFlightRepository()
      : throw UnimplementedError('RealFlightRepository in Lesson 25+');

  static HotelRepository get hotelRepository => useMock
      ? MockHotelRepository()
      : throw UnimplementedError('RealHotelRepository in Lesson 25+');
}
