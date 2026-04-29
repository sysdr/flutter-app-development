import '../models/selected_city.dart';

/// Mock city database for autocomplete in Lesson 14.
///
/// Lesson 17: replaced with [MockCitySearchRepository] returning
/// a Future<List<SelectedCity>> from a typed async method.
///
/// Lesson 32: replaced with Riverpod StreamProvider watching
/// a debounced text stream.
abstract final class CityDatabase {
  static const List<SelectedCity> cities = [
    SelectedCity(name: 'Mumbai Chhatrapati Shivaji', iata: 'BOM', cityId: 6291),
    SelectedCity(name: 'Delhi Indira Gandhi International', iata: 'DEL', cityId: 6290),
    SelectedCity(name: 'Bengaluru Kempegowda', iata: 'BLR', cityId: 6289),
    SelectedCity(name: 'Hyderabad Rajiv Gandhi', iata: 'HYD', cityId: 6288),
    SelectedCity(name: 'Chennai International', iata: 'MAA', cityId: 6287),
    SelectedCity(name: 'Kolkata Netaji Subhas Chandra Bose', iata: 'CCU', cityId: 6286),
    SelectedCity(name: 'Dubai International', iata: 'DXB', cityId: 5001),
    SelectedCity(name: 'London Heathrow', iata: 'LHR', cityId: 4001),
    SelectedCity(name: 'London Gatwick', iata: 'LGW', cityId: 4002),
    SelectedCity(name: 'Singapore Changi', iata: 'SIN', cityId: 3001),
    SelectedCity(name: 'Tokyo Narita', iata: 'NRT', cityId: 2001),
    SelectedCity(name: 'Paris Charles de Gaulle', iata: 'CDG', cityId: 1001),
  ];

  /// Filters cities matching [query] by name or IATA code.
  /// Returns up to 6 results. Minimum query length: 2 characters.
  static List<SelectedCity> search(String query) {
    if (query.trim().length < 2) return const [];
    final q = query.toLowerCase();
    return cities
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.iata.toLowerCase().contains(q))
        .take(6)
        .toList();
  }
}
