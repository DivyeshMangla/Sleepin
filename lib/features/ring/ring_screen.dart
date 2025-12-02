import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../data/models/alarm_model.dart';
import '../../data/models/task_config.dart';
import '../sounds/sound_service.dart';
import '../tasks/ui/math_task_screen.dart';

class RingScreen extends ConsumerStatefulWidget {
  final Alarm alarm;

  const RingScreen({super.key, required this.alarm});

  @override
  ConsumerState<RingScreen> createState() => _RingScreenState();
}

class _RingScreenState extends ConsumerState<RingScreen> {
  bool _taskStarted = false;

  @override
  void initState() {
    super.initState();
    // Start playing sound
    ref.read(soundServiceProvider).playAlarm(widget.alarm.soundPath);
  }

  @override
  void dispose() {
    // Stop sound is handled by dismiss logic, but safety check here
    // We don't stop here because if we navigate to Task, we might want sound to continue?
    // Usually sound stops when task starts or continues until task done.
    // Let's keep sound playing during task for annoyance factor :)
    super.dispose();
  }

  void _onDismiss() {
    if (widget.alarm.taskConfig.type != TaskType.none) {
      setState(() => _taskStarted = true);
    } else {
      _stopAndExit();
    }
  }

  void _stopAndExit() {
    ref.read(soundServiceProvider).stop();
    context.go('/'); // Go home
  }

  @override
  Widget build(BuildContext context) {
    if (_taskStarted) {
      // Show Task UI
      // For now only Math is implemented
      if (widget.alarm.taskConfig.type == TaskType.math) {
        return MathTaskScreen(
          config: widget.alarm.taskConfig,
          onCompleted: _stopAndExit,
        );
      }
      // Fallback for others
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _stopAndExit,
            child: const Text('Task Placeholder - Tap to Dismiss'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Icon(Icons.alarm, size: 80, color: Colors.white)
              .animate(onPlay: (c) => c.repeat())
              .shake(duration: 1.seconds),
          const SizedBox(height: 32),
          Text(
            '${widget.alarm.time.hour.toString().padLeft(2, '0')}:${widget.alarm.time.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            widget.alarm.label,
            style: const TextStyle(fontSize: 24, color: Colors.white70),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Dismissible(
              key: const Key('dismiss'),
              direction: DismissDirection.horizontal,
              confirmDismiss: (_) async {
                _onDismiss();
                return false; // Don't actually dismiss the widget from tree
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chevron_right, color: Colors.white),
                    Text(' Slide to Stop ', style: TextStyle(color: Colors.white, fontSize: 20)),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
