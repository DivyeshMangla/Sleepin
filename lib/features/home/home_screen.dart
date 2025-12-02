import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../alarm/alarm_notifier.dart';
import 'widgets/alarm_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Sleepin'),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // TODO: Navigate to settings
                },
              ),
            ],
          ),
          alarmsAsync.when(
            data: (alarms) {
              if (alarms.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.alarm_off,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 16),
                        Text(
                          'No Alarms Set',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to wake up better',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        ).animate().fadeIn(delay: 500.ms),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final alarm = alarms[index];
                    return AlarmTile(alarm: alarm)
                        .animate()
                        .fadeIn(delay: (100 * index).ms)
                        .slideX(begin: 0.2, end: 0);
                  },
                  childCount: alarms.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
          // Add padding at bottom for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => context.push('/alarm/new'),
        child: const Icon(Icons.add),
      ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
    );
  }
}
