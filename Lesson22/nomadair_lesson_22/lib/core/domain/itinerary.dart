import 'package:freezed_annotation/freezed_annotation.dart';
import 'flight.dart';
import 'hotel.dart';
import 'passenger.dart';
import 'price_breakdown.dart';

part 'itinerary.freezed.dart';

enum ItineraryStatus { draft, confirmed, cancelled }

/// Lesson 19 â€” Complete trip container.
///
/// Composes [Flight], optional return [Flight], optional [Hotel],
/// [Passenger] list, [PriceBreakdown] and lifecycle [ItineraryStatus].
///
/// JSON serialization added in Lesson 20 when stored in Hive.
@freezed
class Itinerary with _$Itinerary {
  const Itinerary._();

  const factory Itinerary({
    required String           id,
    required Flight           outbound,
    required List<Passenger>  passengers,
    required PriceBreakdown   pricing,
    Flight?                   returnFlight,
    Hotel?                    hotel,
    @Default(ItineraryStatus.draft) ItineraryStatus status,
    DateTime?                 confirmedAt,
  }) = _Itinerary;

  bool get isRoundTrip   => returnFlight != null;
  bool get includesHotel => hotel != null;
  int  get passengerCount => passengers.length;
  bool get isConfirmed   => status == ItineraryStatus.confirmed;
  bool get isCancelled   => status == ItineraryStatus.cancelled;
}
