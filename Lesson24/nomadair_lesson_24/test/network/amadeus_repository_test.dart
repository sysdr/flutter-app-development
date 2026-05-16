import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nomadair_lesson_24/core/network/amadeus_token_service.dart';
import 'package:nomadair_lesson_24/core/network/network_exception.dart';
import 'package:nomadair_lesson_24/features/search/models/search_criteria.dart';
import 'package:nomadair_lesson_24/features/search/models/selected_city.dart';
import 'package:nomadair_lesson_24/features/search/repositories/amadeus_flight_repository.dart';

SearchCriteria _criteria() => SearchCriteria(
      origin:      const SelectedCity(name: 'Mumbai', iata: 'BOM', cityId: 1),
      destination: const SelectedCity(name: 'Dubai',  iata: 'DXB', cityId: 2),
      departureDate: DateTime(2025, 8, 15),
      passengers:  const PassengerCount(adults: 1),
      cabinClass:  CabinClass.economy,
    );

AmadeusFlightRepository _repo(MockClient client) {
  final tokenSvc = AmadeusTokenService(client: client);
  tokenSvc.injectToken('pre_token',
      DateTime.now().add(const Duration(hours: 1)));
  return AmadeusFlightRepository(
      client: client, tokenService: tokenSvc);
}

Map<String, dynamic> _offer({
  String id = 'OFFER1',
  String airline = 'AI',
  String origin = 'BOM',
  String dest = 'DXB',
  String depart = '2025-08-15T10:00:00',
  String arrive = '2025-08-15T13:00:00',
  String duration = 'PT3H',
  int stops = 0,
  double price = 12500.0,
}) =>
    {
      'id': id,
      'validatingAirlineCodes': [airline],
      'itineraries': [
        {
          'duration': duration,
          'segments': [
            {
              'departure': {'iataCode': origin, 'at': depart},
              'arrival':   {'iataCode': dest,   'at': arrive},
              'numberOfStops': stops,
            }
          ],
        }
      ],
      'price': {
        'grandTotal': price.toString(),
        'currency':   'INR',
      },
      'travelerPricings': [
        {
          'fareDetailsBySegment': [
            {'cabin': 'ECONOMY', 'class': 'Y'}
          ]
        }
      ],
    };

http.Response _offersResp(List<Map<String, dynamic>> data) =>
    http.Response(
        jsonEncode({'meta': {'count': data.length}, 'data': data}),
        200);

void main() {
  group('AmadeusFlightRepository', () {
    // ── Happy-path ──────────────────────────────────────────────
    test('returns parsed FlightResult list', () async {
      final repo = _repo(MockClient(
          (_) async => _offersResp([_offer(), _offer(id: 'OFF2')])));
      final results = await repo.searchFlights(_criteria());
      expect(results, hasLength(2));
    });

    test('parses airline code', () async {
      final repo = _repo(MockClient(
          (_) async => _offersResp([_offer(airline: 'EK')])));
      final r = (await repo.searchFlights(_criteria())).first;
      expect(r.airlineCode, 'EK');
    });

    test('parses origin and destination', () async {
      final repo = _repo(MockClient(
          (_) async => _offersResp([_offer(origin: 'DEL', dest: 'LHR')])));
      final r = (await repo.searchFlights(_criteria())).first;
      expect(r.origin, 'DEL');
      expect(r.destination, 'LHR');
    });

    test('parses priceInr', () async {
      final repo = _repo(MockClient(
          (_) async => _offersResp([_offer(price: 18000)])));
      final r = (await repo.searchFlights(_criteria())).first;
      expect(r.priceInr, closeTo(18000, 0.01));
    });

    test('parses stop count', () async {
      final repo = _repo(MockClient(
          (_) async => _offersResp([_offer(stops: 1)])));
      final r = (await repo.searchFlights(_criteria())).first;
      expect(r.stops, 1);
    });

    test('empty data list → empty result', () async {
      final repo = _repo(MockClient(
          (_) async => _offersResp([])));
      expect(await repo.searchFlights(_criteria()), isEmpty);
    });

    test('caps at NetworkConfig.maxFlightOffers', () async {
      final offers = List.generate(15, (i) => _offer(id: 'O$i'));
      final repo = _repo(MockClient(
          (_) async => _offersResp(offers)));
      final results = await repo.searchFlights(_criteria());
      expect(results.length, lessThanOrEqualTo(10));
    });

    test('skips malformed offer silently', () async {
      final repo = _repo(MockClient((_) async => http.Response(
          jsonEncode({'data': [_offer(), {'broken': true}]}), 200)));
      final results = await repo.searchFlights(_criteria());
      expect(results, hasLength(1));
    });

    // ── Error handling ──────────────────────────────────────────
    test('throws NetworkAuthException on 401', () async {
      final repo = _repo(MockClient(
          (_) async => http.Response('', 401)));
      expect(
        () => repo.searchFlights(_criteria()),
        throwsA(isA<NetworkAuthException>()),
      );
    });

    test('throws HttpStatusException on 400', () async {
      final repo = _repo(MockClient(
          (_) async => http.Response('bad request', 400)));
      expect(
        () => repo.searchFlights(_criteria()),
        throwsA(isA<HttpStatusException>()),
      );
    });

    test('isClientError true for 400', () async {
      final repo = _repo(MockClient(
          (_) async => http.Response('', 400)));
      try {
        await repo.searchFlights(_criteria());
      } on HttpStatusException catch (e) {
        expect(e.isClientError, isTrue);
        expect(e.isServerError, isFalse);
      }
    });

    test('throws HttpStatusException after retrying 5xx', () async {
      var calls = 0;
      final repo = _repo(MockClient((_) async {
        calls++;
        return http.Response('server error', 503);
      }));
      await expectLater(
        repo.searchFlights(_criteria()),
        throwsA(isA<HttpStatusException>()),
      );
      expect(calls, 2); // 1 attempt + 1 retry
    });

    test('throws NetworkParseException on invalid JSON body', () async {
      final repo = _repo(MockClient(
          (_) async => http.Response('not-json', 200)));
      expect(
        () => repo.searchFlights(_criteria()),
        throwsA(isA<NetworkParseException>()),
      );
    });

    test('getFlightDetails returns null (impl in L25)', () async {
      final repo = _repo(MockClient((_) async => _offersResp([])));
      expect(await repo.getFlightDetails('any'), isNull);
    });
  });
}
