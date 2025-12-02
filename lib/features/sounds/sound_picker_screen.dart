import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'sound_service.dart';

class SoundPickerScreen extends ConsumerStatefulWidget {
  final String selectedPath;

  const SoundPickerScreen({super.key, required this.selectedPath});

  @override
  ConsumerState<SoundPickerScreen> createState() => _SoundPickerScreenState();
}

class _SoundPickerScreenState extends ConsumerState<SoundPickerScreen> {
  String? _previewingPath;

  @override
  Widget build(BuildContext context) {
    final soundService = ref.watch(soundServiceProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Select Sound')),
      body: FutureBuilder<List<String>>(
        future: soundService.getSounds(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final sounds = snapshot.data!;
          
          return ListView.builder(
            itemCount: sounds.length,
            itemBuilder: (context, index) {
              final path = sounds[index];
              final name = path.split('/').last.split('.').first;
              final isSelected = path == widget.selectedPath;
              final isPreviewing = path == _previewingPath;

              return ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                leading: IconButton(
                  icon: Icon(isPreviewing ? Icons.stop_circle : Icons.play_circle),
                  onPressed: () {
                    if (isPreviewing) {
                      soundService.stop();
                      setState(() => _previewingPath = null);
                    } else {
                      soundService.playPreview(path);
                      setState(() => _previewingPath = path);
                    }
                  },
                ),
                onTap: () {
                  soundService.stop();
                  context.pop(path);
                },
              );
            },
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    // Stop preview when leaving screen
    // We can't access ref here easily in dispose, but the provider handles disposal
    super.dispose();
  }
}
