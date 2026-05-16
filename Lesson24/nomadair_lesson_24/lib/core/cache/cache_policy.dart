abstract final class CachePolicy {
  // How long a flight-search result is considered fresh.
  static const int flightSearchTtlSeconds = 900; // 15 minutes

  // Maximum number of distinct search entries to keep.
  // Oldest-first eviction when exceeded.
  static const int maxFlightSearchEntries = 20;

  // Minimum age before an entry can be shown as stale (cosmetic).
  static const int staleThresholdSeconds = 60;
}
