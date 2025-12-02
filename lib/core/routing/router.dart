import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Placeholder imports - will be replaced as we create features
import '../../features/home/home_screen.dart';
import '../../features/alarm/alarm_edit_screen.dart';
import '../../features/sounds/sound_picker_screen.dart';
import '../../features/tasks/task_picker_screen.dart';
import '../../features/ring/ring_screen.dart';
import '../../data/models/task_config.dart';
import '../../data/models/alarm_model.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/alarm/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AlarmEditScreen(alarmId: id);
        },
      ),
      GoRoute(
        path: '/sound-picker',
        builder: (context, state) {
          final current = state.extra as String? ?? '';
          return SoundPickerScreen(selectedPath: current);
        },
      ),
      GoRoute(
        path: '/task-picker',
        builder: (context, state) {
          final current = state.extra as TaskConfig? ?? const TaskConfig();
          return TaskPickerScreen(selectedConfig: current);
        },
      ),
      GoRoute(
        path: '/ring',
        builder: (context, state) {
          final alarm = state.extra as Alarm;
          return RingScreen(alarm: alarm);
        },
      ),
    ],
  );
}
