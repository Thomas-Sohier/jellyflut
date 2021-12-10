import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/media_stream_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream.dart';
import 'package:jellyflut/screens/stream/components/common_controls.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/rxdart.dart';

/// CommonStream Better Player specific code
class CommonStreamBP {
  static final streamingProvider = StreamingProvider();
  final BetterPlayerController betterPlayerController;

  const CommonStreamBP({required this.betterPlayerController});

  Duration getBufferingDurationBP() {
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
    final streamingProvider = StreamingProvider();
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
        customRouter.pop();
      } else if (event.betterPlayerEventType ==
          BetterPlayerEventType.initialized) {
        final timer = _startProgressTimer(item, _betterPlayerController);
        streamingProvider.timer?.cancel();
        streamingProvider.setTimer(timer);
      } else if (event.betterPlayerEventType ==
          BetterPlayerEventType.finished) {
        StreamingService.deleteActiveEncoding();
        streamingProvider.timer?.cancel();
      }
    });
    await _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    final commonStream = CommonStream.parseBetterPlayerController(
      betterPlayerController: _betterPlayerController,
      listener: () => {},
    );
    streamingProvider.setCommonStream(commonStream);
    return Future.value(_betterPlayerController);
  }

  static Future<BetterPlayerController> setupDataFromURl(
      {required String url}) async {
    final dataSource = BetterPlayerDataSource.network(url);
    final aspectRatio = 16 / 9;
    final _betterPlayerKey = GlobalKey();
    final _betterPlayerController = BetterPlayerController(
        _setupPlayerControllerConfiguration(
            aspectRatio: aspectRatio, customConfiguration: _configuration()));

    await _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    final commonStream = CommonStream.parseBetterPlayerController(
      betterPlayerController: _betterPlayerController,
      listener: () => {},
    );
    StreamingProvider().setCommonStream(commonStream);
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
        (Timer t) => StreamingService.streamingProgress(item,
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
      showControlsOnInitialize: false,
      playerTheme: BetterPlayerTheme.custom,
      customControlsBuilder: (controller, onPlayerVisibilityChanged) =>
          CommonControls(),
      controlBarHeight: 40,
    );
  }

  void onPlayerVisibilityChanged() {}

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
                : StreamingService.getSubtitleURL(item.id, 'vtt', sub.index)
          ],
          selectedByDefault: false,
          name: '${sub.language} - ${sub.title}');
      parsedSubtitlesBP.add(subtitleSourceBP);
    }
    return parsedSubtitlesBP;
  }

  Future<List<Subtitle>> getSubtitles() async {
    // ignore: omit_local_variable_types
    final List<Subtitle> parsedSubtitiles = [];
    final subtitles = betterPlayerController.betterPlayerSubtitlesSourceList;
    for (var i = 0; i < subtitles.length - 1; i++) {
      parsedSubtitiles
          .add(Subtitle(index: i, name: subtitles[i].name ?? 'Default'));
    }
    return parsedSubtitiles;
  }

  void setSubtitle(
    Subtitle subtitle,
  ) {
    betterPlayerController.setupSubtitleSource(
        betterPlayerController.betterPlayerSubtitlesSourceList[subtitle.index]);
  }

/*
  List<BetterPlayerSubtitlesSource> _getAudioTracksBP(Item item) {
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

  Future<List<AudioTrack>> getAudioTracks() async {
    // ignore: omit_local_variable_types
    final List<AudioTrack> parsedAudioTrack = [];
    var audioTracks = StreamingProvider()
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

  void setAudioTrack(
    AudioTrack audioTrack,
  ) async {
    final newUrl = await StreamingService.getNewAudioSource(
        audioTrack.jellyfinSubtitleIndex!,
        playbackTick:
            betterPlayerController.videoPlayerController!.value.position);
    final streamModel = StreamingProvider();
    var tick = betterPlayerController
        .videoPlayerController!.value.position.inMicroseconds;
    var dataSource = BetterPlayerDataSource.network(newUrl,
        subtitles: _getSubtitlesBP(streamModel.item!));
    betterPlayerController.betterPlayerSubtitlesSourceList.clear();
    await betterPlayerController.clearCache();
    await betterPlayerController.setupDataSource(dataSource);
    betterPlayerController.playNextVideo();
    await betterPlayerController.videoPlayerController!.play();
    await betterPlayerController.seekTo(Duration(microseconds: tick));
  }

  BehaviorSubject<Duration> positionStream() {
    final streamController = BehaviorSubject<Duration>();
    betterPlayerController.addEventsListener(
        (BetterPlayerEvent betterPlayerEvent) => streamController
            .add(betterPlayerController.videoPlayerController!.value.position));
    return streamController;
  }

  BehaviorSubject<Duration> durationStream() {
    final streamController = BehaviorSubject<Duration>();
    betterPlayerController.addEventsListener((_) => streamController.add(
        betterPlayerController.videoPlayerController!.value.duration ??
            Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    betterPlayerController.addEventsListener((_) =>
        streamController.add(betterPlayerController.isPlaying() ?? false));
    return streamController;
  }

  void stopPlayer() {
    StreamingService.deleteActiveEncoding();
    betterPlayerController.pause();
    betterPlayerController.dispose();
  }
}
