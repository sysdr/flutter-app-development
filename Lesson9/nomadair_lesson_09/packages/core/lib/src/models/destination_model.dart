/// Represents a travel destination card in the Discover feed.
///
/// This model is introduced in Lesson 09 to drive the Discover screen.
/// In Lesson 13, it will be extended with a real image URL and coordinates.
final class DestinationModel {
  const DestinationModel({
    required this.id,
    required this.city,
    required this.country,
    required this.iataCode,
    required this.tagline,
    required this.priceFromInr,
    required this.category,
    required this.skyColorTop,
    required this.skyColorBottom,
  });

  final String id;
  final String city;
  final String country;
  final String iataCode;
  final String tagline;
  final double priceFromInr;

  /// 'flights' | 'hotels' | 'both'
  final String category;

  /// Two colours for the painted destination hero gradient (no image assets needed)
  final int skyColorTop;
  final int skyColorBottom;

  String get formattedPrice => 'from ₹${priceFromInr.toStringAsFixed(0)}';

  String get accessibilityLabel =>
      '$city, $country. $tagline. $formattedPrice.';

  static const List<DestinationModel> samples = [
    DestinationModel(
      id: 'dxb', city: 'Dubai', country: 'UAE', iataCode: 'DXB',
      tagline: 'City of gold and sky', priceFromInr: 18500,
      category: 'flights',
      skyColorTop: 0xFF1A237E, skyColorBottom: 0xFFE65100,
    ),
    DestinationModel(
      id: 'lhr', city: 'London', country: 'UK', iataCode: 'LHR',
      tagline: 'Where history meets future', priceFromInr: 42000,
      category: 'flights',
      skyColorTop: 0xFF1565C0, skyColorBottom: 0xFF546E7A,
    ),
    DestinationModel(
      id: 'sin', city: 'Singapore', country: 'Singapore', iataCode: 'SIN',
      tagline: 'The garden city', priceFromInr: 22000,
      category: 'both',
      skyColorTop: 0xFF00695C, skyColorBottom: 0xFF1B5E20,
    ),
    DestinationModel(
      id: 'bkk', city: 'Bangkok', country: 'Thailand', iataCode: 'BKK',
      tagline: 'Temples, streets and flavour', priceFromInr: 14500,
      category: 'hotels',
      skyColorTop: 0xFFE65100, skyColorBottom: 0xFFBF360C,
    ),
    DestinationModel(
      id: 'cdg', city: 'Paris', country: 'France', iataCode: 'CDG',
      tagline: 'La ville lumière', priceFromInr: 48000,
      category: 'flights',
      skyColorTop: 0xFF283593, skyColorBottom: 0xFF1A237E,
    ),
    DestinationModel(
      id: 'nrt', city: 'Tokyo', country: 'Japan', iataCode: 'NRT',
      tagline: 'Neon and tradition', priceFromInr: 38000,
      category: 'both',
      skyColorTop: 0xFF880E4F, skyColorBottom: 0xFF4A148C,
    ),
  ];
}
