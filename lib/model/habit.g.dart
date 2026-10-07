// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      days: (fields[0] as num).toInt(),
      habit: fields[1] as String,
      date: fields[2] as String,
      id: fields[3] as String,
      desc: fields[4] as String,
      complete: fields[5] as bool,
      target: (fields[6] as num).toInt(),
      lastCompletion: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.days)
      ..writeByte(1)
      ..write(obj.habit)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.desc)
      ..writeByte(5)
      ..write(obj.complete)
      ..writeByte(6)
      ..write(obj.target)
      ..writeByte(7)
      ..write(obj.lastCompletion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
