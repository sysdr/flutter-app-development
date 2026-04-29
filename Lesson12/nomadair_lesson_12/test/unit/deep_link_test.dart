import 'package:flutter_test/flutter_test.dart';
import 'package:nomadair_lesson_12/deep_links/deep_link_config.dart';
import 'package:nomadair_lesson_12/deep_links/deep_link_handler.dart';

void main() {
  group('DeepLinkConfig', () {
    test('5 entries defined', () =>
        expect(DeepLinkConfig.entries.length, equals(5)));

    test('all entries have non-empty ADB command', () {
      for (final e in DeepLinkConfig.entries) {
        expect(e.adbScheme.trim().isNotEmpty, isTrue,
            reason: '${e.title} missing ADB command');
      }
    });

    test('all entries have valid scheme URI', () {
      for (final e in DeepLinkConfig.entries) {
        expect(() => Uri.parse(e.scheme), returnsNormally,
            reason: '${e.title} has invalid scheme URI');
      }
    });

    test('all entries have GoRouter path starting with /', () {
      for (final e in DeepLinkConfig.entries) {
        expect(e.goPath.startsWith('/'), isTrue,
            reason: '${e.title} goPath must start with /');
      }
    });
  });

  group('DeepLinkHandler.translate — custom scheme', () {
    test('nomadair://flights/search → /search', () {
      final uri = Uri.parse('nomadair://flights/search');
      expect(DeepLinkHandler.translate(uri), equals('/search'));
    });

    test('nomadair://flights/search?from=BOM&to=DXB → /search?from=BOM&to=DXB', () {
      final uri = Uri.parse('nomadair://flights/search?from=BOM&to=DXB');
      final result = DeepLinkHandler.translate(uri);
      expect(result, isNotNull);
      expect(result, contains('/search'));
      expect(result, contains('from=BOM'));
      expect(result, contains('to=DXB'));
    });

    test('nomadair://discovery → /discovery', () {
      final uri = Uri.parse('nomadair://discovery');
      expect(DeepLinkHandler.translate(uri), equals('/discovery'));
    });

    test('nomadair://booking/seat-map → /booking/seat-map', () {
      final uri = Uri.parse('nomadair://booking/seat-map');
      expect(
          DeepLinkHandler.translate(uri),
          equals('/booking/seat-map'));
    });

    test('nomadair://destination/DXB → /discovery/detail?iata=DXB', () {
      final uri = Uri.parse('nomadair://destination/DXB');
      final result = DeepLinkHandler.translate(uri);
      expect(result, contains('/discovery/detail'));
      expect(result, contains('iata=DXB'));
    });

    test('lowercase IATA code is uppercased', () {
      final uri = Uri.parse('nomadair://destination/dxb');
      final result = DeepLinkHandler.translate(uri);
      expect(result, contains('iata=DXB'));
    });

    test('unknown scheme returns null', () {
      final uri = Uri.parse('other://unknown/path');
      expect(DeepLinkHandler.translate(uri), isNull);
    });
  });

  group('DeepLinkHandler.translate — HTTPS app links', () {
    test('https://nomadair.com/flights/search → /search', () {
      final uri = Uri.parse(
          'https://nomadair.com/flights/search');
      expect(DeepLinkHandler.translate(uri), equals('/search'));
    });

    test('https://nomadair.com/discovery → /discovery', () {
      final uri = Uri.parse('https://nomadair.com/discovery');
      expect(DeepLinkHandler.translate(uri), equals('/discovery'));
    });

    test('https://nomadair.com/ → /discovery (root)', () {
      final uri = Uri.parse('https://nomadair.com/');
      expect(DeepLinkHandler.translate(uri), equals('/discovery'));
    });

    test('https://nomadair.com/destination/SIN → detail?iata=SIN', () {
      final uri = Uri.parse(
          'https://nomadair.com/destination/SIN');
      final result = DeepLinkHandler.translate(uri);
      expect(result, contains('iata=SIN'));
    });

    test('different host returns null', () {
      final uri = Uri.parse('https://other.com/flights/search');
      expect(DeepLinkHandler.translate(uri), isNull);
    });
  });
}
