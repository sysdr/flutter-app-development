/// A validated city selection from the autocomplete.
///
/// Produced when the user selects a suggestion from [CityPickerField].
/// The presence of this object (not null) indicates a valid city was chosen.
/// Raw text in the field without a selection is invalid.
final class SelectedCity {
  const SelectedCity({
    required this.name,
    required this.iata,
    required this.cityId,
  });

  /// Human-readable city+airport name: "Mumbai Chhatrapati Shivaji"
  final String name;

  /// IATA airport code: "BOM"
  final String iata;

  /// GDS city ID used by flight search APIs (mock for Lesson 14)
  final int cityId;

  String get displayName => '$name ($iata)';

  @override
  String toString() => displayName;

  @override
  bool operator ==(Object other) =>
      other is SelectedCity && other.iata == iata;

  @override
  int get hashCode => iata.hashCode;
}
