// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daylight_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DaylightModelAdapter extends TypeAdapter<DaylightModel> {
  @override
  final int typeId = 1;

  @override
  DaylightModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DaylightModel(
      location: fields[0] as String,
      sunrise: fields[1] as DateTime,
      sunset: fields[2] as DateTime,
      dayLength: fields[3] as Duration,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DaylightModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.sunrise)
      ..writeByte(2)
      ..write(obj.sunset)
      ..writeByte(3)
      ..write(obj.dayLength)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DaylightModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
