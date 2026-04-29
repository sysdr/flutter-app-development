/// Deep link configuration for NomadAir.
///
/// Defines the mapping from external deep link URLs to internal
/// GoRouter paths. All deep link URLs are declared here as constants.
///
/// Scheme: nomadair://
/// HTTPS:  https://nomadair.com/
///
/// Both schemes map to the same GoRouter paths — the GoRouter handles
/// them uniformly once Android delivers the URI to Flutter.
abstract final class DeepLinkConfig {
  // ── Custom scheme ─────────────────────────────────────────────
  static const String scheme = 'nomadair';
  static const String httpsHost = 'nomadair.com';

  // ── Deep link → GoRoute path mappings ─────────────────────────

  /// nomadair://flights/search
  /// https://nomadair.com/flights/search
  /// → GoRouter: /search
  static const String searchPath    = '/search';
  static const String searchHost    = 'flights';
  static const String searchSegment = 'search';

  /// nomadair://discovery
  /// → GoRouter: /discovery
  static const String discoveryPath = '/discovery';

  /// nomadair://booking/seat-map
  /// → GoRouter: /booking/seat-map
  static const String seatMapPath   = '/booking/seat-map';

  /// nomadair://destination/{iataCode}
  /// → GoRouter: /discovery/detail?iata={iataCode}
  static const String destinationSegment = 'destination';

  /// Full deep link examples (used in ADB commands tab)
  static List<DeepLinkEntry> get entries => [
    const DeepLinkEntry(
      title:       'Search (simple)',
      scheme:      'nomadair://flights/search',
      https:       'https://nomadair.com/flights/search',
      goPath:      '/search',
      description: 'Opens SearchScreen',
      adbScheme:
        'adb shell am start -a android.intent.action.VIEW '
        '-d "nomadair://flights/search" $APP_ID',
    ),
    const DeepLinkEntry(
      title:       'Search (pre-filled)',
      scheme:      'nomadair://flights/search?from=BOM&to=DXB',
      https:       'https://nomadair.com/flights/search?from=BOM&to=DXB',
      goPath:      '/search',
      description: 'SearchScreen with origin=BOM, destination=DXB',
      adbScheme:
        r'adb shell am start -a android.intent.action.VIEW '
        r'-d "nomadair://flights/search?from=BOM%26to=DXB" '
        '$APP_ID',
    ),
    const DeepLinkEntry(
      title:       'Discovery',
      scheme:      'nomadair://discovery',
      https:       'https://nomadair.com/discovery',
      goPath:      '/discovery',
      description: 'Opens DiscoveryScreen',
      adbScheme:
        'adb shell am start -a android.intent.action.VIEW '
        '-d "nomadair://discovery" $APP_ID',
    ),
    const DeepLinkEntry(
      title:       'Booking — Seat Map',
      scheme:      'nomadair://booking/seat-map',
      https:       'https://nomadair.com/booking/seat-map',
      goPath:      '/booking/seat-map',
      description: 'SeatMapScreen placeholder (CustomPainter in L40)',
      adbScheme:
        'adb shell am start -a android.intent.action.VIEW '
        '-d "nomadair://booking/seat-map" $APP_ID',
    ),
    const DeepLinkEntry(
      title:       'Destination Detail — Dubai',
      scheme:      'nomadair://destination/DXB',
      https:       'https://nomadair.com/destination/DXB',
      goPath:      '/discovery/detail',
      description: 'DestinationDetailScreen for DXB (Dubai)',
      adbScheme:
        'adb shell am start -a android.intent.action.VIEW '
        '-d "nomadair://destination/DXB" $APP_ID',
    ),
  ];
}

const APP_ID = 'com.nomadair.lesson12';

/// Describes a single deep link entry.
final class DeepLinkEntry {
  const DeepLinkEntry({
    required this.title,
    required this.scheme,
    required this.https,
    required this.goPath,
    required this.description,
    required this.adbScheme,
  });

  final String title;
  final String scheme;       // nomadair:// URL
  final String https;        // https://nomadair.com URL
  final String goPath;       // Internal GoRouter path
  final String description;  // Human-readable purpose
  final String adbScheme;    // ADB shell command for testing
}
