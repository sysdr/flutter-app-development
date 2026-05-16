import 'dart:convert';

// A single cached item: the raw JSON string, the time it was cached,
// and the TTL applied at write time.
//
// Generic only in the Dart type system — Hive stores the JSON string
// directly, so T is encoded/decoded at the cache boundary.
class CacheEntry {
  CacheEntry({
    required this.key,
    required this.jsonData,
    required this.cachedAt,
    required this.ttlSeconds,
  });

  final String   key;
  final String   jsonData;   // JSON-encoded List<FlightResult>
  final DateTime cachedAt;
  final int      ttlSeconds;

  bool get isExpired =>
      DateTime.now().isAfter(cachedAt.add(Duration(seconds: ttlSeconds)));

  Duration get age => DateTime.now().difference(cachedAt);

  // Hive map serialisation (stored as a Map<String, dynamic>)
  Map<String, dynamic> toMap() => {
    'key':        key,
    'jsonData':   jsonData,
    'cachedAt':   cachedAt.toIso8601String(),
    'ttlSeconds': ttlSeconds,
  };

  factory CacheEntry.fromMap(Map<dynamic, dynamic> m) => CacheEntry(
    key:        m['key']        as String,
    jsonData:   m['jsonData']   as String,
    cachedAt:   DateTime.parse(m['cachedAt'] as String),
    ttlSeconds: m['ttlSeconds'] as int,
  );
}
