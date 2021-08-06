import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/mediaStreamType.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/components/commonControls.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStream.dart';
import 'package:jellyflut/screens/stream/model/audiotrack.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';

/// CommonStream Better Player specific code
class CommonStreamBP {
  static Duration getBufferingDurationBP(
      BetterPlayerController betterPlayerController) {
    try {
      final duration = betterPlayerController
          .videoPlayerController?.value.buffered
          .map((element) =>
              element.end.inMilliseconds - element.start.inMilliseconds)
          .reduce((value, element) => value + element);
      if (duration == null) return Duration(seconds: 0);
      return Duration(milliseconds: duration);
    } catch (e) {
      return Duration(seconds: 0);
    }
  }

  static Future<BetterPlayerController> setupData({required Item item}) async {
    final streamURL = await item.getItemURL();
    final dataSource = BetterPlayerDataSource.network(streamURL,
        subtitles: _getSubtitlesBP(item));
    final aspectRatio = item.getAspectRatio();
    final _betterPlayerKey = GlobalKey();
    final _betterPlayerController = BetterPlayerController(
        _setupPlayerControllerConfiguration(
            aspectRatio: aspectRatio,
            startAt: item.getPlaybackPosition(),
            customConfiguration: _configuration()));
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        Navigator.pop(navigatorKey.currentContext!);
        // showToast(event.parameters.toString(), fToast,
        //     duration: Duration(seconds: 3));
      } else if (event.betterPlayerEventType ==
          BetterPlayerEventType.initialized) {
        final timer = _startProgressTimer(item, _betterPlayerController);
        StreamModel().setTimer(timer);
      } else if (event.betterPlayerEventType ==
          BetterPlayerEventType.finished) {
        deleteActiveEncoding();
        StreamModel().timer?.cancel();
      }
    });
    await _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    final commonStream = CommonStream.parseBetterPlayerController(
        betterPlayerController: _betterPlayerController,
        listener: () => {},
        item: item);
    StreamModel().setCommonStream(commonStream);
    return Future.value(_betterPlayerController);
  }

  static BetterPlayerConfiguration _setupPlayerControllerConfiguration(
      {double aspectRatio = 16 / 9,
      int startAt = 0,
      required BetterPlayerControlsConfiguration customConfiguration}) {
    return BetterPlayerConfiguration(
        aspectRatio: aspectRatio,
        fit: BoxFit.contain,
        autoPlay: true,
        autoDispose: true,
        looping: false,
        fullScreenByDefault: false,
        deviceOrientationsOnFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        autoDetectFullscreenDeviceOrientation: true,
        allowedScreenSleep: false,
        subtitlesConfiguration:
            BetterPlayerSubtitlesConfiguration(fontSize: 18),
        startAt: Duration(microseconds: startAt),
        controlsConfiguration: customConfiguration);
  }

  static Timer _startProgressTimer(
      Item item, BetterPlayerController betterPlayerController) {
    return Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => itemProgress(item,
            canSeek: true,
            isMuted:
                betterPlayerController.videoPlayerController!.value.volume > 0
                    ? true
                    : false,
            isPaused:
                betterPlayerController.videoPlayerController!.value.isPlaying,
            positionTicks: betterPlayerController
                .videoPlayerController!.value.position.inMicroseconds,
            volumeLevel: betterPlayerController
                .videoPlayerController!.value.volume
                .round(),
            subtitlesIndex: 0));
  }

  static BetterPlayerControlsConfiguration _configuration() {
    return BetterPlayerControlsConfiguration(
      enableSkips: false,
      enableFullscreen: false,
      enableProgressText: true,
      enablePlaybackSpeed: true,
      enableMute: true,
      enablePlayPause: true,
      enableSubtitles: true,
      enableQualities: false,
      showControlsOnInitialize: true,
      playerTheme: BetterPlayerTheme.custom,
      customControlsBuilder: (controller) => CommonControls(),
      controlBarHeight: 40,
    );
  }

  static List<BetterPlayerSubtitlesSource> _getSubtitlesBP(Item item) {
    // ignore: omit_local_variable_types
    final List<BetterPlayerSubtitlesSource> parsedSubtitlesBP = [];
    var subtitles = item.mediaStreams!
        .where((element) => element.type == MediaStreamType.SUBTITLE)
        .toList();

    for (var i = 0; i < subtitles.length; i++) {
      final sub = subtitles[i];
      final subtitleSourceBP = BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.network,
          urls: [
            sub.isRemote()
                ? sub.deliveryUrl
                : getSubtitleURL(item.id, 'vtt', sub.index)
          ],
          selectedByDefault: false,
          name: '${sub.language} - ${sub.title}');
      parsedSubtitlesBP.add(subtitleSourceBP);
    }
    return parsedSubtitlesBP;
  }

  static Future<List<Subtitle>> getSubtitles(
      BetterPlayerController betterPlayerController) async {
    // ignore: omit_local_variable_types
    final List<Subtitle> parsedSubtitiles = [];
    final subtitles = betterPlayerController.betterPlayerSubtitlesSourceList;
    for (var i = 0; i < subtitles.length - 1; i++) {
      parsedSubtitiles
          .add(Subtitle(index: i, name: subtitles[i].name ?? 'Default'));
    }
    return parsedSubtitiles;
  }

  static void setSubtitle(
      int trackIndex, BetterPlayerController betterPlayerController) {
    betterPlayerController.setupSubtitleSource(
        betterPlayerController.betterPlayerSubtitlesSourceList[trackIndex]);
  }

/*
  static List<BetterPlayerSubtitlesSource> _getAudioTracksBP(Item item) {
    final List<BetterPlayerSubtitlesSource> parsedSubtitlesBP = [];
    var audioTracks = item.mediaStreams!
        .where((element) => element.type == MediaStreamType.AUDIO)
        .toList();

    for (var i = 0; i < audioTracks.length; i++) {
      final audioTrack = audioTracks[i];
      final subtitleSourceBP = BetterPlayerAsmsAudioTrack(
          id: audioTrack.index,
          url: audioTrack.isRemote()
              ? audioTrack.deliveryUrl
              : getAudioURL(item.id, 'vtt', sub.index!));
      parsedSubtitlesBP.add(subtitleSourceBP);
    }
    return parsedSubtitlesBP;
  }
  */

  static Future<List<AudioTrack>> getAudioTracks(
      BetterPlayerController betterPlayerController) async {
    // ignore: omit_local_variable_types
    final List<AudioTrack> parsedAudioTrack = [];
    var audioTracks = StreamModel()
        .item!
        .mediaStreams!
        .where((element) => element.type == MediaStreamType.AUDIO)
        .toList();
    ;
    for (var i = 0; i < audioTracks.length; i++) {
      parsedAudioTrack.add(AudioTrack(
          index: i,
          jellyfinSubtitleIndex: audioTracks[i].index,
          name: audioTracks[i].displayTitle ?? 'Default'));
    }
    return parsedAudioTrack;
  }

  static void setAudioTrack(AudioTrack audioTrack,
      BetterPlayerController betterPlayerController) async {
    final newUrl = await getNewAudioSource(audioTrack.jellyfinSubtitleIndex!,
        playbackTick:
            betterPlayerController.videoPlayerController!.value.position);
    final streamModel = StreamModel();
    var tick = betterPlayerController
        .videoPlayerController!.value.position.inMicroseconds;
    var dataSource = BetterPlayerDataSource.network(newUrl,
        subtitles: _getSubtitlesBP(streamModel.item!));
    betterPlayerController.betterPlayerSubtitlesSourceList.clear();
    // await betterPlayerController.setupDataSource(dataSource);
    // betterPlayerController.playNextVideo();
    // await betterPlayerController.clearCache();
    await betterPlayerController.videoPlayerController!
        .setNetworkDataSource(newUrl);
    await betterPlayerController.videoPlayerController!.play();
    await betterPlayerController.seekTo(Duration(microseconds: tick));
  }
}
