import 'dart:convert';
import 'package:http/http.dart' as http;
import 'network_config.dart';
import 'network_exception.dart';

// OAuth 2.0 client-credentials token cache.
//
// Caches the bearer token in memory and refreshes it when expired.
// Thread-safe for single-isolate Flutter apps.
//
// Usage:
//   final svc = AmadeusTokenService();
//   final token = await svc.validToken(client);
final class AmadeusTokenService {
  AmadeusTokenService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  String?   _token;
  DateTime? _expiresAt;

  bool get hasValidToken =>
      _token != null &&
      _expiresAt != null &&
      DateTime.now().isBefore(
          _expiresAt!.subtract(const Duration(seconds: 30)));

  // Returns a valid bearer token, refreshing if needed.
  Future<String> validToken() async {
    if (hasValidToken) return _token!;
    return _refresh();
  }

  Future<String> _refresh() async {
    final uri = Uri.parse(
        NetworkConfig.amadeusBaseUrl + NetworkConfig.tokenPath);
    late http.Response resp;
    try {
      resp = await _client
          .post(
            uri,
            headers: {
              'Content-Type':
                  'application/x-www-form-urlencoded',
            },
            body: {
              'grant_type':    'client_credentials',
              'client_id':     NetworkConfig.apiKey,
              'client_secret': NetworkConfig.apiSecret,
            },
          )
          .timeout(NetworkConfig.connectTimeout);
    } on Exception {
      throw const NetworkTimeoutException();
    }

    if (resp.statusCode == 401) {
      throw const NetworkAuthException(
          'Invalid Amadeus API key or secret');
    }
    if (resp.statusCode != 200) {
      throw HttpStatusException(
          resp.statusCode, 'Token endpoint returned ${resp.statusCode}');
    }

    final Map<String, dynamic> body;
    try {
      body = json.decode(resp.body) as Map<String, dynamic>;
    } catch (_) {
      throw const NetworkParseException(
          'Token response is not valid JSON');
    }

    final accessToken = body['access_token'] as String?;
    final expiresIn   = body['expires_in']   as int?;
    if (accessToken == null || expiresIn == null) {
      throw const NetworkParseException(
          'Token response missing access_token or expires_in');
    }

    _token     = accessToken;
    _expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
    return _token!;
  }

  // For testing: inject a known token + expiry.
  void injectToken(String token, DateTime expiresAt) {
    _token     = token;
    _expiresAt = expiresAt;
  }

  void clearToken() {
    _token     = null;
    _expiresAt = null;
  }
}
