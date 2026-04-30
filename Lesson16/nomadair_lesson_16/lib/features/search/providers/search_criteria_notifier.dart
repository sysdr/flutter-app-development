import 'package:flutter/foundation.dart';
import '../models/search_criteria.dart';
import '../models/selected_city.dart';

/// Lesson 16 — SearchCriteriaNotifier.
///
/// Moves [SearchCriteria] out of [SearchScreen]'s local [setState]
/// and into a [ChangeNotifier] placed above [MaterialApp.router].
///
/// Benefits over setState (Lesson 14–15):
///   1. Criteria survives tab switches WITHOUT [AutomaticKeepAliveClientMixin]
///   2. [SearchResultsScreen] reads criteria WITHOUT GoRouter extra
///   3. Any widget below [ChangeNotifierProvider] can read criteria
///
/// Limitations (motivating Riverpod in Lesson 32):
///   1. Requires [BuildContext] at every call site
///   2. Cannot be read outside the widget tree (repositories, services)
///   3. Async state (loading/error/data) requires manual management
///
/// Migration path:
///   L16: ChangeNotifier + context.watch / context.read
///   L32: Riverpod NotifierProvider + ref.watch / ref.read
final class SearchCriteriaNotifier extends ChangeNotifier {
  SearchCriteria _criteria = const SearchCriteria();

  /// Current search criteria. Never null.
  SearchCriteria get criteria => _criteria;

  // ── Setters — each calls notifyListeners() ─────────────────────

  /// Sets departure city. Skips notification if unchanged.
  void setOrigin(SelectedCity? city) {
    if (_criteria.origin == city) return;
    _criteria = _criteria.copyWith(origin: city);
    notifyListeners();
  }

  /// Sets arrival city. Skips notification if unchanged.
  void setDestination(SelectedCity? city) {
    if (_criteria.destination == city) return;
    _criteria = _criteria.copyWith(destination: city);
    notifyListeners();
  }

  /// Sets departure date.
  /// Auto-clears return date if it would become before departure.
  void setDepartureDate(DateTime? date) {
    _criteria = _criteria.copyWith(
      departureDate: date,
      returnDate: _criteria.returnDate != null &&
          date != null &&
          _criteria.returnDate!.isBefore(date)
          ? null
          : _criteria.returnDate,
    );
    notifyListeners();
  }

  /// Sets return date.
  void setReturnDate(DateTime? date) {
    _criteria = _criteria.copyWith(returnDate: date);
    notifyListeners();
  }

  /// Sets passenger counts.
  void setPassengers(PassengerCount passengers) {
    _criteria = _criteria.copyWith(passengers: passengers);
    notifyListeners();
  }

  /// Sets cabin class.
  void setCabinClass(CabinClass cabinClass) {
    if (_criteria.cabinClass == cabinClass) return;
    _criteria = _criteria.copyWith(cabinClass: cabinClass);
    notifyListeners();
  }

  /// Toggles round-trip / one-way.
  /// Clears return date when switching to one-way.
  void setRoundTrip(bool isRoundTrip) {
    _criteria = _criteria.copyWith(
      isRoundTrip: isRoundTrip,
      returnDate: isRoundTrip ? _criteria.returnDate : null,
    );
    notifyListeners();
  }

  /// Resets all criteria to defaults.
  void reset() {
    _criteria = const SearchCriteria();
    notifyListeners();
  }

  /// Validates current criteria.
  /// Returns null if valid, error message if invalid.
  String? validate() => _criteria.validate();
}
