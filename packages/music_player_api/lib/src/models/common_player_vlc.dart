import 'package:dart_vlc/dart_vlc.dart';
import 'package:rxdart/subjects.dart';

import 'audio_source.dart';

class CommonPlayerVLC {
  final Player audioPlayer;
  const CommonPlayerVLC({required this.audioPlayer});

  void init() {
    audioPlayer.playbackStream.listen((event) {
      if (event.isCompleted) audioPlayer.next();
    });
  }

  BehaviorSubject<Duration> positionStream() {
    final streamController = BehaviorSubject<Duration>();
    audioPlayer.positionStream
        .listen((PositionState positionState) => streamController.add(positionState.position ?? Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<Duration> durationStream() {
    final streamController = BehaviorSubject<Duration>();
    audioPlayer.positionStream
        .listen((PositionState positionState) => streamController.add(positionState.duration ?? Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    audioPlayer.playbackStream.listen((PlaybackState event) => streamController.add(event.isPlaying));
    return streamController;
  }

  Future<void> dispose() async {
    audioPlayer.stop();
    return audioPlayer.dispose();
  }

  Future<void> playRemote(AudioSource audioSource) async {
    final media = Media.network(audioSource.resource);
    audioPlayer.open(media);
  }
}
