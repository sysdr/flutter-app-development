// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itinerary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Itinerary {
  String get id => throw _privateConstructorUsedError;
  Flight get outbound => throw _privateConstructorUsedError;
  List<Passenger> get passengers => throw _privateConstructorUsedError;
  PriceBreakdown get pricing => throw _privateConstructorUsedError;
  Flight? get returnFlight => throw _privateConstructorUsedError;
  Hotel? get hotel => throw _privateConstructorUsedError;
  ItineraryStatus get status => throw _privateConstructorUsedError;
  DateTime? get confirmedAt => throw _privateConstructorUsedError;

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItineraryCopyWith<Itinerary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItineraryCopyWith<$Res> {
  factory $ItineraryCopyWith(Itinerary value, $Res Function(Itinerary) then) =
      _$ItineraryCopyWithImpl<$Res, Itinerary>;
  @useResult
  $Res call(
      {String id,
      Flight outbound,
      List<Passenger> passengers,
      PriceBreakdown pricing,
      Flight? returnFlight,
      Hotel? hotel,
      ItineraryStatus status,
      DateTime? confirmedAt});

  $FlightCopyWith<$Res> get outbound;
  $PriceBreakdownCopyWith<$Res> get pricing;
  $FlightCopyWith<$Res>? get returnFlight;
  $HotelCopyWith<$Res>? get hotel;
}

/// @nodoc
class _$ItineraryCopyWithImpl<$Res, $Val extends Itinerary>
    implements $ItineraryCopyWith<$Res> {
  _$ItineraryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? outbound = null,
    Object? passengers = null,
    Object? pricing = null,
    Object? returnFlight = freezed,
    Object? hotel = freezed,
    Object? status = null,
    Object? confirmedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      outbound: null == outbound
          ? _value.outbound
          : outbound // ignore: cast_nullable_to_non_nullable
              as Flight,
      passengers: null == passengers
          ? _value.passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<Passenger>,
      pricing: null == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as PriceBreakdown,
      returnFlight: freezed == returnFlight
          ? _value.returnFlight
          : returnFlight // ignore: cast_nullable_to_non_nullable
              as Flight?,
      hotel: freezed == hotel
          ? _value.hotel
          : hotel // ignore: cast_nullable_to_non_nullable
              as Hotel?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ItineraryStatus,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlightCopyWith<$Res> get outbound {
    return $FlightCopyWith<$Res>(_value.outbound, (value) {
      return _then(_value.copyWith(outbound: value) as $Val);
    });
  }

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriceBreakdownCopyWith<$Res> get pricing {
    return $PriceBreakdownCopyWith<$Res>(_value.pricing, (value) {
      return _then(_value.copyWith(pricing: value) as $Val);
    });
  }

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlightCopyWith<$Res>? get returnFlight {
    if (_value.returnFlight == null) {
      return null;
    }

    return $FlightCopyWith<$Res>(_value.returnFlight!, (value) {
      return _then(_value.copyWith(returnFlight: value) as $Val);
    });
  }

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HotelCopyWith<$Res>? get hotel {
    if (_value.hotel == null) {
      return null;
    }

    return $HotelCopyWith<$Res>(_value.hotel!, (value) {
      return _then(_value.copyWith(hotel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ItineraryImplCopyWith<$Res>
    implements $ItineraryCopyWith<$Res> {
  factory _$$ItineraryImplCopyWith(
          _$ItineraryImpl value, $Res Function(_$ItineraryImpl) then) =
      __$$ItineraryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Flight outbound,
      List<Passenger> passengers,
      PriceBreakdown pricing,
      Flight? returnFlight,
      Hotel? hotel,
      ItineraryStatus status,
      DateTime? confirmedAt});

  @override
  $FlightCopyWith<$Res> get outbound;
  @override
  $PriceBreakdownCopyWith<$Res> get pricing;
  @override
  $FlightCopyWith<$Res>? get returnFlight;
  @override
  $HotelCopyWith<$Res>? get hotel;
}

/// @nodoc
class __$$ItineraryImplCopyWithImpl<$Res>
    extends _$ItineraryCopyWithImpl<$Res, _$ItineraryImpl>
    implements _$$ItineraryImplCopyWith<$Res> {
  __$$ItineraryImplCopyWithImpl(
      _$ItineraryImpl _value, $Res Function(_$ItineraryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? outbound = null,
    Object? passengers = null,
    Object? pricing = null,
    Object? returnFlight = freezed,
    Object? hotel = freezed,
    Object? status = null,
    Object? confirmedAt = freezed,
  }) {
    return _then(_$ItineraryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      outbound: null == outbound
          ? _value.outbound
          : outbound // ignore: cast_nullable_to_non_nullable
              as Flight,
      passengers: null == passengers
          ? _value._passengers
          : passengers // ignore: cast_nullable_to_non_nullable
              as List<Passenger>,
      pricing: null == pricing
          ? _value.pricing
          : pricing // ignore: cast_nullable_to_non_nullable
              as PriceBreakdown,
      returnFlight: freezed == returnFlight
          ? _value.returnFlight
          : returnFlight // ignore: cast_nullable_to_non_nullable
              as Flight?,
      hotel: freezed == hotel
          ? _value.hotel
          : hotel // ignore: cast_nullable_to_non_nullable
              as Hotel?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ItineraryStatus,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$ItineraryImpl extends _Itinerary {
  const _$ItineraryImpl(
      {required this.id,
      required this.outbound,
      required final List<Passenger> passengers,
      required this.pricing,
      this.returnFlight,
      this.hotel,
      this.status = ItineraryStatus.draft,
      this.confirmedAt})
      : _passengers = passengers,
        super._();

  @override
  final String id;
  @override
  final Flight outbound;
  final List<Passenger> _passengers;
  @override
  List<Passenger> get passengers {
    if (_passengers is EqualUnmodifiableListView) return _passengers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passengers);
  }

  @override
  final PriceBreakdown pricing;
  @override
  final Flight? returnFlight;
  @override
  final Hotel? hotel;
  @override
  @JsonKey()
  final ItineraryStatus status;
  @override
  final DateTime? confirmedAt;

  @override
  String toString() {
    return 'Itinerary(id: $id, outbound: $outbound, passengers: $passengers, pricing: $pricing, returnFlight: $returnFlight, hotel: $hotel, status: $status, confirmedAt: $confirmedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItineraryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.outbound, outbound) ||
                other.outbound == outbound) &&
            const DeepCollectionEquality()
                .equals(other._passengers, _passengers) &&
            (identical(other.pricing, pricing) || other.pricing == pricing) &&
            (identical(other.returnFlight, returnFlight) ||
                other.returnFlight == returnFlight) &&
            (identical(other.hotel, hotel) || other.hotel == hotel) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      outbound,
      const DeepCollectionEquality().hash(_passengers),
      pricing,
      returnFlight,
      hotel,
      status,
      confirmedAt);

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItineraryImplCopyWith<_$ItineraryImpl> get copyWith =>
      __$$ItineraryImplCopyWithImpl<_$ItineraryImpl>(this, _$identity);
}

abstract class _Itinerary extends Itinerary {
  const factory _Itinerary(
      {required final String id,
      required final Flight outbound,
      required final List<Passenger> passengers,
      required final PriceBreakdown pricing,
      final Flight? returnFlight,
      final Hotel? hotel,
      final ItineraryStatus status,
      final DateTime? confirmedAt}) = _$ItineraryImpl;
  const _Itinerary._() : super._();

  @override
  String get id;
  @override
  Flight get outbound;
  @override
  List<Passenger> get passengers;
  @override
  PriceBreakdown get pricing;
  @override
  Flight? get returnFlight;
  @override
  Hotel? get hotel;
  @override
  ItineraryStatus get status;
  @override
  DateTime? get confirmedAt;

  /// Create a copy of Itinerary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItineraryImplCopyWith<_$ItineraryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
