import '../../features/search/models/search_criteria.dart' show CabinClass;

/// Domain-layer travel class.
///
/// Distinct from [CabinClass] (search/API layer) so the domain layer
/// has no dependency on the search feature folder.
///
/// Convert at the API→domain boundary: [TravelClass.fromCabinClass].
enum TravelClass {
  economy(label: 'Economy',         priceMultiplier: 1.0),
  premiumEconomy(label: 'Premium Economy', priceMultiplier: 1.8),
  business(label: 'Business',       priceMultiplier: 3.5),
  firstClass(label: 'First Class',  priceMultiplier: 6.0);

  const TravelClass({required this.label, required this.priceMultiplier});
  final String label;
  final double priceMultiplier;

  /// Convert search-layer [CabinClass] to domain [TravelClass].
  static TravelClass fromCabinClass(CabinClass c) => switch (c) {
    CabinClass.economy        => TravelClass.economy,
    CabinClass.premiumEconomy => TravelClass.premiumEconomy,
    CabinClass.business       => TravelClass.business,
    CabinClass.firstClass     => TravelClass.firstClass,
  };
}
