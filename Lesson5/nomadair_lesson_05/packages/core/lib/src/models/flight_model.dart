final class FlightModel {
  const FlightModel({
    required this.id, required this.airline,
    required this.origin, required this.destination,
    required this.durationMinutes,
    required this.priceInr, required this.stops,
  });
  final String id, airline, origin, destination;
  final int durationMinutes, stops;
  final double priceInr;
  String get route => '$origin → $destination';
  String get formattedPrice => '₹${priceInr.toStringAsFixed(0)}';
  String get stopsLabel => stops == 0 ? 'Non-stop' : '$stops stop${stops == 1 ? '' : 's'}';
  String get formattedDuration {
    final h = durationMinutes ~/ 60; final m = durationMinutes % 60;
    return '${h}h ${m}m';
  }
}
