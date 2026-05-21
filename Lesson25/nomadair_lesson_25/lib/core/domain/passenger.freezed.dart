// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passenger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Passenger {
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  DateTime get dateOfBirth => throw _privateConstructorUsedError;
  PassengerType get type => throw _privateConstructorUsedError;
  String? get passportNumber => throw _privateConstructorUsedError;
  DateTime? get passportExpiry => throw _privateConstructorUsedError;
  String? get frequentFlyerNumber => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PassengerCopyWith<Passenger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerCopyWith<$Res> {
  factory $PassengerCopyWith(Passenger value, $Res Function(Passenger) then) =
      _$PassengerCopyWithImpl<$Res, Passenger>;
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      DateTime dateOfBirth,
      PassengerType type,
      String? passportNumber,
      DateTime? passportExpiry,
      String? frequentFlyerNumber});
}

/// @nodoc
class _$PassengerCopyWithImpl<$Res, $Val extends Passenger>
    implements $PassengerCopyWith<$Res> {
  _$PassengerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? dateOfBirth = null,
    Object? type = null,
    Object? passportNumber = freezed,
    Object? passportExpiry = freezed,
    Object? frequentFlyerNumber = freezed,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PassengerType,
      passportNumber: freezed == passportNumber
          ? _value.passportNumber
          : passportNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      passportExpiry: freezed == passportExpiry
          ? _value.passportExpiry
          : passportExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      frequentFlyerNumber: freezed == frequentFlyerNumber
          ? _value.frequentFlyerNumber
          : frequentFlyerNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PassengerImplCopyWith<$Res>
    implements $PassengerCopyWith<$Res> {
  factory _$$PassengerImplCopyWith(
          _$PassengerImpl value, $Res Function(_$PassengerImpl) then) =
      __$$PassengerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String firstName,
      String lastName,
      DateTime dateOfBirth,
      PassengerType type,
      String? passportNumber,
      DateTime? passportExpiry,
      String? frequentFlyerNumber});
}

/// @nodoc
class __$$PassengerImplCopyWithImpl<$Res>
    extends _$PassengerCopyWithImpl<$Res, _$PassengerImpl>
    implements _$$PassengerImplCopyWith<$Res> {
  __$$PassengerImplCopyWithImpl(
      _$PassengerImpl _value, $Res Function(_$PassengerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? dateOfBirth = null,
    Object? type = null,
    Object? passportNumber = freezed,
    Object? passportExpiry = freezed,
    Object? frequentFlyerNumber = freezed,
  }) {
    return _then(_$PassengerImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PassengerType,
      passportNumber: freezed == passportNumber
          ? _value.passportNumber
          : passportNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      passportExpiry: freezed == passportExpiry
          ? _value.passportExpiry
          : passportExpiry // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      frequentFlyerNumber: freezed == frequentFlyerNumber
          ? _value.frequentFlyerNumber
          : frequentFlyerNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PassengerImpl extends _Passenger {
  const _$PassengerImpl(
      {required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.type,
      this.passportNumber,
      this.passportExpiry,
      this.frequentFlyerNumber})
      : super._();

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final DateTime dateOfBirth;
  @override
  final PassengerType type;
  @override
  final String? passportNumber;
  @override
  final DateTime? passportExpiry;
  @override
  final String? frequentFlyerNumber;

  @override
  String toString() {
    return 'Passenger(firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, type: $type, passportNumber: $passportNumber, passportExpiry: $passportExpiry, frequentFlyerNumber: $frequentFlyerNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PassengerImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.passportNumber, passportNumber) ||
                other.passportNumber == passportNumber) &&
            (identical(other.passportExpiry, passportExpiry) ||
                other.passportExpiry == passportExpiry) &&
            (identical(other.frequentFlyerNumber, frequentFlyerNumber) ||
                other.frequentFlyerNumber == frequentFlyerNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, dateOfBirth,
      type, passportNumber, passportExpiry, frequentFlyerNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PassengerImplCopyWith<_$PassengerImpl> get copyWith =>
      __$$PassengerImplCopyWithImpl<_$PassengerImpl>(this, _$identity);
}

abstract class _Passenger extends Passenger {
  const factory _Passenger(
      {required final String firstName,
      required final String lastName,
      required final DateTime dateOfBirth,
      required final PassengerType type,
      final String? passportNumber,
      final DateTime? passportExpiry,
      final String? frequentFlyerNumber}) = _$PassengerImpl;
  const _Passenger._() : super._();

  @override
  String get firstName;
  @override
  String get lastName;
  @override
  DateTime get dateOfBirth;
  @override
  PassengerType get type;
  @override
  String? get passportNumber;
  @override
  DateTime? get passportExpiry;
  @override
  String? get frequentFlyerNumber;
  @override
  @JsonKey(ignore: true)
  _$$PassengerImplCopyWith<_$PassengerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
