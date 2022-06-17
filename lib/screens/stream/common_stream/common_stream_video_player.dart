import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

class CommonStreamVideoPlayer {
  static final streamingProvider = StreamingProvider();
  final VideoPlayerController videoPlayerController;

  const CommonStreamVideoPlayer({required this.videoPlayerController});

  Duration getBufferingDurationVLC() {
    // final durationCurrentFile = videoPlayerController.value.duration;
    // final totalMilliseconds = durationCurrentFile.inMilliseconds;
    final currentBufferedMilliseconds = 0;
    return Duration(
        milliseconds: currentBufferedMilliseconds.isNaN ||
                currentBufferedMilliseconds.isInfinite
            ? 0
            : currentBufferedMilliseconds.toInt());
  }

  static Future<VideoPlayerController> setupData({required Item item}) async {
    final streamingProvider = StreamingProvider();
    final streamURL = await item.getItemURL(directPlay: false);

    // Detect if media is available locdally or only remotely
    late final VideoPlayerController videoPlayerController;
    if (streamURL.startsWith(RegExp('^(http|https)://'))) {
      videoPlayerController = VideoPlayerController.network(streamURL);
      // ignore: unawaited_futures
      videoPlayerController.initialize().then((value) async {
        await videoPlayerController.play();
        streamingProvider.notifyInit();
      }).catchError((error) {
        String errorMessage;
        if (error is PlatformException) {
          errorMessage = error.details;
        } else {
          errorMessage = error.toString();
        }
        log(errorMessage, level: 5);
        SnackbarUtil.message(errorMessage, Icons.play_disabled, Colors.red);
        customRouter.pop();
      });
    } else {
      // videoPlayerController = VideoPlayerController.file(File(streamURL));
      throw UnsupportedError(
          'No suitable player implementation was found to play local file.');
    }

    // create timer to save progress
    final timer = _startProgressTimer(item, videoPlayerController);
    streamingProvider.timer?.cancel();
    streamingProvider.setTimer(timer);

    // create common stream controller
    final commonStream = CommonStream.parse(videoPlayerController);

    streamingProvider.setCommonStream(commonStream);
    return Future.value(videoPlayerController);
  }

  static Future<VideoPlayerController> setupDataFromUrl(
      {required String url}) async {
    // Create vlcPlayerController
    final videoPlayerController = VideoPlayerController.network(url);

    // create common stream controller
    final commonStream = CommonStream.parse(videoPlayerController);

    StreamingProvider().setCommonStream(commonStream);
    return Future.value(videoPlayerController);
  }

  static Timer _startProgressTimer(
      Item item, VideoPlayerController vlcPlayerController) {
    return Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => StreamingService.streamingProgress(item,
            canSeek: true,
            isMuted: vlcPlayerController.value.volume > 0 ? true : false,
            isPaused: !vlcPlayerController.value.isPlaying,
            positionTicks: vlcPlayerController.value.position.inMicroseconds,
            volumeLevel: vlcPlayerController.value.volume.round(),
            subtitlesIndex: 0));
  }

  Future<List<Subtitle>> getSubtitles() async {
    final parsedSubtitiles = <Subtitle>[];
    return parsedSubtitiles;
  }

  Future<List<AudioTrack>> getAudioTracks() async {
    final parsedAudioTracks = <AudioTrack>[];
    return parsedAudioTracks;
  }

  void setSpuTrack(Subtitle subtitle) {}

  void setAudioTrack(AudioTrack trackIndex) {}

  BehaviorSubject<Duration> positionStream() {
    final streamController = BehaviorSubject<Duration>();
    videoPlayerController.addListener(() {
      streamController.add(videoPlayerController.value.position);
    });
    return streamController;
  }

  BehaviorSubject<Duration> durationStream() {
    final streamController = BehaviorSubject<Duration>();
    videoPlayerController.addListener(() {
      streamController.add(videoPlayerController.value.duration);
    });
    return streamController;
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    videoPlayerController.addListener(
        () => streamController.add(videoPlayerController.value.isPlaying));
    return streamController;
  }

  Future<void> stopPlayer() async {
    await StreamingService.deleteActiveEncoding();
    await videoPlayerController.pause();
    return videoPlayerController.dispose();
  }
}
