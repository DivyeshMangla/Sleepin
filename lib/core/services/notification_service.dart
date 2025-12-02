import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/alarm_model.dart';

part 'notification_service.g.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap - usually navigate to ring screen
        // This will be handled by a global listener or router redirect
      },
    );
  }

  Future<void> scheduleAlarm(Alarm alarm) async {
    // Cancel existing if updating
    await cancelAlarm(alarm.id);

    if (!alarm.isEnabled) return;

    // Calculate next trigger time
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If repeating, we might need multiple schedules or use matchDateTimeComponents
    // For simplicity in this MVP, we'll schedule the next occurrence.
    // A more robust app would schedule all repeating days.
    
    // Using a simple ID hash for notification ID (collision risk low for personal app)
    final notificationId = alarm.id.hashCode;

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      alarm.label,
      'Tap to stop alarm',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'alarm_channel',
          'Alarms',
          channelDescription: 'Channel for Alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true, // Critical for alarms
          sound: RawResourceAndroidNotificationSound('alarm_sound'), // TODO: Dynamic sound
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          sound: 'alarm_sound.aiff', // TODO: Dynamic sound
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeats daily at this time
    );
  }

  Future<void> cancelAlarm(String id) async {
    await _notificationsPlugin.cancel(id.hashCode);
  }
}

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}
