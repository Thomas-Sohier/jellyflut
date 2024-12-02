import 'package:media_kit/media_kit.dart';
import 'package:rxdart/subjects.dart';

import 'audio_source.dart';

class MediaKitAudio {
  final Player audioPlayer;
  const MediaKitAudio({required this.audioPlayer});

  void init() {}

  BehaviorSubject<Duration> positionStream() {
    final streamController = BehaviorSubject<Duration>();
    audioPlayer.stream.position
        .listen((Duration duration) => streamController.add(duration));
    return streamController;
  }

  BehaviorSubject<Duration> durationStream() {
    final streamController = BehaviorSubject<Duration>();
    audioPlayer.stream.duration
        .listen((Duration duration) => streamController.add(duration));
    return streamController;
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    audioPlayer.stream.playing
        .listen((bool isPlaying) => streamController.add(isPlaying));
    return streamController;
  }

  Future<void> dispose() async {
    await audioPlayer.stop();
    return audioPlayer.dispose();
  }

  Future<void> playRemote(AudioSource audioSource) async {
    final media = Media(audioSource.resource);
    return audioPlayer.open(media);
  }
}
