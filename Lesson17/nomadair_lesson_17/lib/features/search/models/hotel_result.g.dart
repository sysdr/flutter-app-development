// GENERATED CODE — DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element
part of 'hotel_result.dart';

HotelResult _$HotelResultFromJson(Map<String, dynamic> json) =>
    HotelResult(
      id:                   json['id']                    as String,
      name:                 json['name']                  as String,
      city:                 json['city']                  as String,
      countryCode:          json['country_code']          as String,
      starRating:           _$starFromJson(json['star_rating']    as String),
      pricePerNightInr:     (json['price_per_night_inr']  as num).toDouble(),
      boardType:            _$boardFromJson(json['board_type']    as String),
      distanceFromCentreKm: (json['distance_from_centre_km'] as num).toDouble(),
      isRefundable:         json['is_refundable']         as bool,
      availableRooms:       json['available_rooms']       as int,
      reviewScore:          (json['review_score']         as num).toDouble(),
      reviewCount:          json['review_count']          as int,
    );

Map<String, dynamic> _$HotelResultToJson(HotelResult i) => {
  'id': i.id, 'name': i.name, 'city': i.city,
  'country_code': i.countryCode,
  'star_rating': _$starToJson(i.starRating),
  'price_per_night_inr': i.pricePerNightInr,
  'board_type': _$boardToJson(i.boardType),
  'distance_from_centre_km': i.distanceFromCentreKm,
  'is_refundable': i.isRefundable,
  'available_rooms': i.availableRooms,
  'review_score': i.reviewScore,
  'review_count': i.reviewCount,
};

StarRating _$starFromJson(String s) => switch (s) {
  'one' => StarRating.one, 'two' => StarRating.two,
  'three' => StarRating.three, 'four' => StarRating.four,
  'five' => StarRating.five,
  _ => throw ArgumentError('Unknown star: $s'),
};
String _$starToJson(StarRating s) => s.name;
BoardType _$boardFromJson(String s) => switch (s) {
  'roomOnly'          => BoardType.roomOnly,
  'breakfastIncluded' => BoardType.breakfastIncluded,
  'halfBoard'         => BoardType.halfBoard,
  'allInclusive'      => BoardType.allInclusive,
  _ => throw ArgumentError('Unknown board: $s'),
};
String _$boardToJson(BoardType b) => b.name;
