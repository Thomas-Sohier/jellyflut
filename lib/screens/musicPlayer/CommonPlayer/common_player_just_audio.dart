import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_source.dart';
import 'package:just_audio/just_audio.dart' hide AudioSource;
import 'package:rxdart/rxdart.dart';

class CommonPlayerJustAudio {
  static final streamingProvider = StreamingProvider();
  final AudioPlayer audioPlayer;
  const CommonPlayerJustAudio({required this.audioPlayer});

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    audioPlayer.playerStateStream.listen((event) {
      streamController.add(event.playing);
    });
    return streamController;
  }

  BehaviorSubject<Duration> positionStream() {
    return BehaviorSubject<Duration>()..addStream(audioPlayer.positionStream);
  }

  BehaviorSubject<Duration?> durationStream() {
    return BehaviorSubject<Duration?>()..addStream(audioPlayer.durationStream);
  }

  void playRemote(AudioSource audioSource) async {
    await audioPlayer.setUrl(audioSource.resource);
  }
}
