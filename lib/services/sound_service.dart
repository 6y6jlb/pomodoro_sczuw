import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Future<void> playSound(AssetSource path) async {
    if (!_isEnabled) return;

    try {
      await _audioPlayer.play(path);
    } catch (e) {
      print('Failed to play sound $path: $e');
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
