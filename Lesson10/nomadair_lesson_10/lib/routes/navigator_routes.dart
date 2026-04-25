/// NomadAir route name constants.
///
/// All route strings live here. Never use a raw string literal for
/// navigation anywhere in the codebase — always reference a constant.
///
/// GoRouter (Lesson 11) will replace the [Navigator.pushNamed] calls
/// but will reuse these exact string constants unchanged.
///
/// [abstract final class]: cannot be instantiated or subclassed.
abstract final class NavigatorRoutes {
  // ── Discovery ──────────────────────────────────────────────────
  /// Home tab — destination discovery feed.
  static const String discovery        = '/discovery';

  /// Destination detail screen — full-page destination view.
  static const String destinationDetail = '/discovery/detail';

  // ── Search ────────────────────────────────────────────────────
  /// Flight search form.
  static const String search           = '/search';

  /// Search results list.
  static const String searchResults    = '/search/results';

  // ── Booking ───────────────────────────────────────────────────
  /// Seat selection (CustomPainter seat map — Lesson 40).
  static const String seatMap          = '/booking/seat-map';

  /// Passenger details form.
  static const String passengerForm    = '/booking/passengers';

  /// Payment screen.
  static const String payment          = '/booking/payment';

  /// Booking confirmation.
  static const String confirmation     = '/booking/confirmation';

  // ── Profile ───────────────────────────────────────────────────
  /// User profile and saved trips.
  static const String profile          = '/profile';

  /// Saved trips list.
  static const String savedTrips       = '/profile/trips';

  /// App settings (theme, currency, notifications).
  static const String settings         = '/profile/settings';

  /// List of all routes — used by FeatureRouteExplorer.
  static const List<String> all = [
    discovery, destinationDetail,
    search, searchResults,
    seatMap, passengerForm, payment, confirmation,
    profile, savedTrips, settings,
  ];
}
