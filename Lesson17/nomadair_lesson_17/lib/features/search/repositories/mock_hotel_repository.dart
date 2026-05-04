import 'dart:math';
import '../../../core/config/mock_config.dart';
import '../../../core/repositories/repository_exception.dart';
import '../models/hotel_result.dart';
import '../models/search_criteria.dart';
import 'hotel_repository.dart';

final class MockHotelRepository implements HotelRepository {
  static final _rng = Random();
  static const _names = [
    'Grand Hyatt','Marriott','JW Marriott',
    'Four Seasons','Hilton','Shangri-La',
    'Intercontinental','Radisson Blu','Novotel',
  ];
  static const _basePrices = <String,double>{
    'DXB':12000,'LHR':18000,'LGW':15000,
    'SIN':14000,'NRT':16000,'CDG':17000,
  };

  @override
  Future<List<HotelResult>> searchHotels(SearchCriteria c) async {
    final ms = MockConfig.minDelayMs +
        _rng.nextInt(MockConfig.maxDelayMs - MockConfig.minDelayMs);
    await Future<void>.delayed(Duration(milliseconds: ms));
    if (MockConfig.simulateError) {
      throw const RepositoryException('Hotel service unavailable.');
    }
    final dst  = c.destination?.iata ?? 'DXB';
    final seed = '${dst}_hotels'.hashCode.abs();
    final r    = Random(seed);
    final base = _basePrices[dst] ?? 13000.0;
    return List.generate(5, (i) {
      final stars = StarRating.values[2 + r.nextInt(3)];
      final mul   = switch (stars) {
        StarRating.three => 0.7,
        StarRating.four  => 1.0,
        StarRating.five  => 1.6,
        _ => 1.0,
      };
      final price = (base * mul * (0.9 + r.nextDouble() * 0.2) / 100)
          .round() * 100.0;
      return HotelResult(
        id:                   'hotel_${dst}_$i',
        name:                 '${_names[i % _names.length]} $dst',
        city:                 dst,
        countryCode:          dst.substring(0, 2),
        starRating:           stars,
        pricePerNightInr:     price,
        boardType:            BoardType.values[r.nextInt(3)],
        distanceFromCentreKm: 0.5 + r.nextDouble() * 8,
        isRefundable:         r.nextBool(),
        availableRooms:       1 + r.nextInt(15),
        reviewScore:          7.0 + r.nextDouble() * 2.5,
        reviewCount:          100 + r.nextInt(900),
      );
    });
  }
}
