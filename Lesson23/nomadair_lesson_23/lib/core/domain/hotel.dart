import 'package:freezed_annotation/freezed_annotation.dart';

part 'hotel.freezed.dart';

/// Lesson 19 — Immutable domain model for a hotel.
@freezed
class Hotel with _$Hotel {
  const Hotel._();

  const factory Hotel({
    required String id,
    required String name,
    required String cityIata,
    required String countryCode,
    required int    starRating,
    required String boardType,
    required double distanceFromCentreKm,
    required bool   isRefundable,
    required double reviewScore,
    required int    reviewCount,
    @Default(false) bool isFavourite,
  }) = _Hotel;

  /// Star rating as unicode star characters: ★★★★★
  String get formattedStarRating =>
      '★' * starRating.clamp(1, 5);

  String get reviewLabel {
    if (reviewScore >= 9.0) return 'Exceptional';
    if (reviewScore >= 8.0) return 'Excellent';
    if (reviewScore >= 7.0) return 'Very Good';
    if (reviewScore >= 6.0) return 'Good';
    return 'Fair';
  }
}
