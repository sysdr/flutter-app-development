import '../../features/search/repositories/amadeus_flight_repository.dart';
import '../../features/search/repositories/flight_repository.dart';
import '../../features/search/repositories/hotel_repository.dart';
import '../../features/search/repositories/mock_flight_repository.dart';
import '../../features/search/repositories/mock_hotel_repository.dart';
import '../services/local_storage_service.dart';
import '../services/mock_storage_service.dart';

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

  /// Returns a fresh in-memory storage service for tests.
  /// Production code uses [HiveStorageService] from main.dart.
  static LocalStorageService get storageService => MockStorageService();

  /// Real Amadeus API repository (requires --dart-define creds).
  /// Activate: set useMock = false, then pass --dart-define flags.
  static FlightRepository get amadeusRepository =>
      AmadeusFlightRepository();

  static FlightRepository get activeFlightRepository =>
      useMock ? flightRepository : amadeusRepository;
}
