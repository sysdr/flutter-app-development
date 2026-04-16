/// Immutable domain model representing a single flight option.
///
/// [final class] in Dart 3.x prevents subclassing. A FlightModel
/// is a sealed domain value — it cannot be extended with UI-layer
/// fields, which would couple the domain to the presentation.
///
/// Declared in [nomadair_core] so both [nomadair_ui] and
/// [nomadair_data] can reference it without depending on each other.
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

  /// IATA airport code, e.g. 'BOM', 'DEL', 'DXB'.
  final String origin;
  final String destination;

  final int    durationMinutes;
  final double priceInr;

  /// 0 = non-stop, 1+ = connecting flights.
  final int stops;

  // ── Computed display helpers ───────────────────────────────
  String get formattedDuration {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return '${h}h ${m}m';
  }

  String get formattedPrice => '₹${priceInr.toStringAsFixed(0)}';

  String get stopsLabel =>
      stops == 0 ? 'Non-stop' : '$stops stop${stops == 1 ? '' : 's'}';

  String get route => '$origin → $destination';

  @override
  String toString() =>
      'FlightModel(id: $id, airline: $airline, route: $route, '
      'duration: $formattedDuration, price: $formattedPrice, '
      'stops: $stopsLabel)';
}
