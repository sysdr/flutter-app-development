// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlightResult _$FlightResultFromJson(Map<String, dynamic> json) => FlightResult(
      id: json['id'] as String,
      airline: json['airline'] as String,
      airlineCode: json['airline_code'] as String,
      flightNumber: json['flight_number'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureTime: DateTime.parse(json['departure_time'] as String),
      arrivalTime: DateTime.parse(json['arrival_time'] as String),
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      priceInr: (json['price_inr'] as num).toDouble(),
      stops: (json['stops'] as num).toInt(),
      cabinClass: $enumDecode(_$CabinClassEnumMap, json['cabin_class']),
      seatsLeft: (json['seats_left'] as num).toInt(),
      baggageAllowance: json['baggage_allowance'] as String,
      isRefundable: json['is_refundable'] as bool,
    );

Map<String, dynamic> _$FlightResultToJson(FlightResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'airline': instance.airline,
      'airline_code': instance.airlineCode,
      'flight_number': instance.flightNumber,
      'origin': instance.origin,
      'destination': instance.destination,
      'baggage_allowance': instance.baggageAllowance,
      'departure_time': instance.departureTime.toIso8601String(),
      'arrival_time': instance.arrivalTime.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'stops': instance.stops,
      'seats_left': instance.seatsLeft,
      'price_inr': instance.priceInr,
      'cabin_class': _$CabinClassEnumMap[instance.cabinClass]!,
      'is_refundable': instance.isRefundable,
    };

const _$CabinClassEnumMap = {
  CabinClass.economy: 'economy',
  CabinClass.premiumEconomy: 'premiumEconomy',
  CabinClass.business: 'business',
  CabinClass.firstClass: 'firstClass',
};
