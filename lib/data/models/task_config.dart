import 'package:hive/hive.dart';

part 'task_config.g.dart';

@HiveType(typeId: 1)
enum TaskType {
  @HiveField(0)
  none,
  @HiveField(1)
  stepCounter,
  @HiveField(2)
  shake,
  @HiveField(3)
  math,
  @HiveField(4)
  memory,
}

@HiveType(typeId: 2)
class TaskConfig {
  @HiveField(0)
  final TaskType type;

  @HiveField(1)
  final int difficulty; // 1-5

  @HiveField(2)
  final Map<String, dynamic> params; // Extra params like 'targetSteps'

  const TaskConfig({
    this.type = TaskType.none,
    this.difficulty = 1,
    this.params = const {},
  });

  factory TaskConfig.none() => const TaskConfig(type: TaskType.none);
}
