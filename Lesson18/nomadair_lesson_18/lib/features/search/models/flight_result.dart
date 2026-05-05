import 'package:json_annotation/json_annotation.dart';
import 'search_criteria.dart';
part 'flight_result.g.dart';
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
final class FlightResult {
  const FlightResult({required this.id,required this.airline,required this.airlineCode,required this.flightNumber,required this.origin,required this.destination,required this.departureTime,required this.arrivalTime,required this.durationMinutes,required this.priceInr,required this.stops,required this.cabinClass,required this.seatsLeft,required this.baggageAllowance,required this.isRefundable});
  final String id,airline,airlineCode,flightNumber,origin,destination,baggageAllowance;
  final DateTime departureTime,arrivalTime;
  final int durationMinutes,stops,seatsLeft;
  final double priceInr;
  final CabinClass cabinClass;
  final bool isRefundable;
  String get stopsLabel=>stops==0?'Non-stop':'$stops stop${stops==1?'':'s'}';
  String get formattedPrice=>'₹${priceInr.toStringAsFixed(0)}';
  String get formattedDuration{final h=durationMinutes~/60;final m=durationMinutes%60;return m==0?'${h}h':'${h}h ${m}m';}
  String get accessibilityLabel=>'$airline $flightNumber, $origin to $destination, $formattedPrice, $stopsLabel, $formattedDuration';
  factory FlightResult.fromJson(Map<String,dynamic> json)=>_$FlightResultFromJson(json);
  Map<String,dynamic> toJson()=>_$FlightResultToJson(this);
}
