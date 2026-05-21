import 'package:hive_flutter/hive_flutter.dart';
import '../services/storage_keys.dart';
import 'cache_entry.dart';
import 'cache_service.dart';

final class HiveCacheService implements CacheService {
  static const String _boxName = 'flight_cache';

  late final Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  @override
  Future<void> put(
      String key, String jsonData, int ttlSeconds) async {
    final entry = CacheEntry(
      key:        key,
      jsonData:   jsonData,
      cachedAt:   DateTime.now(),
      ttlSeconds: ttlSeconds,
    );
    await _box.put(key, entry.toMap());
    // Enforce LRU cap
    if (_box.length > StorageKeys.maxFlightSearchEntries) {
      await evictOldest(_box.length - StorageKeys.maxFlightSearchEntries);
    }
  }

  @override
  Future<CacheEntry?> get(String key) async {
    final raw = _box.get(key);
    if (raw == null) return null;
    return CacheEntry.fromMap(raw as Map);
  }

  @override
  Future<void> invalidate(String key) async => _box.delete(key);

  @override
  Future<int> evictExpired() async {
    final keys = _box.keys.toList();
    int count = 0;
    for (final k in keys) {
      final raw = _box.get(k);
      if (raw == null) continue;
      final entry = CacheEntry.fromMap(raw as Map);
      if (entry.isExpired) { await _box.delete(k); count++; }
    }
    return count;
  }

  @override
  Future<void> evictOldest(int count) async {
    final entries = _box.keys
        .map((k) {
          final raw = _box.get(k);
          if (raw == null) return null;
          return CacheEntry.fromMap(raw as Map);
        })
        .whereType<CacheEntry>()
        .toList()
      ..sort((a, b) => a.cachedAt.compareTo(b.cachedAt));
    for (final e in entries.take(count)) {
      await _box.delete(e.key);
    }
  }

  @override
  Future<int> get size async => _box.length;

  @override
  Future<void> clear() async => _box.clear();
}
