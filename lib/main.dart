import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/alarm_model.dart';
import 'data/models/task_config.dart';
import 'data/repositories/alarm_repository.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AlarmAdapter());
  Hive.registerAdapter(TaskConfigAdapter());
  Hive.registerAdapter(TaskTypeAdapter());

  // Initialize Repository
  final alarmRepo = AlarmRepository();
  await alarmRepo.init();

  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    const ProviderScope(
      child: SleepinApp(),
    ),
  );
}
