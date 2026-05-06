// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Flight {
  String get id => throw _privateConstructorUsedError;
  String get airline => throw _privateConstructorUsedError;
  String get airlineCode => throw _privateConstructorUsedError;
  String get flightNumber => throw _privateConstructorUsedError;
  String get originIata => throw _privateConstructorUsedError;
  String get destinationIata => throw _privateConstructorUsedError;
  String get originCity => throw _privateConstructorUsedError;
  String get destinationCity => throw _privateConstructorUsedError;
  DateTime get departureAt => throw _privateConstructorUsedError;
  DateTime get arrivalAt => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  TravelClass get travelClass => throw _privateConstructorUsedError;
  int get stops => throw _privateConstructorUsedError;
  String get baggageAllowance => throw _privateConstructorUsedError;
  bool get isRefundable => throw _privateConstructorUsedError;
  double get priceInr => throw _privateConstructorUsedError;
  int get seatsAvailable => throw _privateConstructorUsedError;
  bool get isFavourite => throw _privateConstructorUsedError;

  /// Create a copy of Flight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightCopyWith<Flight> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightCopyWith<$Res> {
  factory $FlightCopyWith(Flight value, $Res Function(Flight) then) =
      _$FlightCopyWithImpl<$Res, Flight>;
  @useResult
  $Res call(
      {String id,
      String airline,
      String airlineCode,
      String flightNumber,
      String originIata,
      String destinationIata,
      String originCity,
      String destinationCity,
      DateTime departureAt,
      DateTime arrivalAt,
      int durationMinutes,
      TravelClass travelClass,
      int stops,
      String baggageAllowance,
      bool isRefundable,
      double priceInr,
      int seatsAvailable,
      bool isFavourite});
}

/// @nodoc
class _$FlightCopyWithImpl<$Res, $Val extends Flight>
    implements $FlightCopyWith<$Res> {
  _$FlightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Flight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? airline = null,
    Object? airlineCode = null,
    Object? flightNumber = null,
    Object? originIata = null,
    Object? destinationIata = null,
    Object? originCity = null,
    Object? destinationCity = null,
    Object? departureAt = null,
    Object? arrivalAt = null,
    Object? durationMinutes = null,
    Object? travelClass = null,
    Object? stops = null,
    Object? baggageAllowance = null,
    Object? isRefundable = null,
    Object? priceInr = null,
    Object? seatsAvailable = null,
    Object? isFavourite = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      airline: null == airline
          ? _value.airline
          : airline // ignore: cast_nullable_to_non_nullable
              as String,
      airlineCode: null == airlineCode
          ? _value.airlineCode
          : airlineCode // ignore: cast_nullable_to_non_nullable
              as String,
      flightNumber: null == flightNumber
          ? _value.flightNumber
          : flightNumber // ignore: cast_nullable_to_non_nullable
              as String,
      originIata: null == originIata
          ? _value.originIata
          : originIata // ignore: cast_nullable_to_non_nullable
              as String,
      destinationIata: null == destinationIata
          ? _value.destinationIata
          : destinationIata // ignore: cast_nullable_to_non_nullable
              as String,
      originCity: null == originCity
          ? _value.originCity
          : originCity // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCity: null == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String,
      departureAt: null == departureAt
          ? _value.departureAt
          : departureAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      arrivalAt: null == arrivalAt
          ? _value.arrivalAt
          : arrivalAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      travelClass: null == travelClass
          ? _value.travelClass
          : travelClass // ignore: cast_nullable_to_non_nullable
              as TravelClass,
      stops: null == stops
          ? _value.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as int,
      baggageAllowance: null == baggageAllowance
          ? _value.baggageAllowance
          : baggageAllowance // ignore: cast_nullable_to_non_nullable
              as String,
      isRefundable: null == isRefundable
          ? _value.isRefundable
          : isRefundable // ignore: cast_nullable_to_non_nullable
              as bool,
      priceInr: null == priceInr
          ? _value.priceInr
          : priceInr // ignore: cast_nullable_to_non_nullable
              as double,
      seatsAvailable: null == seatsAvailable
          ? _value.seatsAvailable
          : seatsAvailable // ignore: cast_nullable_to_non_nullable
              as int,
      isFavourite: null == isFavourite
          ? _value.isFavourite
          : isFavourite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlightImplCopyWith<$Res> implements $FlightCopyWith<$Res> {
  factory _$$FlightImplCopyWith(
          _$FlightImpl value, $Res Function(_$FlightImpl) then) =
      __$$FlightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String airline,
      String airlineCode,
      String flightNumber,
      String originIata,
      String destinationIata,
      String originCity,
      String destinationCity,
      DateTime departureAt,
      DateTime arrivalAt,
      int durationMinutes,
      TravelClass travelClass,
      int stops,
      String baggageAllowance,
      bool isRefundable,
      double priceInr,
      int seatsAvailable,
      bool isFavourite});
}

/// @nodoc
class __$$FlightImplCopyWithImpl<$Res>
    extends _$FlightCopyWithImpl<$Res, _$FlightImpl>
    implements _$$FlightImplCopyWith<$Res> {
  __$$FlightImplCopyWithImpl(
      _$FlightImpl _value, $Res Function(_$FlightImpl) _then)
      : super(_value, _then);

  /// Create a copy of Flight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? airline = null,
    Object? airlineCode = null,
    Object? flightNumber = null,
    Object? originIata = null,
    Object? destinationIata = null,
    Object? originCity = null,
    Object? destinationCity = null,
    Object? departureAt = null,
    Object? arrivalAt = null,
    Object? durationMinutes = null,
    Object? travelClass = null,
    Object? stops = null,
    Object? baggageAllowance = null,
    Object? isRefundable = null,
    Object? priceInr = null,
    Object? seatsAvailable = null,
    Object? isFavourite = null,
  }) {
    return _then(_$FlightImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      airline: null == airline
          ? _value.airline
          : airline // ignore: cast_nullable_to_non_nullable
              as String,
      airlineCode: null == airlineCode
          ? _value.airlineCode
          : airlineCode // ignore: cast_nullable_to_non_nullable
              as String,
      flightNumber: null == flightNumber
          ? _value.flightNumber
          : flightNumber // ignore: cast_nullable_to_non_nullable
              as String,
      originIata: null == originIata
          ? _value.originIata
          : originIata // ignore: cast_nullable_to_non_nullable
              as String,
      destinationIata: null == destinationIata
          ? _value.destinationIata
          : destinationIata // ignore: cast_nullable_to_non_nullable
              as String,
      originCity: null == originCity
          ? _value.originCity
          : originCity // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCity: null == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String,
      departureAt: null == departureAt
          ? _value.departureAt
          : departureAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      arrivalAt: null == arrivalAt
          ? _value.arrivalAt
          : arrivalAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      travelClass: null == travelClass
          ? _value.travelClass
          : travelClass // ignore: cast_nullable_to_non_nullable
              as TravelClass,
      stops: null == stops
          ? _value.stops
          : stops // ignore: cast_nullable_to_non_nullable
              as int,
      baggageAllowance: null == baggageAllowance
          ? _value.baggageAllowance
          : baggageAllowance // ignore: cast_nullable_to_non_nullable
              as String,
      isRefundable: null == isRefundable
          ? _value.isRefundable
          : isRefundable // ignore: cast_nullable_to_non_nullable
              as bool,
      priceInr: null == priceInr
          ? _value.priceInr
          : priceInr // ignore: cast_nullable_to_non_nullable
              as double,
      seatsAvailable: null == seatsAvailable
          ? _value.seatsAvailable
          : seatsAvailable // ignore: cast_nullable_to_non_nullable
              as int,
      isFavourite: null == isFavourite
          ? _value.isFavourite
          : isFavourite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FlightImpl extends _Flight {
  const _$FlightImpl(
      {required this.id,
      required this.airline,
      required this.airlineCode,
      required this.flightNumber,
      required this.originIata,
      required this.destinationIata,
      required this.originCity,
      required this.destinationCity,
      required this.departureAt,
      required this.arrivalAt,
      required this.durationMinutes,
      required this.travelClass,
      required this.stops,
      required this.baggageAllowance,
      required this.isRefundable,
      required this.priceInr,
      required this.seatsAvailable,
      this.isFavourite = false})
      : super._();

  @override
  final String id;
  @override
  final String airline;
  @override
  final String airlineCode;
  @override
  final String flightNumber;
  @override
  final String originIata;
  @override
  final String destinationIata;
  @override
  final String originCity;
  @override
  final String destinationCity;
  @override
  final DateTime departureAt;
  @override
  final DateTime arrivalAt;
  @override
  final int durationMinutes;
  @override
  final TravelClass travelClass;
  @override
  final int stops;
  @override
  final String baggageAllowance;
  @override
  final bool isRefundable;
  @override
  final double priceInr;
  @override
  final int seatsAvailable;
  @override
  @JsonKey()
  final bool isFavourite;

  @override
  String toString() {
    return 'Flight(id: $id, airline: $airline, airlineCode: $airlineCode, flightNumber: $flightNumber, originIata: $originIata, destinationIata: $destinationIata, originCity: $originCity, destinationCity: $destinationCity, departureAt: $departureAt, arrivalAt: $arrivalAt, durationMinutes: $durationMinutes, travelClass: $travelClass, stops: $stops, baggageAllowance: $baggageAllowance, isRefundable: $isRefundable, priceInr: $priceInr, seatsAvailable: $seatsAvailable, isFavourite: $isFavourite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.airline, airline) || other.airline == airline) &&
            (identical(other.airlineCode, airlineCode) ||
                other.airlineCode == airlineCode) &&
            (identical(other.flightNumber, flightNumber) ||
                other.flightNumber == flightNumber) &&
            (identical(other.originIata, originIata) ||
                other.originIata == originIata) &&
            (identical(other.destinationIata, destinationIata) ||
                other.destinationIata == destinationIata) &&
            (identical(other.originCity, originCity) ||
                other.originCity == originCity) &&
            (identical(other.destinationCity, destinationCity) ||
                other.destinationCity == destinationCity) &&
            (identical(other.departureAt, departureAt) ||
                other.departureAt == departureAt) &&
            (identical(other.arrivalAt, arrivalAt) ||
                other.arrivalAt == arrivalAt) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.travelClass, travelClass) ||
                other.travelClass == travelClass) &&
            (identical(other.stops, stops) || other.stops == stops) &&
            (identical(other.baggageAllowance, baggageAllowance) ||
                other.baggageAllowance == baggageAllowance) &&
            (identical(other.isRefundable, isRefundable) ||
                other.isRefundable == isRefundable) &&
            (identical(other.priceInr, priceInr) ||
                other.priceInr == priceInr) &&
            (identical(other.seatsAvailable, seatsAvailable) ||
                other.seatsAvailable == seatsAvailable) &&
            (identical(other.isFavourite, isFavourite) ||
                other.isFavourite == isFavourite));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      airline,
      airlineCode,
      flightNumber,
      originIata,
      destinationIata,
      originCity,
      destinationCity,
      departureAt,
      arrivalAt,
      durationMinutes,
      travelClass,
      stops,
      baggageAllowance,
      isRefundable,
      priceInr,
      seatsAvailable,
      isFavourite);

  /// Create a copy of Flight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightImplCopyWith<_$FlightImpl> get copyWith =>
      __$$FlightImplCopyWithImpl<_$FlightImpl>(this, _$identity);
}

abstract class _Flight extends Flight {
  const factory _Flight(
      {required final String id,
      required final String airline,
      required final String airlineCode,
      required final String flightNumber,
      required final String originIata,
      required final String destinationIata,
      required final String originCity,
      required final String destinationCity,
      required final DateTime departureAt,
      required final DateTime arrivalAt,
      required final int durationMinutes,
      required final TravelClass travelClass,
      required final int stops,
      required final String baggageAllowance,
      required final bool isRefundable,
      required final double priceInr,
      required final int seatsAvailable,
      final bool isFavourite}) = _$FlightImpl;
  const _Flight._() : super._();

  @override
  String get id;
  @override
  String get airline;
  @override
  String get airlineCode;
  @override
  String get flightNumber;
  @override
  String get originIata;
  @override
  String get destinationIata;
  @override
  String get originCity;
  @override
  String get destinationCity;
  @override
  DateTime get departureAt;
  @override
  DateTime get arrivalAt;
  @override
  int get durationMinutes;
  @override
  TravelClass get travelClass;
  @override
  int get stops;
  @override
  String get baggageAllowance;
  @override
  bool get isRefundable;
  @override
  double get priceInr;
  @override
  int get seatsAvailable;
  @override
  bool get isFavourite;

  /// Create a copy of Flight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightImplCopyWith<_$FlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
