import 'package:flutter/material.dart';

/// Translates external deep link URIs to internal GoRouter paths.
///
/// Called in [AppRouter.redirect] to normalise incoming deep link URIs
/// before GoRouter routes them. This decouples the external URL structure
/// from the internal route tree — external URLs can be redesigned without
/// changing any screen-level code.
///
/// External URI examples:
///   nomadair://flights/search?from=BOM&to=DXB
///   https://nomadair.com/flights/search?from=BOM&to=DXB
///   nomadair://destination/DXB
///
/// Internal GoRouter path equivalents:
///   /search?from=BOM&to=DXB
///   /search?from=BOM&to=DXB
///   /discovery/detail?iata=DXB
abstract final class DeepLinkHandler {
  /// Converts a raw deep link [uri] to a GoRouter-compatible path string.
  ///
  /// Returns null if the URI is not a recognised deep link.
  /// Returning null means GoRouter processes the path as-is.
  static String? translate(Uri uri) {
    // ── Custom scheme: nomadair:// ─────────────────────────────
    if (uri.scheme == 'nomadair') {
      return _translateCustomScheme(uri);
    }
    // ── HTTPS app link: https://nomadair.com ───────────────────
    if (uri.scheme == 'https' && uri.host == 'nomadair.com') {
      return _translateHttps(uri);
    }
    return null;
  }

  static String? _translateCustomScheme(Uri uri) {
    final host     = uri.host;         // e.g. 'flights'
    final segments = uri.pathSegments; // e.g. ['search']
    final params   = uri.queryParameters;

    // nomadair://flights/search[?from=&to=]
    if (host == 'flights' &&
        segments.isNotEmpty && segments.first == 'search') {
      return _buildSearchPath(params);
    }
    // nomadair://discovery
    if (host == 'discovery') return '/discovery';

    // nomadair://booking/seat-map
    if (host == 'booking' &&
        segments.isNotEmpty && segments.first == 'seat-map') {
      return '/booking/seat-map';
    }
    // nomadair://destination/{iataCode}
    if (host == 'destination' && segments.isNotEmpty) {
      return '/discovery/detail?iata=${segments.first.toUpperCase()}';
    }
    return null;
  }

  static String? _translateHttps(Uri uri) {
    final segments = uri.pathSegments;
    final params   = uri.queryParameters;

    if (segments.isEmpty) return '/discovery';

    switch (segments.first) {
      case 'flights':
        if (segments.length >= 2 && segments[1] == 'search') {
          return _buildSearchPath(params);
        }
      case 'discovery': return '/discovery';
      case 'booking':
        if (segments.length >= 2 && segments[1] == 'seat-map') {
          return '/booking/seat-map';
        }
      case 'destination':
        if (segments.length >= 2) {
          return '/discovery/detail?iata=${segments[1].toUpperCase()}';
        }
    }
    return null;
  }

  static String _buildSearchPath(Map<String, String> params) {
    final from = params['from'];
    final to   = params['to'];
    if (from != null && to != null) {
      return '/search?from=${Uri.encodeQueryComponent(from)}'
             '&to=${Uri.encodeQueryComponent(to)}';
    }
    return '/search';
  }
}
