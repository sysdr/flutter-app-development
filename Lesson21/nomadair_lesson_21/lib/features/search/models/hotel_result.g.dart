// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotel_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotelResult _$HotelResultFromJson(Map<String, dynamic> json) => HotelResult(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      countryCode: json['country_code'] as String,
      starRating: $enumDecode(_$StarRatingEnumMap, json['star_rating']),
      pricePerNightInr: (json['price_per_night_inr'] as num).toDouble(),
      boardType: $enumDecode(_$BoardTypeEnumMap, json['board_type']),
      distanceFromCentreKm: (json['distance_from_centre_km'] as num).toDouble(),
      isRefundable: json['is_refundable'] as bool,
      availableRooms: (json['available_rooms'] as num).toInt(),
      reviewScore: (json['review_score'] as num).toDouble(),
      reviewCount: (json['review_count'] as num).toInt(),
    );

Map<String, dynamic> _$HotelResultToJson(HotelResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'country_code': instance.countryCode,
      'star_rating': _$StarRatingEnumMap[instance.starRating]!,
      'price_per_night_inr': instance.pricePerNightInr,
      'board_type': _$BoardTypeEnumMap[instance.boardType]!,
      'distance_from_centre_km': instance.distanceFromCentreKm,
      'is_refundable': instance.isRefundable,
      'available_rooms': instance.availableRooms,
      'review_score': instance.reviewScore,
      'review_count': instance.reviewCount,
    };

const _$StarRatingEnumMap = {
  StarRating.one: 'one',
  StarRating.two: 'two',
  StarRating.three: 'three',
  StarRating.four: 'four',
  StarRating.five: 'five',
};

const _$BoardTypeEnumMap = {
  BoardType.roomOnly: 'roomOnly',
  BoardType.breakfastIncluded: 'breakfastIncluded',
  BoardType.halfBoard: 'halfBoard',
  BoardType.allInclusive: 'allInclusive',
};
