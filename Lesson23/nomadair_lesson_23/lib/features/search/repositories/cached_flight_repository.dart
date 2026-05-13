import 'dart:convert';
import '../../../core/cache/cache_policy.dart';
import '../../../core/cache/cache_service.dart';
import '../models/flight_result.dart';
import '../models/search_criteria.dart';
import 'flight_repository.dart';

// Decorator that wraps any FlightRepository with a Hive TTL cache.
//
// Cache key = originIata_destinationIata_date_cabin.
//
// On cache hit (fresh entry):  returns cached data — no HTTP.
// On cache miss or stale:      delegates to inner repository,
//                              writes result to cache, returns data.
//
// Usage in MockConfig:
//   static FlightRepository get cachedFlightRepository =>
//       CachedFlightRepository(
//         inner: activeFlightRepository,
//         cache: HiveCacheService(),
//       );
final class CachedFlightRepository implements FlightRepository {
  CachedFlightRepository({
    required FlightRepository inner,
    required CacheService     cache,
  })  : _inner = inner,
        _cache = cache;

  final FlightRepository _inner;
  final CacheService     _cache;

  // Whether the last searchFlights call was served from cache.
  bool get lastResultFromCache => _lastFromCache;
  bool _lastFromCache = false;

  static String cacheKey(SearchCriteria c) {
    final date = (c.departureDate ?? DateTime.now())
        .toIso8601String()
        .substring(0, 10);
    return '${c.origin?.iata ?? ''}_'
        '${c.destination?.iata ?? ''}_'
        '${date}_'
        '${c.cabinClass.amadeusLabel}';
  }

  @override
  Future<List<FlightResult>> searchFlights(
      SearchCriteria criteria) async {
    final key   = cacheKey(criteria);
    final entry = await _cache.get(key);

    if (entry != null && !entry.isExpired) {
      _lastFromCache = true;
      return _decode(entry.jsonData);
    }

    _lastFromCache = false;
    final results = await _inner.searchFlights(criteria);
    await _cache.put(
      key,
      _encode(results),
      CachePolicy.flightSearchTtlSeconds,
    );
    return results;
  }

  @override
  Future<FlightResult?> getFlightDetails(String flightId) =>
      _inner.getFlightDetails(flightId);

  static String _encode(List<FlightResult> r) =>
      jsonEncode(r.map((f) => f.toJson()).toList());

  static List<FlightResult> _decode(String json) =>
      (jsonDecode(json) as List)
          .map((e) => FlightResult.fromJson(e as Map<String, dynamic>))
          .toList();
}
