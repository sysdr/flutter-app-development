// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_search.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentSearchAdapter extends TypeAdapter<RecentSearch> {
  @override
  final int typeId = 0;

  @override
  RecentSearch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSearch(
      originIata: fields[0] as String,
      originName: fields[1] as String,
      destinationIata: fields[2] as String,
      destinationName: fields[3] as String,
      searchedAt: fields[4] as DateTime,
      cabinClassLabel: fields[5] as String,
      passengerCount: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecentSearch obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.originIata)
      ..writeByte(1)
      ..write(obj.originName)
      ..writeByte(2)
      ..write(obj.destinationIata)
      ..writeByte(3)
      ..write(obj.destinationName)
      ..writeByte(4)
      ..write(obj.searchedAt)
      ..writeByte(5)
      ..write(obj.cabinClassLabel)
      ..writeByte(6)
      ..write(obj.passengerCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
