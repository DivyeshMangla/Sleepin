import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'task_config.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 0)
class Alarm extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime time;

  @HiveField(2)
  final String label;

  @HiveField(3)
  final bool isEnabled;

  @HiveField(4)
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday

  @HiveField(5)
  final String soundPath;

  @HiveField(6)
  final bool vibration;

  @HiveField(7)
  final TaskConfig taskConfig;

  Alarm({
    String? id,
    required this.time,
    this.label = 'Alarm',
    this.isEnabled = true,
    this.daysOfWeek = const [],
    this.soundPath = 'assets/sounds/default.mp3',
    this.vibration = true,
    this.taskConfig = const TaskConfig(),
  }) : id = id ?? const Uuid().v4();

  Alarm copyWith({
    DateTime? time,
    String? label,
    bool? isEnabled,
    List<int>? daysOfWeek,
    String? soundPath,
    bool? vibration,
    TaskConfig? taskConfig,
  }) {
    return Alarm(
      id: id,
      time: time ?? this.time,
      label: label ?? this.label,
      isEnabled: isEnabled ?? this.isEnabled,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      soundPath: soundPath ?? this.soundPath,
      vibration: vibration ?? this.vibration,
      taskConfig: taskConfig ?? this.taskConfig,
    );
  }
}
