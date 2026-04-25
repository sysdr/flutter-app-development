import 'package:flutter/material.dart';

/// Cabin class enum for flight search.
enum CabinClass { economy, premiumEconomy, business, firstClass }

/// Passenger count value object.
final class PassengerCount {
  const PassengerCount({this.adults=1,this.children=0,this.infants=0});
  final int adults,children,infants;
  int get total => adults + children + infants;
  PassengerCount copyWith({int? adults,int? children,int? infants})=>
      PassengerCount(
        adults:  adults   ?? this.adults,
        children:children ?? this.children,
        infants: infants  ?? this.infants);
}

/// Search form state value object.
///
/// Currently plain Dart. Migrates to Riverpod StateNotifier in Lesson 16,
/// then to Riverpod @riverpod annotation in Lesson 32.
final class SearchCriteria {
  const SearchCriteria({
    this.origin      = '',
    this.destination = '',
    this.departureDate,
    this.returnDate,
    this.passengers  = const PassengerCount(),
    this.cabinClass  = CabinClass.economy,
  });

  final String        origin;
  final String        destination;
  final DateTime?     departureDate;
  final DateTime?     returnDate;
  final PassengerCount passengers;
  final CabinClass    cabinClass;

  bool get isValid =>
      origin.trim().isNotEmpty &&
      destination.trim().isNotEmpty &&
      departureDate != null;

  SearchCriteria copyWith({
    String? origin, String? destination,
    DateTime? departureDate, DateTime? returnDate,
    PassengerCount? passengers, CabinClass? cabinClass,
  }) => SearchCriteria(
    origin:        origin        ?? this.origin,
    destination:   destination   ?? this.destination,
    departureDate: departureDate ?? this.departureDate,
    returnDate:    returnDate    ?? this.returnDate,
    passengers:    passengers    ?? this.passengers,
    cabinClass:    cabinClass    ?? this.cabinClass,
  );
}
