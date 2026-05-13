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

  // Converts one Amadeus flight-offer object to FlightResult.
  factory FlightResult.fromAmadeusJson(Map<String,dynamic> offer){
    final iti=(offer['itineraries'] as List)[0] as Map<String,dynamic>;
    final segs=iti['segments'] as List;
    final first=segs.first as Map<String,dynamic>;
    final last=segs.last as Map<String,dynamic>;
    final fareDetail=((offer['travelerPricings'] as List)[0] as Map<String,dynamic>)['fareDetailsBySegment'] as List;
    final cabin=(fareDetail[0] as Map<String,dynamic>)['cabin'] as String?? 'ECONOMY';
    final durMin=_parseDuration(iti['duration'] as String);
    final depart=DateTime.parse((first['departure'] as Map)['at'] as String);
    final arrive=DateTime.parse((last['arrival'] as Map)['at'] as String);
    final stops=segs.fold<int>(0,(a,s)=>a+((s as Map)['numberOfStops'] as int?? 0));
    final price=double.tryParse((offer['price'] as Map)['grandTotal'] as String?? '0')??0;
    final airline=((offer['validatingAirlineCodes'] as List).firstOrNull as String?)?? '';
    final cc=(first['carrierCode'] as String?)?? airline;
    final fn=(first['number'] as String?)?? '';
    final rawFlight='$cc $fn'.trim();
    final flightNum=rawFlight.isEmpty?'${_airlineName(airline)} ${offer['id']}':rawFlight;
    final cabinCls=_cabinFromAmadeus(cabin);
    return FlightResult(id:offer['id'] as String??'',airline:_airlineName(airline),airlineCode:airline,flightNumber:flightNum,origin:(first['departure'] as Map)['iataCode'] as String??'',destination:(last['arrival'] as Map)['iataCode'] as String??'',departureTime:depart,arrivalTime:arrive,durationMinutes:durMin,stops:stops,cabinClass:cabinCls,priceInr:price,seatsLeft:9,baggageAllowance:_baggageKg(cabinCls),isRefundable:false);}
  static int _parseDuration(String s){final m=RegExp(r'PT(?:([0-9]+)H)?(?:([0-9]+)M)?').firstMatch(s);return(int.tryParse(m?.group(1)??'')?? 0)*60+(int.tryParse(m?.group(2)??'')?? 0);}
  static CabinClass _cabinFromAmadeus(String c)=>switch(c){'PREMIUM_ECONOMY'=>CabinClass.premiumEconomy,'BUSINESS'=>CabinClass.business,'FIRST'=>CabinClass.firstClass,_=>CabinClass.economy};
  static String _baggageKg(CabinClass c)=>switch(c){CabinClass.economy=>'23 kg',CabinClass.premiumEconomy=>'30 kg',CabinClass.business=>'40 kg',CabinClass.firstClass=>'50 kg'};
  static String _airlineName(String c)=>switch(c){'AI'=>'Air India','EK'=>'Emirates','6E'=>'IndiGo','SG'=>'SpiceJet','UK'=>'Vistara','QR'=>'Qatar Airways','SQ'=>'Singapore Airlines','BA'=>'British Airways','LH'=>'Lufthansa','AF'=>'Air France',_=>c};
}
