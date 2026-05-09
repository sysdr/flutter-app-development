import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/amadeus_token_service.dart';
import '../../../core/network/network_config.dart';
import '../../../core/network/network_exception.dart';
import '../models/flight_result.dart';
import '../models/search_criteria.dart';
import 'flight_repository.dart';

// Real FlightRepository that calls the Amadeus test API.
//
// Activated by setting MockConfig.useMock = false.
// Requires --dart-define=AMADEUS_KEY=xxx --dart-define=AMADEUS_SECRET=yyy.
//
// Error handling:
//   401 â†’ NetworkAuthException (bad credentials)
//   4xx â†’ HttpStatusException(isClientError: true) â€” no retry
//   5xx â†’ retried once, then HttpStatusException(isServerError: true)
//   timeout â†’ NetworkTimeoutException
//   bad JSON â†’ NetworkParseException
final class AmadeusFlightRepository implements FlightRepository {
  AmadeusFlightRepository({
    http.Client?          client,
    AmadeusTokenService?  tokenService,
  })  : _client       = client ?? http.Client(),
        _tokenService = tokenService ?? AmadeusTokenService();

  final http.Client         _client;
  final AmadeusTokenService _tokenService;

  @override
  Future<List<FlightResult>> searchFlights(
      SearchCriteria criteria) async {
    final token = await _tokenService.validToken();
    final results = await _doSearch(criteria, token, attempt: 1);
    return results;
  }

  Future<List<FlightResult>> _doSearch(
      SearchCriteria criteria, String token,
      {required int attempt}) async {
    final uri = Uri.parse(
            NetworkConfig.amadeusBaseUrl +
            NetworkConfig.flightOffersPath)
        .replace(queryParameters: _buildParams(criteria));

    late http.Response resp;
    try {
      resp = await _client
          .get(uri, headers: {
            'Authorization': 'Bearer $token',
            'Accept':        'application/json',
          })
          .timeout(NetworkConfig.receiveTimeout);
    } on Exception {
      throw const NetworkTimeoutException();
    }

    // Server error: retry once
    if (resp.statusCode >= 500 && attempt <= NetworkConfig.maxRetries) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      return _doSearch(criteria, token, attempt: attempt + 1);
    }

    if (resp.statusCode == 401) {
      throw const NetworkAuthException('Token rejected by Amadeus');
    }
    if (resp.statusCode != 200) {
      throw HttpStatusException(resp.statusCode,
          'Flight search returned ${resp.statusCode}');
    }

    return _parse(resp.body);
  }

  List<FlightResult> _parse(String body) {
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      throw const NetworkParseException(
          'Flight offers response is not valid JSON');
    }

    final data = json['data'] as List<dynamic>? ?? [];
    final List<FlightResult> results = [];
    for (final raw in data.take(NetworkConfig.maxFlightOffers)) {
      try {
        results.add(
            FlightResult.fromAmadeusJson(
                raw as Map<String, dynamic>));
      } catch (_) {
        // Skip malformed offers silently
      }
    }
    return results;
  }

  Map<String, String> _buildParams(SearchCriteria c) => {
        'originLocationCode':      c.origin?.iata      ?? '',
        'destinationLocationCode': c.destination?.iata ?? '',
        'departureDate':
            (c.departureDate ?? DateTime.now())
                .toIso8601String()
                .substring(0, 10),
        'adults':        '${c.passengers.adults}',
        'travelClass':   c.cabinClass.amadeusLabel,
        'nonStop':       'false',
        'max':
            '${NetworkConfig.maxFlightOffers}',
        'currencyCode':  'INR',
      };

  @override
  Future<FlightResult?> getFlightDetails(String flightId) async =>
      null; // implemented in L25 (booking flow)
}
