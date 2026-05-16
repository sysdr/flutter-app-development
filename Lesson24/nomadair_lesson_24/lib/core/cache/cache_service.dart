import 'cache_entry.dart';

abstract interface class CacheService {
  // Write — overwrites any existing entry for [key].
  Future<void> put(String key, String jsonData, int ttlSeconds);

  // Read — returns the entry if present (even if expired).
  // Returns null if no entry exists for [key].
  Future<CacheEntry?> get(String key);

  // Delete a specific entry.
  Future<void> invalidate(String key);

  // Delete all entries whose [isExpired] is true.
  Future<int> evictExpired();

  // Delete the oldest [count] entries regardless of expiry.
  Future<void> evictOldest(int count);

  // Count of all stored entries (including expired).
  Future<int> get size;

  Future<void> clear();
}
