import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/alarm_model.dart';
import '../../data/models/task_config.dart';
import 'alarm_notifier.dart';
import '../../core/utils/date_time_utils.dart';

class AlarmEditScreen extends ConsumerStatefulWidget {
  final String? alarmId;

  const AlarmEditScreen({super.key, this.alarmId});

  @override
  ConsumerState<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends ConsumerState<AlarmEditScreen> {
  late DateTime _time;
  late String _label;
  late List<int> _daysOfWeek;
  late bool _vibration;
  late String _soundPath;
  late TaskConfig _taskConfig;
  bool _isNew = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    if (widget.alarmId != null && widget.alarmId != 'new') {
      final alarms = ref.read(alarmNotifierProvider).valueOrNull ?? [];
      final alarm = alarms.firstWhere(
        (a) => a.id == widget.alarmId,
        orElse: () => Alarm(time: DateTime.now()),
      );
      _time = alarm.time;
      _label = alarm.label;
      _daysOfWeek = List.from(alarm.daysOfWeek);
      _vibration = alarm.vibration;
      _soundPath = alarm.soundPath;
      _taskConfig = alarm.taskConfig;
      _isNew = false;
    } else {
      final now = DateTime.now();
      _time = DateTime(now.year, now.month, now.day, now.hour, now.minute).add(const Duration(minutes: 1));
      _label = 'Alarm';
      _daysOfWeek = [];
      _vibration = true;
      _soundPath = 'assets/sounds/default.mp3';
      _taskConfig = const TaskConfig();
      _isNew = true;
    }
  }

  void _save() {
    final alarm = Alarm(
      id: _isNew ? const Uuid().v4() : widget.alarmId,
      time: _time,
      label: _label,
      daysOfWeek: _daysOfWeek,
      vibration: _vibration,
      soundPath: _soundPath,
      taskConfig: _taskConfig,
      isEnabled: true,
    );

    if (_isNew) {
      ref.read(alarmNotifierProvider.notifier).addAlarm(alarm);
    } else {
      ref.read(alarmNotifierProvider.notifier).updateAlarm(alarm);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New Alarm' : 'Edit Alarm'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: _time,
              onDateTimeChanged: (newTime) {
                setState(() => _time = newTime);
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildSection(
            theme,
            children: [
              ListTile(
                title: const Text('Label'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () async {
                  // Simple dialog for label
                  final controller = TextEditingController(text: _label);
                  final newLabel = await showDialog<String>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Label'),
                      content: TextField(controller: controller, autofocus: true),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(c, controller.text), child: const Text('OK')),
                      ],
                    ),
                  );
                  if (newLabel != null) setState(() => _label = newLabel);
                },
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                title: const Text('Repeat'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateTimeUtils.formatDays(_daysOfWeek), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () {
                  // TODO: Implement Repeat Dialog
                },
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                title: const Text('Sound'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_soundPath.split('/').last, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () async {
                  final result = await context.push<String>('/sound-picker', extra: _soundPath);
                  if (result != null) setState(() => _soundPath = result);
                },
              ),
              const Divider(height: 1, indent: 16),
              SwitchListTile(
                title: const Text('Vibration'),
                value: _vibration,
                onChanged: (v) => setState(() => _vibration = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            theme,
            title: 'Wake-Up Task',
            children: [
              ListTile(
                title: const Text('Task'),
                subtitle: Text(_taskConfig.type.name.toUpperCase()),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () async {
                  final result = await context.push<TaskConfig>('/task-picker', extra: _taskConfig);
                  if (result != null) setState(() => _taskConfig = result);
                },
              ),
            ],
          ),
          if (!_isNew) ...[
            const SizedBox(height: 40),
            Center(
              child: TextButton(
                onPressed: () {
                  // Delete logic
                  // ref.read(alarmNotifierProvider.notifier).deleteAlarm(...);
                  context.pop();
                },
                style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                child: const Text('Delete Alarm'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(ThemeData theme, {String? title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(title, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
