import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/alarm_model.dart';
import '../../data/repositories/alarm_repository.dart';
import '../../core/services/notification_service.dart';

part 'alarm_notifier.g.dart';

@riverpod
class AlarmNotifier extends _$AlarmNotifier {
  @override
  Stream<List<Alarm>> build() {
    return ref.watch(alarmRepositoryProvider).watchAlarms();
  }

  Future<void> addAlarm(Alarm alarm) async {
    await ref.read(alarmRepositoryProvider).saveAlarm(alarm);
    await ref.read(notificationServiceProvider).scheduleAlarm(alarm);
  }

  Future<void> updateAlarm(Alarm alarm) async {
    await ref.read(alarmRepositoryProvider).saveAlarm(alarm);
    await ref.read(notificationServiceProvider).scheduleAlarm(alarm);
  }

  Future<void> deleteAlarm(Alarm alarm) async {
    await ref.read(alarmRepositoryProvider).deleteAlarm(alarm.id);
    await ref.read(notificationServiceProvider).cancelAlarm(alarm.id);
  }

  Future<void> toggleAlarm(Alarm alarm) async {
    final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);
    await updateAlarm(updatedAlarm);
  }
}
