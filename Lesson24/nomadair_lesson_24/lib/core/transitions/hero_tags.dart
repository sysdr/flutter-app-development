abstract final class HeroTags {
  static String flightPrice(String flightId) =>
      'nomadair_flight_price_$flightId';

  static String flightCard(String flightId) =>
      'nomadair_flight_card_$flightId';

  static String destinationImage(String iataCode) =>
      'nomadair_dest_image_$iataCode';

  static String destinationLabel(String iataCode) =>
      'nomadair_dest_label_$iataCode';
}
