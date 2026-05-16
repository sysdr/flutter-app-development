import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nomadair_lesson_24/core/network/amadeus_token_service.dart';
import 'package:nomadair_lesson_24/core/network/network_exception.dart';

http.Response _tokenResp({
  String token = 'test_token_abc',
  int expiresIn = 1799,
  int status = 200,
}) =>
    http.Response(
      status == 200
          ? jsonEncode({
              'access_token': token,
              'expires_in':   expiresIn,
              'token_type':   'Bearer',
            })
          : jsonEncode({'error': 'invalid_client'}),
      status,
    );

void main() {
  group('AmadeusTokenService', () {
    test('fetches token on first call', () async {
      final svc = AmadeusTokenService(
          client: MockClient((_) async => _tokenResp()));
      final t = await svc.validToken();
      expect(t, 'test_token_abc');
    });

    test('caches token — second call does not hit network', () async {
      var calls = 0;
      final svc = AmadeusTokenService(
          client: MockClient((_) async {
            calls++;
            return _tokenResp();
          }));
      await svc.validToken();
      await svc.validToken();
      expect(calls, 1);
    });

    test('hasValidToken false before first call', () {
      final svc = AmadeusTokenService(
          client: MockClient((_) async => _tokenResp()));
      expect(svc.hasValidToken, isFalse);
    });

    test('hasValidToken true after successful fetch', () async {
      final svc = AmadeusTokenService(
          client: MockClient((_) async => _tokenResp()));
      await svc.validToken();
      expect(svc.hasValidToken, isTrue);
    });

    test('clears token — next call refreshes', () async {
      var calls = 0;
      final svc = AmadeusTokenService(
          client: MockClient((_) async {
            calls++;
            return _tokenResp(token: 'tok_$calls');
          }));
      final t1 = await svc.validToken();
      svc.clearToken();
      final t2 = await svc.validToken();
      expect(t1, 'tok_1');
      expect(t2, 'tok_2');
      expect(calls, 2);
    });

    test('injectToken makes hasValidToken true', () {
      final svc = AmadeusTokenService(
          client: MockClient((_) async => _tokenResp()));
      svc.injectToken('injected',
          DateTime.now().add(const Duration(hours: 1)));
      expect(svc.hasValidToken, isTrue);
    });

    test('throws NetworkAuthException on 401', () async {
      final svc = AmadeusTokenService(
          client: MockClient(
              (_) async => _tokenResp(status: 401)));
      expect(
        () => svc.validToken(),
        throwsA(isA<NetworkAuthException>()),
      );
    });

    test('throws HttpStatusException on 500', () async {
      final svc = AmadeusTokenService(
          client: MockClient(
              (_) async => _tokenResp(status: 500)));
      expect(
        () => svc.validToken(),
        throwsA(isA<HttpStatusException>()),
      );
    });

    test('throws NetworkParseException on bad JSON', () async {
      final svc = AmadeusTokenService(
          client: MockClient(
              (_) async => http.Response('not-json', 200)));
      expect(
        () => svc.validToken(),
        throwsA(isA<NetworkParseException>()),
      );
    });

    test('throws NetworkParseException when access_token missing', () async {
      final svc = AmadeusTokenService(
          client: MockClient(
              (_) async => http.Response(
                  jsonEncode({'expires_in': 1799}), 200)));
      expect(
        () => svc.validToken(),
        throwsA(isA<NetworkParseException>()),
      );
    });

    test('refreshes when injected token is expired', () async {
      var calls = 0;
      final svc = AmadeusTokenService(
          client: MockClient((_) async {
            calls++;
            return _tokenResp();
          }));
      svc.injectToken('old_token',
          DateTime.now().subtract(const Duration(seconds: 1)));
      await svc.validToken();
      expect(calls, 1);
    });

    test('token expiry buffer: refreshes 30s before expiry', () {
      final svc = AmadeusTokenService(
          client: MockClient((_) async => _tokenResp()));
      svc.injectToken('tok',
          DateTime.now().add(const Duration(seconds: 20)));
      expect(svc.hasValidToken, isFalse);
    });
  });
}
