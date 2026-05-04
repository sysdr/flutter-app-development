import 'package:json_annotation/json_annotation.dart';
part 'hotel_result.g.dart';

enum StarRating { one, two, three, four, five }
enum BoardType  { roomOnly, breakfastIncluded, halfBoard, allInclusive }

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
final class HotelResult {
  const HotelResult({
    required this.id,
    required this.name,
    required this.city,
    required this.countryCode,
    required this.starRating,
    required this.pricePerNightInr,
    required this.boardType,
    required this.distanceFromCentreKm,
    required this.isRefundable,
    required this.availableRooms,
    required this.reviewScore,
    required this.reviewCount,
  });
  final String     id, name, city, countryCode;
  final StarRating starRating;
  final double     pricePerNightInr;
  final BoardType  boardType;
  final double     distanceFromCentreKm;
  final bool       isRefundable;
  final int        availableRooms;
  final double     reviewScore;
  final int        reviewCount;
  String get formattedPrice =>
      '₹${pricePerNightInr.toStringAsFixed(0)}/night';
  factory HotelResult.fromJson(Map<String, dynamic> json) =>
      _$HotelResultFromJson(json);
  Map<String, dynamic> toJson() => _$HotelResultToJson(this);
}
