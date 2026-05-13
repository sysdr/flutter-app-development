import '../../core/cache/cache_service.dart';
import '../../core/cache/hive_cache_service.dart';
import '../../features/search/repositories/amadeus_flight_repository.dart';
import '../../features/search/repositories/cached_flight_repository.dart';
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

  /// Set once from [main] after [HiveCacheService.init] — shared by
  /// [cachedFlightRepository] and Provider injection.
  static CacheService? _flightCache;

  static void bindFlightCache(CacheService cache) {
    _flightCache = cache;
  }

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

  /// Returns activeFlightRepository wrapped in the Hive TTL cache.
  /// Uses the cache box initialised in main via [bindFlightCache].
  static FlightRepository get cachedFlightRepository =>
      CachedFlightRepository(
        inner: activeFlightRepository,
        cache: _flightCache ?? HiveCacheService(),
      );
}
