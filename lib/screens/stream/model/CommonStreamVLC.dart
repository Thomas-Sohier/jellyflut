import 'dart:async';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/model/CommonStream.dart';

class CommonStreamVLC {
  static Duration getBufferingDurationVLC(
      VlcPlayerController vlcPlayerController) {
    final durationCurrentFile = vlcPlayerController.value.duration;
    final totalMilliseconds = durationCurrentFile.inMilliseconds;
    final currentBufferedMilliseconds =
        totalMilliseconds / vlcPlayerController.value.bufferPercent;
    return Duration(
        milliseconds: currentBufferedMilliseconds.isNaN ||
                currentBufferedMilliseconds.isInfinite
            ? 0
            : currentBufferedMilliseconds.toInt());
  }

  static Future<VlcPlayerController> setupData({required Item item}) async {
    final streamURL = await item.getItemURL(directPlay: true);

    // Create vlcPlayerController
    final vlcPlayerController = VlcPlayerController.network(
      streamURL,
      autoPlay: true,
      options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(2000),
          ]),
          extras: [
            '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}' // Start at x seconds
          ]),
    );

    // create timer to save progress
    final timer = _startProgressTimer(item, vlcPlayerController);
    StreamModel().setTimer(timer);

    // create common stream controller
    final commonStream = CommonStream.parseVLCController(
        item: item,
        vlcPlayerController: vlcPlayerController,
        listener: () => {});

    StreamModel().setCommonStream(commonStream);
    return Future.value(vlcPlayerController);
  }

  static Timer _startProgressTimer(
      Item item, VlcPlayerController vlcPlayerController) {
    return Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => itemProgress(item,
            canSeek: true,
            isMuted: vlcPlayerController.value.volume > 0 ? true : false,
            isPaused: !vlcPlayerController.value.isPlaying,
            positionTicks: vlcPlayerController.value.position.inMicroseconds,
            volumeLevel: vlcPlayerController.value.volume.round(),
            subtitlesIndex: 0));
  }
}
