abstract final class NetworkConfig {
  static const String amadeusBaseUrl =
      'https://test.api.amadeus.com';
  static const String tokenPath =
      '/v1/security/oauth2/token';
  static const String flightOffersPath =
      '/v2/shopping/flight-offers';
  static const String flightOfferByIdPath =
      '/v1/shopping/flight-offers';

  // Injected at build-time via --dart-define
  // flutter run --dart-define=AMADEUS_KEY=xxx --dart-define=AMADEUS_SECRET=yyy
  static const String apiKey = String.fromEnvironment('AMADEUS_KEY');
  static const String apiSecret = String.fromEnvironment('AMADEUS_SECRET');

  static const Duration connectTimeout  = Duration(seconds: 10);
  static const Duration receiveTimeout  = Duration(seconds: 20);
  static const int      maxRetries      = 1;
  static const int      maxFlightOffers = 10;
}
