import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'sound_service.g.dart';

class SoundService {
  final AudioPlayer _player = AudioPlayer();

  Future<List<String>> getSounds() async {
    // In a real app, we'd parse AssetManifest.json
    // For now, we'll return a hardcoded list of expected files
    // assuming the user will add them or we provide defaults.
    // If we had the AssetManifest, we could do:
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      return manifestMap.keys
          .where((key) => key.startsWith('assets/sounds/'))
          .toList();
    } catch (e) {
      return ['assets/sounds/default.mp3'];
    }
  }

  Future<void> playPreview(String path) async {
    try {
      if (_player.playing) await _player.stop();
      await _player.setAsset(path);
      await _player.setVolume(1.0);
      await _player.play();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }
  
  Future<void> playAlarm(String path, {bool loop = true}) async {
    try {
      await _player.setAsset(path);
      await _player.setLoopMode(loop ? LoopMode.one : LoopMode.off);
      await _player.setVolume(0); // Start silent for ramp
      await _player.play();
      
      // Ramp up volume
      for (var i = 1; i <= 10; i++) {
        if (!_player.playing) break;
        await Future.delayed(const Duration(seconds: 1));
        await _player.setVolume(i / 10);
      }
    } catch (e) {
      debugPrint('Error playing alarm: $e');
    }
  }
  
  void dispose() {
    _player.dispose();
  }
}

@riverpod
SoundService soundService(SoundServiceRef ref) {
  final service = SoundService();
  ref.onDispose(service.dispose);
  return service;
}
