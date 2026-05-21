import 'package:http/http.dart' as http;

// Creates http.Client instances.
//
// Production: returns http.Client() (real network).
// Tests: override with MockClient from package:http/testing.dart.
abstract final class HttpClientFactory {
  static http.Client create() => http.Client();
}
