/// NomadAir route path constants.
///
/// Unchanged from Lesson 10 — GoRouter uses the same strings.
/// Every [context.go] / [context.push] call references a constant here.
/// Zero raw string literals permitted in navigation call sites.
abstract final class NavigatorRoutes {
  // ── Shell tabs ──────────────────────────────────────────────────
  static const String discovery        = '/discovery';
  static const String destinationDetail = '/discovery/detail';

  static const String search           = '/search';
  static const String searchResults    = '/search/results';

  static const String trips            = '/trips';

  // ── Booking (off-tab screens — full-screen push) ───────────────
  static const String seatMap          = '/booking/seat-map';
  static const String passengerForm    = '/booking/passengers';
  static const String payment          = '/booking/payment';
  static const String confirmation     = '/booking/confirmation';

  // ── Profile ────────────────────────────────────────────────────
  static const String profile          = '/profile';
  static const String settings         = '/profile/settings';

  // ── All routes list — used by NavigationExplorer ───────────────
  static const List<String> all = [
    discovery, destinationDetail,
    search, searchResults,
    trips,
    seatMap, passengerForm, payment, confirmation,
    profile, settings,
  ];
}
