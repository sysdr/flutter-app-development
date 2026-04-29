import 'package:intl/intl.dart';
import 'selected_city.dart';

/// Cabin class for flight search.
enum CabinClass {
  economy(label: 'Economy'),
  premiumEconomy(label: 'Premium Economy'),
  business(label: 'Business'),
  firstClass(label: 'First Class');

  const CabinClass({required this.label});
  final String label;
}

/// Passenger counts with airline constraint validation.
///
/// Constraint: infants ≤ adults (each infant must sit on an adult's lap).
final class PassengerCount {
  const PassengerCount({
    this.adults   = 1,
    this.children = 0,
    this.infants  = 0,
  });

  final int adults;
  final int children;
  final int infants;

  int get total => adults + children + infants;

  /// Human-readable summary for the form field display.
  String get summary {
    final parts = <String>[];
    parts.add('$adults Adult${adults == 1 ? '' : 's'}');
    if (children > 0) {
      parts.add('$children Child${children == 1 ? '' : 'ren'}');
    }
    if (infants > 0) {
      parts.add('$infants Infant${infants == 1 ? '' : 's'}');
    }
    return parts.join(', ');
  }

  PassengerCount copyWith({int? adults, int? children, int? infants}) =>
      PassengerCount(
        adults:   adults   ?? this.adults,
        children: children ?? this.children,
        infants:  infants  ?? this.infants,
      );
}

/// Complete flight search form state.
///
/// Lesson 14: populated by form submission, passed to SearchResultsScreen
/// via GoRouter state.extra.
///
/// Lesson 16: lifted into Provider so Search + Results screens share state.
final class SearchCriteria {
  const SearchCriteria({
    this.origin,
    this.destination,
    this.departureDate,
    this.returnDate,
    this.passengers = const PassengerCount(),
    this.cabinClass = CabinClass.economy,
    this.isRoundTrip = true,
  });

  final SelectedCity?   origin;
  final SelectedCity?   destination;
  final DateTime?       departureDate;
  final DateTime?       returnDate;
  final PassengerCount  passengers;
  final CabinClass      cabinClass;
  final bool            isRoundTrip;

  static final _fmt = DateFormat('dd MMM yyyy');

  String get departureDateDisplay =>
      departureDate != null ? _fmt.format(departureDate!) : '';

  String get returnDateDisplay =>
      returnDate != null ? _fmt.format(returnDate!) : '';

  /// Returns null if valid, or an error message if invalid.
  String? validate() {
    if (origin == null) {
      return 'Please select a valid departure city';
    }
    if (destination == null) {
      return 'Please select a valid destination city';
    }
    if (origin!.iata == destination!.iata) {
      return 'Origin and destination cannot be the same city';
    }
    if (departureDate == null) {
      return 'Please select a departure date';
    }
    if (isRoundTrip && returnDate == null) {
      return 'Please select a return date';
    }
    if (isRoundTrip &&
        returnDate != null &&
        !returnDate!.isAfter(departureDate!)) {
      return 'Return date must be after departure date';
    }
    return null; // valid
  }

  SearchCriteria copyWith({
    SelectedCity? origin,
    SelectedCity? destination,
    DateTime?     departureDate,
    DateTime?     returnDate,
    PassengerCount? passengers,
    CabinClass?   cabinClass,
    bool?         isRoundTrip,
  }) => SearchCriteria(
    origin:        origin        ?? this.origin,
    destination:   destination   ?? this.destination,
    departureDate: departureDate ?? this.departureDate,
    returnDate:    returnDate    ?? this.returnDate,
    passengers:    passengers   ?? this.passengers,
    cabinClass:    cabinClass   ?? this.cabinClass,
    isRoundTrip:   isRoundTrip  ?? this.isRoundTrip,
  );
}
