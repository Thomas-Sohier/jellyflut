import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:just_audio_mpv/src/mpv_player.dart' as mpv_player;
import 'package:just_audio_platform_interface/just_audio_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

class CommonPlayerMPV {
  static final musicProvider = MusicProvider();
  final mpv_player.JustAudioMPVPlayer audioPlayer;
  const CommonPlayerMPV({required this.audioPlayer});

  void seek(Duration duration) {
    final seekRequest = SeekRequest(index: 0, position: duration);
    audioPlayer.seek(seekRequest);
  }

  void playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    audioPlayer.mpv;
  }
}
