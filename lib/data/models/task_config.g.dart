// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskConfigAdapter extends TypeAdapter<TaskConfig> {
  @override
  final int typeId = 2;

  @override
  TaskConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskConfig(
      type: fields[0] as TaskType,
      difficulty: fields[1] as int,
      params: (fields[2] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.params);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskTypeAdapter extends TypeAdapter<TaskType> {
  @override
  final int typeId = 1;

  @override
  TaskType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskType.none;
      case 1:
        return TaskType.stepCounter;
      case 2:
        return TaskType.shake;
      case 3:
        return TaskType.math;
      case 4:
        return TaskType.memory;
      default:
        return TaskType.none;
    }
  }

  @override
  void write(BinaryWriter writer, TaskType obj) {
    switch (obj) {
      case TaskType.none:
        writer.writeByte(0);
        break;
      case TaskType.stepCounter:
        writer.writeByte(1);
        break;
      case TaskType.shake:
        writer.writeByte(2);
        break;
      case TaskType.math:
        writer.writeByte(3);
        break;
      case TaskType.memory:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
