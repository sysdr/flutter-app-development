import 'cache_entry.dart';
import 'cache_service.dart';

final class MockCacheService implements CacheService {
  final Map<String, CacheEntry> _store = {};

  @override
  Future<void> put(String key, String jsonData, int ttlSeconds) async {
    _store[key] = CacheEntry(
      key:        key,
      jsonData:   jsonData,
      cachedAt:   DateTime.now(),
      ttlSeconds: ttlSeconds,
    );
  }

  @override
  Future<CacheEntry?> get(String key) async => _store[key];

  @override
  Future<void> invalidate(String key) async => _store.remove(key);

  @override
  Future<int> evictExpired() async {
    final expired = _store.entries
        .where((e) => e.value.isExpired)
        .map((e) => e.key)
        .toList();
    for (final k in expired) _store.remove(k);
    return expired.length;
  }

  @override
  Future<void> evictOldest(int count) async {
    final sorted = _store.entries.toList()
      ..sort((a, b) => a.value.cachedAt.compareTo(b.value.cachedAt));
    for (final e in sorted.take(count)) _store.remove(e.key);
  }

  @override
  Future<int> get size async => _store.length;

  @override
  Future<void> clear() async => _store.clear();

  // Test helper — inject an already-expired entry
  void injectExpired(String key, String json) {
    _store[key] = CacheEntry(
      key:        key,
      jsonData:   json,
      cachedAt:   DateTime.now().subtract(const Duration(hours: 1)),
      ttlSeconds: 1,
    );
  }
}
