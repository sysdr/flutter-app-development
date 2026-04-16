import 'package:nomadair_core/core.dart';

/// Development implementation of [FlightRepository].
///
/// Returns realistic mock flights with simulated async delays.
/// Swap this for a real Dio-backed implementation (Lesson 22) without
/// touching [nomadair_ui] or the main app — that is why the interface
/// lives in [nomadair_core] and the implementation lives here.
///
/// [final class]: cannot be subclassed. If additional behaviour is needed,
/// create a new implementation of [FlightRepository] instead.
final class MockFlightRepository implements FlightRepository {
  const MockFlightRepository();

  @override
  Future<List<FlightModel>> fetchFlights({
    required String origin,
    required String destination,
  }) async {
    // Simulate 300–400ms realistic network latency
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _allFlights
        .where(
          (f) =>
              f.origin == origin.toUpperCase() &&
              f.destination == destination.toUpperCase(),
        )
        .toList();
  }

  @override
  Future<FlightModel?> fetchFlightById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      return _allFlights.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Static mock data ───────────────────────────────────────
  // Using const constructors so this list is a compile-time constant —
  // no heap allocation on import.
  static const List<FlightModel> _allFlights = [
    FlightModel(
      id: 'AI-101',
      airline: 'Air India',
      origin: 'BOM',
      destination: 'DEL',
      durationMinutes: 125,
      priceInr: 4200,
      stops: 0,
    ),
    FlightModel(
      id: 'SG-201',
      airline: 'SpiceJet',
      origin: 'BOM',
      destination: 'DEL',
      durationMinutes: 130,
      priceInr: 3100,
      stops: 0,
    ),
    FlightModel(
      id: '6E-305',
      airline: 'IndiGo',
      origin: 'BOM',
      destination: 'BLR',
      durationMinutes: 90,
      priceInr: 2800,
      stops: 0,
    ),
    FlightModel(
      id: 'AI-402',
      airline: 'Air India',
      origin: 'DEL',
      destination: 'DXB',
      durationMinutes: 215,
      priceInr: 18500,
      stops: 0,
    ),
    FlightModel(
      id: 'EK-500',
      airline: 'Emirates',
      origin: 'BOM',
      destination: 'DXB',
      durationMinutes: 200,
      priceInr: 22000,
      stops: 0,
    ),
    FlightModel(
      id: 'AI-820',
      airline: 'Air India',
      origin: 'DEL',
      destination: 'LHR',
      durationMinutes: 510,
      priceInr: 45000,
      stops: 0,
    ),
  ];
}
