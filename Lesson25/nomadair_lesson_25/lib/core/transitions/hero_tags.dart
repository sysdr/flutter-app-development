// Deterministic Hero tag generators for NomadAir.
//
// All tags are namespaced to prevent collision between unrelated
// screens that might share the same ID value.
//
// Rules:
//  1. Each namespace prefix is unique across the app.
//  2. The same arguments always produce the same tag.
//  3. Different namespaces with the same argument produce different tags.
abstract final class HeroTags {
  // Flight result card → FlightDetailScreen price animation.
  static String flightPrice(String flightId) =>
      'nomadair_flight_price_$flightId';

  // Flight card row identifier (for the airline name).
  static String flightCard(String flightId) =>
      'nomadair_flight_card_$flightId';

  // Discovery card → DestinationDetailScreen banner image animation.
  static String destinationImage(String iataCode) =>
      'nomadair_dest_image_$iataCode';

  // Discovery card label (for the city name text).
  static String destinationLabel(String iataCode) =>
      'nomadair_dest_label_$iataCode';
}
