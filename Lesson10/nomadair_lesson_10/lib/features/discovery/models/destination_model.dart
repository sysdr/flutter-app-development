/// Lesson 10 — Discovery feature domain model.
///
/// A thin wrapper around [DestinationModel] from packages/core, adding
/// discovery-specific metadata: trending rank and matched search flag.
///
/// In Lesson 13, this becomes a Freezed-generated model with
/// copyWith, equality, and JSON serialization.
final class DiscoveryDestination {
  const DiscoveryDestination({
    required this.id,
    required this.city,
    required this.country,
    required this.iataCode,
    required this.tagline,
    required this.priceFromInr,
    required this.category,
    required this.skyColorTop,
    required this.skyColorBottom,
    this.trendingRank,
    this.isMatchingSearch = false,
  });

  final String id;
  final String city;
  final String country;
  final String iataCode;
  final String tagline;
  final double priceFromInr;
  final String category;
  final int    skyColorTop;
  final int    skyColorBottom;

  /// Trending rank — null means not in trending list.
  final int?   trendingRank;

  /// True when this destination matches an active search query.
  final bool   isMatchingSearch;

  String get formattedPrice => 'from ₹${priceFromInr.toStringAsFixed(0)}';
  bool get isTrending => trendingRank != null;

  static const List<DiscoveryDestination> samples = [
    DiscoveryDestination(id:'dxb',city:'Dubai',country:'UAE',iataCode:'DXB',
      tagline:'City of gold and sky',priceFromInr:18500,category:'flights',
      skyColorTop:0xFF1A237E,skyColorBottom:0xFFE65100,trendingRank:1),
    DiscoveryDestination(id:'sin',city:'Singapore',country:'SG',iataCode:'SIN',
      tagline:'The garden city',priceFromInr:22000,category:'both',
      skyColorTop:0xFF00695C,skyColorBottom:0xFF1B5E20,trendingRank:2),
    DiscoveryDestination(id:'nrt',city:'Tokyo',country:'Japan',iataCode:'NRT',
      tagline:'Neon and tradition',priceFromInr:38000,category:'both',
      skyColorTop:0xFF880E4F,skyColorBottom:0xFF4A148C,trendingRank:3),
  ];
}

/// Active filter on the discovery feed.
enum DiscoveryFilter { all, flights, hotels }
