import '../../../features/search/data/city_database.dart';
import '../../../features/search/models/search_criteria.dart';
import '../../../features/search/models/selected_city.dart';
import 'deep_link_intent.dart';

// Pure-Dart parser: Uri → DeepLinkIntent.
//
// No Flutter, no BuildContext — fully unit-testable.
//
// Supported URI: nomadair://search?from=IATA&to=IATA&date=YYYY-MM-DD
//   from=   required for any intent; must be a known IATA code.
//   to=     optional; if absent → PreFillIntent with only origin.
//   date=   optional; must be ISO-8601 date string.
//           When from + to + date all present → SearchIntent (full criteria).
//           When from + to present but no date → PreFillIntent.
//           When from unknown → InvalidIntent.
final class DeepLinkResolver {
  const DeepLinkResolver();

  DeepLinkIntent resolve(Uri uri) {
    final params = uri.queryParameters;
    final rawFrom = params['from']?.toUpperCase();
    final rawTo   = params['to']?.toUpperCase();
    final rawDate = params['date'];

    // from= is always required
    if (rawFrom == null || rawFrom.isEmpty) {
      return const InvalidIntent('Missing from= parameter');
    }

    final origin = _lookupCity(rawFrom);
    if (origin == null) {
      return InvalidIntent('Unknown airport code: $rawFrom');
    }

    // Parse optional date
    DateTime? date;
    if (rawDate != null) {
      date = _parseDate(rawDate);
      if (date == null) {
        return InvalidIntent(
            'Invalid date format (expected YYYY-MM-DD): $rawDate');
      }
    }

    // Check destination
    if (rawTo == null || rawTo.isEmpty) {
      return PreFillIntent(originIata: origin.iata, date: date);
    }

    final dest = _lookupCity(rawTo);
    if (dest == null) {
      return InvalidIntent('Unknown airport code: $rawTo');
    }

    if (origin.iata == dest.iata) {
      return const InvalidIntent(
          'Origin and destination cannot be the same');
    }

    // Full criteria — date may or may not be present
    if (date == null) {
      return PreFillIntent(
          originIata:      origin.iata,
          destinationIata: dest.iata,
          date:            null);
    }

    return SearchIntent(
      SearchCriteria(
        origin:        origin,
        destination:   dest,
        departureDate: date,
        passengers:    const PassengerCount(adults: 1),
        cabinClass:    CabinClass.economy,
      ),
    );
  }

  static SelectedCity? _lookupCity(String iata) =>
      CityDatabase.cities
          .where((c) => c.iata == iata)
          .firstOrNull;

  static DateTime? _parseDate(String raw) {
    try {
      final parts = raw.split('-');
      if (parts.length != 3) return null;
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      if (y < 2020 || m < 1 || m > 12 || d < 1 || d > 31) return null;
      return DateTime(y, m, d);
    } catch (_) {
      return null;
    }
  }
}
