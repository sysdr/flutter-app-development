abstract final class NavigatorRoutes {
  static const String discovery        = '/discovery';
  static const String destinationDetail = '/discovery/detail';
  static const String search           = '/search';
  static const String searchResults    = '/search/results';
  static const String trips            = '/trips';
  static const String seatMap          = '/booking/seat-map';
  static const String passengerForm    = '/booking/passengers';
  static const String payment          = '/booking/payment';
  static const String confirmation     = '/booking/confirmation';
  static const String profile          = '/profile';
  static const String settings         = '/profile/settings';

  static const List<String> all = [
    discovery, destinationDetail, search, searchResults,
    trips, seatMap, passengerForm, payment, confirmation,
    profile, settings,
  ];
}
