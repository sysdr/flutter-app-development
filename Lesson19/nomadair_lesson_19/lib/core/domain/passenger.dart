import 'package:freezed_annotation/freezed_annotation.dart';

part 'passenger.freezed.dart';

enum PassengerType {
  adult(label: 'Adult'),
  child(label: 'Child'),
  infant(label: 'Infant');

  const PassengerType({required this.label});
  final String label;
}

/// Lesson 19 — Passenger details for a booking.
///
/// No JSON serialization in L19 — passengers come from a form, not an API.
/// JSON persistence is added in Lesson 20 (Hive).
@freezed
class Passenger with _$Passenger {
  const Passenger._();

  const factory Passenger({
    required String       firstName,
    required String       lastName,
    required DateTime     dateOfBirth,
    required PassengerType type,
    String?  passportNumber,
    DateTime? passportExpiry,
    String?  frequentFlyerNumber,
  }) = _Passenger;

  String get fullName => '$firstName $lastName';

  bool get isMinor =>
      type == PassengerType.child || type == PassengerType.infant;
}
