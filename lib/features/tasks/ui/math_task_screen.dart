import 'dart:math';
import 'package:flutter/material.dart';

import '../../../data/models/task_config.dart';

class MathTaskScreen extends StatefulWidget {
  final TaskConfig config;
  final VoidCallback onCompleted;

  const MathTaskScreen({super.key, required this.config, required this.onCompleted});

  @override
  State<MathTaskScreen> createState() => _MathTaskScreenState();
}

class _MathTaskScreenState extends State<MathTaskScreen> {
  late int _num1;
  late int _num2;
  late String _operator;
  late int _answer;
  final TextEditingController _controller = TextEditingController();
  int _problemsSolved = 0;
  late int _targetProblems;

  @override
  void initState() {
    super.initState();
    _targetProblems = widget.config.difficulty; // 1 problem per difficulty level
    _generateProblem();
  }

  void _generateProblem() {
    final r = Random();
    final diff = widget.config.difficulty;
    final maxVal = (10 * diff).toInt();
    
    _num1 = r.nextInt(maxVal) + 1;
    _num2 = r.nextInt(maxVal) + 1;
    
    if (r.nextBool()) {
      _operator = '+';
      _answer = _num1 + _num2;
    } else {
      _operator = '-';
      if (_num1 < _num2) {
        final temp = _num1;
        _num1 = _num2;
        _num2 = temp;
      }
      _answer = _num1 - _num2;
    }
    _controller.clear();
    setState(() {});
  }

  void _checkAnswer() {
    final input = int.tryParse(_controller.text);
    if (input == _answer) {
      _problemsSolved++;
      if (_problemsSolved >= _targetProblems) {
        widget.onCompleted();
      } else {
        _generateProblem();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect, try again!'), backgroundColor: Colors.red),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Solve to Dismiss',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '$_problemsSolved / $_targetProblems solved',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              Text(
                '$_num1 $_operator $_num2 = ?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '?',
                ),
                onSubmitted: (_) => _checkAnswer(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
