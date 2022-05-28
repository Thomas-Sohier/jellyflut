import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:just_audio/just_audio.dart';
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
}
