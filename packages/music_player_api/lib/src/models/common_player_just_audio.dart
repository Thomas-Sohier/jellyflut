import 'package:just_audio/just_audio.dart' hide AudioSource;
import 'package:rxdart/rxdart.dart';

import 'audio_source.dart';

class CommonPlayerJustAudio {
  final AudioPlayer audioPlayer;
  BehaviorSubject<void>? _audioEndBehaviorSubject;

  CommonPlayerJustAudio({required this.audioPlayer});

  void init() {
    // we are creating an another stream because [playbackEventStream] is
    // a "sync" broadcast stream which prevent us from firing another event
    // such as playing next...
    // Passing the event to a new behaviorSubject prevent this
    _audioEndBehaviorSubject = BehaviorSubject<void>();
    audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      if (event.processingState == ProcessingState.completed) {
        _audioEndBehaviorSubject?.add(0);
      }
    });
    _audioEndBehaviorSubject?.listen((_) {
      audioPlayer.seekToNext();
    });
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    audioPlayer.playerStateStream.listen((event) {
      streamController.add(event.playing);
    });
    return streamController;
  }

  BehaviorSubject<Duration> positionStream() {
    final positionStream = BehaviorSubject<Duration>();
    audioPlayer.positionStream.listen((value) {
      positionStream.add(value);
    });
    return positionStream;
  }

  BehaviorSubject<Duration> durationStream() {
    final durationStream = BehaviorSubject<Duration>();
    audioPlayer.durationStream.listen((value) {
      durationStream.add(value ?? Duration.zero);
    });
    return durationStream;
  }

  Future<void> playRemote(AudioSource audioSource) async {
    await audioPlayer.setUrl(audioSource.resource);
    return audioPlayer.play();
  }

  Future<void> dispose() async {
    await _audioEndBehaviorSubject?.close();
    await audioPlayer.stop();
    await audioPlayer.dispose();
  }
}
