import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Future<void> playSound(String soundKey) async {
    final path = switch (soundKey) {
      'request' => AssetSource('sounds/request.mp3'),
      'toggle' => AssetSource('sounds/toggle.mp3'),
      _ => null,
    };

    if (!_isEnabled || path == null) return;

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
