// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_breakdown.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PriceBreakdown {
  double get baseFare => throw _privateConstructorUsedError;
  double get taxes => throw _privateConstructorUsedError;
  double get fees => throw _privateConstructorUsedError;
  double get surcharges => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;

  /// Create a copy of PriceBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PriceBreakdownCopyWith<PriceBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceBreakdownCopyWith<$Res> {
  factory $PriceBreakdownCopyWith(
          PriceBreakdown value, $Res Function(PriceBreakdown) then) =
      _$PriceBreakdownCopyWithImpl<$Res, PriceBreakdown>;
  @useResult
  $Res call(
      {double baseFare,
      double taxes,
      double fees,
      double surcharges,
      double discount});
}

/// @nodoc
class _$PriceBreakdownCopyWithImpl<$Res, $Val extends PriceBreakdown>
    implements $PriceBreakdownCopyWith<$Res> {
  _$PriceBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PriceBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseFare = null,
    Object? taxes = null,
    Object? fees = null,
    Object? surcharges = null,
    Object? discount = null,
  }) {
    return _then(_value.copyWith(
      baseFare: null == baseFare
          ? _value.baseFare
          : baseFare // ignore: cast_nullable_to_non_nullable
              as double,
      taxes: null == taxes
          ? _value.taxes
          : taxes // ignore: cast_nullable_to_non_nullable
              as double,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as double,
      surcharges: null == surcharges
          ? _value.surcharges
          : surcharges // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceBreakdownImplCopyWith<$Res>
    implements $PriceBreakdownCopyWith<$Res> {
  factory _$$PriceBreakdownImplCopyWith(_$PriceBreakdownImpl value,
          $Res Function(_$PriceBreakdownImpl) then) =
      __$$PriceBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double baseFare,
      double taxes,
      double fees,
      double surcharges,
      double discount});
}

/// @nodoc
class __$$PriceBreakdownImplCopyWithImpl<$Res>
    extends _$PriceBreakdownCopyWithImpl<$Res, _$PriceBreakdownImpl>
    implements _$$PriceBreakdownImplCopyWith<$Res> {
  __$$PriceBreakdownImplCopyWithImpl(
      _$PriceBreakdownImpl _value, $Res Function(_$PriceBreakdownImpl) _then)
      : super(_value, _then);

  /// Create a copy of PriceBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseFare = null,
    Object? taxes = null,
    Object? fees = null,
    Object? surcharges = null,
    Object? discount = null,
  }) {
    return _then(_$PriceBreakdownImpl(
      baseFare: null == baseFare
          ? _value.baseFare
          : baseFare // ignore: cast_nullable_to_non_nullable
              as double,
      taxes: null == taxes
          ? _value.taxes
          : taxes // ignore: cast_nullable_to_non_nullable
              as double,
      fees: null == fees
          ? _value.fees
          : fees // ignore: cast_nullable_to_non_nullable
              as double,
      surcharges: null == surcharges
          ? _value.surcharges
          : surcharges // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$PriceBreakdownImpl extends _PriceBreakdown {
  const _$PriceBreakdownImpl(
      {required this.baseFare,
      required this.taxes,
      required this.fees,
      this.surcharges = 0.0,
      this.discount = 0.0})
      : super._();

  @override
  final double baseFare;
  @override
  final double taxes;
  @override
  final double fees;
  @override
  @JsonKey()
  final double surcharges;
  @override
  @JsonKey()
  final double discount;

  @override
  String toString() {
    return 'PriceBreakdown(baseFare: $baseFare, taxes: $taxes, fees: $fees, surcharges: $surcharges, discount: $discount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceBreakdownImpl &&
            (identical(other.baseFare, baseFare) ||
                other.baseFare == baseFare) &&
            (identical(other.taxes, taxes) || other.taxes == taxes) &&
            (identical(other.fees, fees) || other.fees == fees) &&
            (identical(other.surcharges, surcharges) ||
                other.surcharges == surcharges) &&
            (identical(other.discount, discount) ||
                other.discount == discount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, baseFare, taxes, fees, surcharges, discount);

  /// Create a copy of PriceBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceBreakdownImplCopyWith<_$PriceBreakdownImpl> get copyWith =>
      __$$PriceBreakdownImplCopyWithImpl<_$PriceBreakdownImpl>(
          this, _$identity);
}

abstract class _PriceBreakdown extends PriceBreakdown {
  const factory _PriceBreakdown(
      {required final double baseFare,
      required final double taxes,
      required final double fees,
      final double surcharges,
      final double discount}) = _$PriceBreakdownImpl;
  const _PriceBreakdown._() : super._();

  @override
  double get baseFare;
  @override
  double get taxes;
  @override
  double get fees;
  @override
  double get surcharges;
  @override
  double get discount;

  /// Create a copy of PriceBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PriceBreakdownImplCopyWith<_$PriceBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
