import 'package:audioplayers/audioplayers.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:rxdart/rxdart.dart';

class CommonPlayerAudioplayers {
  static final musicProvider = MusicProvider();
  final AudioPlayer audioPlayer;
  const CommonPlayerAudioplayers({required this.audioPlayer});

  void seek(Duration duration) {
    audioPlayer.seek(duration);
  }

  void playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    audioPlayer.onPlayerStateChanged.listen((PlayerState event) {
      switch (event) {
        case PlayerState.paused:
          streamController.add(false);
          break;
        case PlayerState.playing:
          streamController.add(true);
          break;
        default:
      }
    });
  }
}
