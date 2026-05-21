import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_breakdown.freezed.dart';

/// Lesson 19 — Fare decomposition.
///
/// Formula:   total = baseFare + taxes + fees + surcharges − discount
///
/// [total] is a *computed getter*, not a stored field. Because this class
/// is immutable, the result is always consistent with the component fields.
///
/// Why [const PriceBreakdown._();]?
///   Without the private constructor, Freezed's generated _$PriceBreakdown
///   class cannot call super._(), so custom getters cannot be defined.
@freezed
class PriceBreakdown with _$PriceBreakdown {
  const PriceBreakdown._(); // MUST appear before the factory

  const factory PriceBreakdown({
    required double baseFare,
    required double taxes,
    required double fees,
    @Default(0.0) double surcharges,
    @Default(0.0) double discount,
  }) = _PriceBreakdown;

  double get total =>
      baseFare + taxes + fees + surcharges - discount;

  String get formattedTotal => '₹${total.toStringAsFixed(0)}';

  bool get hasDiscount => discount > 0;

  String get formattedDiscount =>
      hasDiscount ? '-₹${discount.toStringAsFixed(0)}' : '';

  /// Split total evenly among [count] passengers.
  double perPerson(int count) => count > 0 ? total / count : total;
}
