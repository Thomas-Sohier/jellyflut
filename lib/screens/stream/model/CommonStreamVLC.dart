import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CommonStreamVLC {
  static Duration getBufferingDurationVLC(
      VlcPlayerController vlcPlayerController) {
    final durationCurrentFile = vlcPlayerController.value.duration;
    final totalMilliseconds = durationCurrentFile.inMilliseconds;
    final currentBufferedMilliseconds =
        totalMilliseconds / vlcPlayerController.value.bufferPercent;
    return Duration(milliseconds: currentBufferedMilliseconds.toInt());
  }
}
