import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/alarm_model.dart';

part 'alarm_repository.g.dart';

class AlarmRepository {
  static const String boxName = 'alarms';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Alarm>(boxName);
    }
  }

  Box<Alarm> get _box => Hive.box<Alarm>(boxName);

  List<Alarm> getAlarms() {
    return _box.values.toList();
  }

  Stream<List<Alarm>> watchAlarms() {
    return _box.watch().map((event) => _box.values.toList());
  }

  Future<void> saveAlarm(Alarm alarm) async {
    await _box.put(alarm.id, alarm);
  }

  Future<void> deleteAlarm(String id) async {
    await _box.delete(id);
  }
  
  Future<void> clearAll() async {
    await _box.clear();
  }
}

@riverpod
AlarmRepository alarmRepository(AlarmRepositoryRef ref) {
  return AlarmRepository();
}
