import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/task_config.dart';

class TaskPickerScreen extends StatefulWidget {
  final TaskConfig selectedConfig;

  const TaskPickerScreen({super.key, required this.selectedConfig});

  @override
  State<TaskPickerScreen> createState() => _TaskPickerScreenState();
}

class _TaskPickerScreenState extends State<TaskPickerScreen> {
  late TaskType _selectedType;
  late int _difficulty;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedConfig.type;
    _difficulty = widget.selectedConfig.difficulty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Wake-Up Task'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(TaskConfig(type: _selectedType, difficulty: _difficulty));
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildTaskOption(TaskType.none, 'None', Icons.alarm_off),
          _buildTaskOption(TaskType.math, 'Math Puzzle', Icons.calculate),
          _buildTaskOption(TaskType.shake, 'Shake Phone', Icons.vibration),
          _buildTaskOption(TaskType.stepCounter, 'Step Counter', Icons.directions_walk),
          _buildTaskOption(TaskType.memory, 'Memory Pattern', Icons.grid_view),
          
          if (_selectedType != TaskType.none) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Difficulty', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Slider(
              value: _difficulty.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: 'Level $_difficulty',
              onChanged: (val) => setState(() => _difficulty = val.toInt()),
            ),
            Center(child: Text('Level $_difficulty')),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskOption(TaskType type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).primaryColor : null),
      title: Text(label),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () => setState(() => _selectedType = type),
    );
  }
}
