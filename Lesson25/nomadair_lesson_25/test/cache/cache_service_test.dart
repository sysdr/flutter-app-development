import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_25/core/cache/cache_policy.dart';
import 'package:nomadair_lesson_25/core/cache/mock_cache_service.dart';
import 'package:nomadair_lesson_25/features/search/models/flight_result.dart';
import 'package:nomadair_lesson_25/features/search/repositories/cached_flight_repository.dart';
import 'package:nomadair_lesson_25/features/search/repositories/mock_flight_repository.dart';
import 'package:nomadair_lesson_25/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_25/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_25/features/search/models/cache_stats.dart';

SearchCriteria _c() => SearchCriteria(
  origin:      const SelectedCity(name: 'Mumbai', iata: 'BOM', cityId: 1),
  destination: const SelectedCity(name: 'Dubai',  iata: 'DXB', cityId: 2),
  departureDate: DateTime(2025, 8, 15),
  passengers:  const PassengerCount(adults: 1),
  cabinClass:  CabinClass.economy,
);

void main() {
  group('MockCacheService', () {
    late MockCacheService cache;
    setUp(() => cache = MockCacheService());

    test('get returns null for unknown key', () async {
      expect(await cache.get('no_such_key'), isNull);
    });

    test('put then get returns entry', () async {
      await cache.put('k1', '[]', 900);
      final e = await cache.get('k1');
      expect(e, isNotNull);
      expect(e!.jsonData, '[]');
    });

    test('fresh entry isExpired false', () async {
      await cache.put('k1', '[]', 900);
      final e = await cache.get('k1');
      expect(e!.isExpired, isFalse);
    });

    test('injected expired entry isExpired true', () async {
      cache.injectExpired('k1', '[]');
      final e = await cache.get('k1');
      expect(e!.isExpired, isTrue);
    });

    test('invalidate removes entry', () async {
      await cache.put('k1', '[]', 900);
      await cache.invalidate('k1');
      expect(await cache.get('k1'), isNull);
    });

    test('evictExpired removes only expired', () async {
      await cache.put('fresh', '[]', 900);
      cache.injectExpired('stale', '[]');
      final n = await cache.evictExpired();
      expect(n, 1);
      expect(await cache.get('fresh'), isNotNull);
      expect(await cache.get('stale'), isNull);
    });

    test('evictOldest removes correct count', () async {
      await cache.put('a', '[]', 900);
      await Future<void>.delayed(const Duration(milliseconds: 1));
      await cache.put('b', '[]', 900);
      await cache.evictOldest(1);
      expect(await cache.get('a'), isNull);
      expect(await cache.get('b'), isNotNull);
    });

    test('size reflects entry count', () async {
      await cache.put('x', '[]', 900);
      await cache.put('y', '[]', 900);
      expect(await cache.size, 2);
    });

    test('clear empties store', () async {
      await cache.put('x', '[]', 900);
      await cache.clear();
      expect(await cache.size, 0);
    });

    test('put overwrites existing entry', () async {
      await cache.put('k', '[1]', 900);
      await cache.put('k', '[2]', 900);
      expect((await cache.get('k'))!.jsonData, '[2]');
    });
  });

  group('CachedFlightRepository', () {
    late MockCacheService cache;
    late CachedFlightRepository repo;

    setUp(() {
      cache = MockCacheService();
      repo  = CachedFlightRepository(
          inner: MockFlightRepository(), cache: cache);
    });

    test('cache miss delegates to inner and populates cache', () async {
      expect(await cache.size, 0);
      await repo.searchFlights(_c());
      expect(await cache.size, 1);
      expect(repo.lastResultFromCache, isFalse);
    });

    test('cache hit returns without calling inner', () async {
      await repo.searchFlights(_c()); // populate cache
      await repo.searchFlights(_c()); // should hit
      expect(repo.lastResultFromCache, isTrue);
    });

    test('expired entry triggers network re-fetch', () async {
      final key = CachedFlightRepository.cacheKey(_c());
      cache.injectExpired(key, jsonEncode([]));
      await repo.searchFlights(_c());
      expect(repo.lastResultFromCache, isFalse);
    });

    test('cacheKey encodes origin_dest_date_cabin', () {
      final key = CachedFlightRepository.cacheKey(_c());
      expect(key, contains('BOM'));
      expect(key, contains('DXB'));
      expect(key, contains('2025-08-15'));
      expect(key, contains('ECONOMY'));
    });

    test('different routes produce different cache keys', () {
      final c2 = SearchCriteria(
        origin:       const SelectedCity(name: 'Delhi', iata: 'DEL', cityId: 3),
        destination:  const SelectedCity(name: 'London', iata: 'LHR', cityId: 4),
        departureDate: DateTime(2025, 8, 15),
        passengers:   const PassengerCount(adults: 1),
        cabinClass:   CabinClass.economy,
      );
      expect(CachedFlightRepository.cacheKey(_c()),
          isNot(equals(CachedFlightRepository.cacheKey(c2))));
    });

    test('cache TTL matches CachePolicy.flightSearchTtlSeconds', () async {
      await repo.searchFlights(_c());
      final key   = CachedFlightRepository.cacheKey(_c());
      final entry = await cache.get(key);
      expect(entry!.ttlSeconds,
          CachePolicy.flightSearchTtlSeconds);
    });

    test('decoded results match original list length', () async {
      final direct = await MockFlightRepository().searchFlights(_c());
      final cached = await repo.searchFlights(_c());
      expect(cached.length, direct.length);
    });

    test('second call returns same count as first', () async {
      final first  = await repo.searchFlights(_c());
      final second = await repo.searchFlights(_c());
      expect(second.length, first.length);
    });

    test('CacheStats hitRatio 0.0 with no calls', () {
      const s = CacheStats(hits: 0, misses: 0, entries: 0);
      expect(s.hitRatio, 0.0);
    });

    test('CacheStats hitRatio 0.5 for 1 hit 1 miss', () {
      const s = CacheStats(hits: 1, misses: 1, entries: 2);
      expect(s.hitRatio, 0.5);
    });
  });
}
