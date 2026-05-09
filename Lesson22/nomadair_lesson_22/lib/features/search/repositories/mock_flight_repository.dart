import 'dart:math';
import '../../../core/config/mock_config.dart';
import '../../../core/repositories/repository_exception.dart';
import '../models/flight_result.dart';
import '../models/search_criteria.dart';
import 'flight_repository.dart';
final class MockFlightRepository implements FlightRepository{
  static final _latRng=Random();
  static const _airlines=[(code:'6E',name:'IndiGo',mul:0.80),(code:'G9',name:'Air Arabia',mul:0.72),(code:'SG',name:'SpiceJet',mul:0.78),(code:'FZ',name:'FlyDubai',mul:0.85),(code:'AI',name:'Air India',mul:1.00),(code:'UK',name:'Vistara',mul:1.15),(code:'EY',name:'Etihad',mul:1.28),(code:'EK',name:'Emirates',mul:1.40),(code:'SQ',name:'Singapore Airlines',mul:1.45),(code:'BA',name:'British Airways',mul:1.52)];
  static const _deps=[(5,30),(7,15),(9,0),(11,45),(13,0),(15,30),(17,15),(19,0),(21,30),(23,15)];
  static const _prices=<String,double>{'BOM_DXB':18000,'BOM_LHR':43000,'BOM_LGW':41000,'BOM_SIN':22000,'BOM_NRT':38000,'BOM_CDG':48000,'DEL_DXB':19500,'DEL_LHR':40000,'DEL_SIN':24000,'DEL_NRT':36000,'DEL_CDG':45000,'BLR_DXB':20000,'HYD_DXB':19000,'MAA_DXB':20500,'CCU_DXB':21000,'CCU_LHR':44000};
  static const _durs=<String,int>{'BOM_DXB':210,'BOM_LHR':545,'BOM_LGW':540,'BOM_SIN':330,'BOM_NRT':595,'BOM_CDG':555,'DEL_DXB':195,'DEL_LHR':510,'DEL_SIN':345,'DEL_NRT':565,'DEL_CDG':530,'BLR_DXB':225,'HYD_DXB':215,'MAA_DXB':230,'CCU_DXB':240,'CCU_LHR':560};
  static double _bp(String a,String b)=>_prices['${a}_$b']??_prices['${b}_$a']??26000.0;
  static int _bd(String a,String b)=>_durs['${a}_$b']??_durs['${b}_$a']??300;
  static double _cm(CabinClass c)=>switch(c){CabinClass.economy=>1.0,CabinClass.premiumEconomy=>1.8,CabinClass.business=>3.5,CabinClass.firstClass=>6.0};
  static bool _lcc(String code)=>{'6E','SG','G9','FZ'}.contains(code);
  static String _bag(CabinClass c,String code)=>switch(c){CabinClass.economy=>_lcc(code)?'15 kg':'23 kg',CabinClass.premiumEconomy=>'30 kg',CabinClass.business=>'40 kg + 15 kg cabin',CabinClass.firstClass=>'50 kg + 20 kg cabin'};
  @override Future<List<FlightResult>> searchFlights(SearchCriteria c)async{await _delay();if(MockConfig.simulateError)throw const RepositoryException('Network timeout.',statusCode:503);return _gen(c);}
  @override Future<FlightResult?> getFlightDetails(String id)async{await _delay();return _gen(const SearchCriteria()).where((f)=>f.id==id).firstOrNull;}
  Future<void> _delay()async{final ms=MockConfig.minDelayMs+_latRng.nextInt(MockConfig.maxDelayMs-MockConfig.minDelayMs);await Future<void>.delayed(Duration(milliseconds:ms));}
  List<FlightResult> _gen(SearchCriteria c){final org=c.origin?.iata??'BOM';final dst=c.destination?.iata??'DXB';final dep=c.departureDate??DateTime.now().add(const Duration(days:7));final seed='${org}_${dst}_${dep.day}${dep.month}'.hashCode.abs();final rng=Random(seed);final base=_bp(org,dst);final cabM=_cm(c.cabinClass);final durB=_bd(org,dst);return List.generate(10,(i){final al=_airlines[i%_airlines.length];final stops=i<4?0:(i<8?1:2);final t=_deps[i];final depDt=DateTime(dep.year,dep.month,dep.day,t.$1,t.$2);final dur=durB+stops*85+rng.nextInt(25);final arr=depDt.add(Duration(minutes:dur));final raw=base*al.mul*cabM*(0.88+rng.nextDouble()*0.25);final price=(raw/50).round()*50.0;return FlightResult(id:'${al.code}${200+i*37}',airline:al.name,airlineCode:al.code,flightNumber:'${al.code} ${200+i*37}',origin:org,destination:dst,departureTime:depDt,arrivalTime:arr,durationMinutes:dur,priceInr:price,stops:stops,cabinClass:c.cabinClass,seatsLeft:2+rng.nextInt(20),baggageAllowance:_bag(c.cabinClass,al.code),isRefundable:rng.nextBool());});}
}
