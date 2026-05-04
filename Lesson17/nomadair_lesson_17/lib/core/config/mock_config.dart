import '../../features/search/repositories/flight_repository.dart';
import '../../features/search/repositories/hotel_repository.dart';
import '../../features/search/repositories/mock_flight_repository.dart';
import '../../features/search/repositories/mock_hotel_repository.dart';

/// Lesson 17 — Single toggle between mock and real data layers.
///
/// L17: useMock = true  → MockFlightRepository (default)
/// L25: useMock = false → RealFlightRepository (no call-site changes)
///
/// Set simulateError = true in tests to force error-state UI.
abstract final class MockConfig {
  static bool useMock       = true;
  static bool simulateError = false;

  /// Tunable in widget tests (set to 0 for instant mock responses).
  static int minDelayMs = 300;
  static int maxDelayMs = 800;

  static FlightRepository get flightRepository => useMock
      ? MockFlightRepository()
      : throw UnimplementedError('RealFlightRepository: Lesson 25+');

  static HotelRepository get hotelRepository => useMock
      ? MockHotelRepository()
      : throw UnimplementedError('RealHotelRepository: Lesson 25+');
}
