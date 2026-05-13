class CacheStats {
  const CacheStats({
    required this.hits,
    required this.misses,
    required this.entries,
  });

  final int hits;
  final int misses;
  final int entries;

  int get total    => hits + misses;
  double get hitRatio => total == 0 ? 0 : hits / total;

  String get summary =>
      'Cache: $entries entries  |  '
      '${(hitRatio * 100).toStringAsFixed(0)}% hit rate';

  @override
  String toString() => 'CacheStats($summary)';
}
