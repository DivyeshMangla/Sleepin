import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/alarm_model.dart';
import '../../alarm/alarm_notifier.dart';
import '../../../core/utils/date_time_utils.dart';

class AlarmTile extends ConsumerWidget {
  final Alarm alarm;

  const AlarmTile({super.key, required this.alarm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Dismissible(
      key: Key(alarm.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(alarmNotifierProvider.notifier).deleteAlarm(alarm);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () => context.push('/alarm/${alarm.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateTimeUtils.formatTime(alarm.time),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: alarm.isEnabled 
                              ? theme.colorScheme.onSurface 
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${alarm.label} • ${DateTimeUtils.formatDays(alarm.daysOfWeek)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: alarm.isEnabled,
                  onChanged: (value) {
                    ref.read(alarmNotifierProvider.notifier).toggleAlarm(alarm);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
