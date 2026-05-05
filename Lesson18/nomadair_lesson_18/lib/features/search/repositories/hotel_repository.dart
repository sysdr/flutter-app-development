import '../models/hotel_result.dart';
import '../models/search_criteria.dart';
abstract interface class HotelRepository{Future<List<HotelResult>> searchHotels(SearchCriteria criteria);}
