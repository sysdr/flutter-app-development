import 'package:flutter/foundation.dart';
import '../../../core/repositories/repository_exception.dart';
import '../models/flight_result.dart';
import '../models/search_criteria.dart';
import '../repositories/flight_repository.dart';
enum SortBy{price(label:'Price ↑'),duration(label:'Duration'),departure(label:'Departure');const SortBy({required this.label});final String label;}
sealed class FlightSearchState{const FlightSearchState();}
final class FlightSearchIdle extends FlightSearchState{const FlightSearchIdle();}
final class FlightSearchLoading extends FlightSearchState{const FlightSearchLoading();}
final class FlightSearchLoaded extends FlightSearchState{const FlightSearchLoaded(this.flights,{this.sortBy=SortBy.price});final List<FlightResult> flights;final SortBy sortBy;List<FlightResult> get sorted=>switch(sortBy){SortBy.price=>[...flights]..sort((a,b)=>a.priceInr.compareTo(b.priceInr)),SortBy.duration=>[...flights]..sort((a,b)=>a.durationMinutes.compareTo(b.durationMinutes)),SortBy.departure=>[...flights]..sort((a,b)=>a.departureTime.compareTo(b.departureTime))};FlightSearchLoaded withSort(SortBy s)=>FlightSearchLoaded(flights,sortBy:s);}
final class FlightSearchError extends FlightSearchState{const FlightSearchError(this.message);final String message;}
final class FlightSearchNotifier extends ChangeNotifier{FlightSearchNotifier(this._repo);final FlightRepository _repo;FlightSearchState _state=const FlightSearchIdle();FlightSearchState get state=>_state;Future<void> search(SearchCriteria criteria)async{_state=const FlightSearchLoading();notifyListeners();try{final flights=await _repo.searchFlights(criteria);_state=FlightSearchLoaded(flights);}on RepositoryException catch(e){_state=FlightSearchError(e.message);}catch(_){_state=const FlightSearchError('Something went wrong. Please try again.');}notifyListeners();}void setSortBy(SortBy s){final cur=_state;if(cur is FlightSearchLoaded&&cur.sortBy!=s){_state=cur.withSort(s);notifyListeners();}}void reset(){_state=const FlightSearchIdle();notifyListeners();}}
