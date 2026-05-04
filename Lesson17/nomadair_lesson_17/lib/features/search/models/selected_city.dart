final class SelectedCity {
  const SelectedCity({
    required this.name,
    required this.iata,
    required this.cityId,
  });
  final String name;
  final String iata;
  final int    cityId;
  String get displayName => '$name ($iata)';
  @override String toString() => displayName;
  @override bool operator ==(Object other) =>
      other is SelectedCity && other.iata == iata;
  @override int get hashCode => iata.hashCode;
}
