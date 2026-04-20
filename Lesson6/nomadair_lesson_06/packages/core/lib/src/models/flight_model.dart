final class FlightModel {
  const FlightModel({
    required this.id,
    required this.airline,
    required this.origin,
    required this.destination,
    required this.durationMinutes,
    required this.priceInr,
    required this.stops,
  });

  final String id;
  final String airline;
  final String origin;
  final String destination;
  final int durationMinutes;
  final int stops;
  final double priceInr;
}
