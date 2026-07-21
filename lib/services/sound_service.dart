import 'package:audioplayers/audioplayers.dart';
import 'package:pomodoro_sczuw/enums/sound_event.dart';
import 'package:pomodoro_sczuw/models/pomodoro_settings.dart';
import 'package:pomodoro_sczuw/utils/consts/sound_preset.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Future<void> playForEvent(SoundEvent event, PomodoroSettings settings) async {
    await playSound(settings.soundKeyForEvent(event));
  }

  Future<void> playSound(String soundKey) async {
    if (!_isEnabled || soundKey.isEmpty) return;

    final Source? source = _resolveSource(soundKey);
    if (source == null) return;

    try {
      await _audioPlayer.play(source);
    } catch (e) {
      print('Failed to play sound $soundKey: $e');
    }
  }

  Source? _resolveSource(String soundKey) {
    if (SoundPreset.isBundled(soundKey)) {
      return switch (soundKey) {
        SoundPreset.request => AssetSource('sounds/request.mp3'),
        SoundPreset.toggle => AssetSource('sounds/toggle.mp3'),
        _ => null,
      };
    }

    if (!SoundPreset.isValidCustomPath(soundKey)) {
      return null;
    }

    return DeviceFileSource(soundKey);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
