import 'package:hive/hive.dart';
part 'recent_search.g.dart';

@HiveType(typeId: 0)
class RecentSearch {
  RecentSearch({
    required this.originIata,
    required this.originName,
    required this.destinationIata,
    required this.destinationName,
    required this.searchedAt,
    required this.cabinClassLabel,
    required this.passengerCount,
  });

  @HiveField(0) final String   originIata;
  @HiveField(1) final String   originName;
  @HiveField(2) final String   destinationIata;
  @HiveField(3) final String   destinationName;
  @HiveField(4) final DateTime searchedAt;
  @HiveField(5) final String   cabinClassLabel;
  @HiveField(6) final int      passengerCount;

  String get routeLabel  => '$originIata → $destinationIata';
  String get detailLabel => '$cabinClassLabel · $passengerCount pax';

  @override
  String toString() => 'RecentSearch($routeLabel)';
}
