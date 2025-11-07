import 'package:pomodoro_sczuw/events/timer_events.dart';
import 'package:pomodoro_sczuw/services/sound_service.dart';
import 'package:audioplayers/audioplayers.dart';

class EventsSoundService {
  final SoundService _soundService;

  EventsSoundService(this._soundService);

  void playSound(TimerEvent event) {
    final soundPath = switch (event) {
      TimerCompleted() => 'sounds/toogle.mp3',
      TimerPaused() => 'sounds/toggle.mp3',
      TimerResumed() => 'sounds/toggle.mp3',
      TimerStopped() => 'sounds/request.mp3',
      _ => '',
    };

    if (soundPath.isNotEmpty) {
      _soundService.playSound(AssetSource(soundPath));
    }
  }
}
