// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmAdapter extends TypeAdapter<Alarm> {
  @override
  final int typeId = 0;

  @override
  Alarm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alarm(
      id: fields[0] as String?,
      time: fields[1] as DateTime,
      label: fields[2] as String,
      isEnabled: fields[3] as bool,
      daysOfWeek: (fields[4] as List).cast<int>(),
      soundPath: fields[5] as String,
      vibration: fields[6] as bool,
      taskConfig: fields[7] as TaskConfig,
    );
  }

  @override
  void write(BinaryWriter writer, Alarm obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.isEnabled)
      ..writeByte(4)
      ..write(obj.daysOfWeek)
      ..writeByte(5)
      ..write(obj.soundPath)
      ..writeByte(6)
      ..write(obj.vibration)
      ..writeByte(7)
      ..write(obj.taskConfig);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
