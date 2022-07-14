import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:rxdart/rxdart.dart';

import '../model/media_type.dart';

/// CommonStream Better Player specific code
class CommonStreamBP {
  static final streamingProvider = StreamingProvider();
  final BetterPlayerController betterPlayerController;

  const CommonStreamBP({required this.betterPlayerController});

  Duration getBufferingDurationBP() {
    try {
      final duration = betterPlayerController.videoPlayerController?.value.buffered
          .map((element) => element.end.inMilliseconds - element.start.inMilliseconds)
          .reduce((value, element) => value + element);
      if (duration == null) return Duration(seconds: 0);
      return Duration(milliseconds: duration);
    } catch (e) {
      return Duration(seconds: 0);
    }
  }

  static Future<BetterPlayerController> setupData({required Item item}) async {
    final streamingProvider = StreamingProvider();
    // final context = context.router.root.navigatorKey.currentContext!;
    final streamURL = '';
    // TODO en refaire un repo propre
    //await context.read<ItemsRepository>().getItemURL(item: item);

    // Detect if media is available locdally or only remotely
    late final dataSource;
    if (streamURL.startsWith(RegExp('^(http|https)://'))) {
      dataSource = BetterPlayerDataSource.network(streamURL, subtitles: _getSubtitlesBP(item));
    } else {
      dataSource = BetterPlayerDataSource.file(streamURL, subtitles: _getSubtitlesBP(item));
    }

    final aspectRatio = item.getAspectRatio();
    final betterPlayerKey = GlobalKey();
    final betterPlayerController = BetterPlayerController(_setupPlayerControllerConfiguration(
        aspectRatio: aspectRatio, startAt: item.getPlaybackPosition(), customConfiguration: _configuration()));
    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        // context.router.root.pop();
        // TODO refaire au propre avec les repo
      } else if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        final timer = _startProgressTimer(item, betterPlayerController);
        streamingProvider.timer?.cancel();
        streamingProvider.setTimer(timer);
      } else if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        streamingProvider.timer?.cancel();
      }
    });
    await betterPlayerController.setupDataSource(dataSource);
    betterPlayerController.setBetterPlayerGlobalKey(betterPlayerKey);
    final commonStream = CommonStream.parse(betterPlayerController);
    streamingProvider.setCommonStream(commonStream);
    return Future.value(betterPlayerController);
  }

  static Future<BetterPlayerController> setupDataFromURl({required String url}) async {
    final dataSource = BetterPlayerDataSource.network(url);
    final aspectRatio = 16 / 9;
    final betterPlayerKey = GlobalKey();
    final betterPlayerController = BetterPlayerController(
        _setupPlayerControllerConfiguration(aspectRatio: aspectRatio, customConfiguration: _configuration()));

    await betterPlayerController.setupDataSource(dataSource);
    betterPlayerController.setBetterPlayerGlobalKey(betterPlayerKey);
    final commonStream = CommonStream.parse(betterPlayerController);
    StreamingProvider().setCommonStream(commonStream);
    return Future.value(betterPlayerController);
  }

  static BetterPlayerConfiguration _setupPlayerControllerConfiguration(
      {double aspectRatio = 16 / 9, int startAt = 0, required BetterPlayerControlsConfiguration customConfiguration}) {
    return BetterPlayerConfiguration(
        aspectRatio: aspectRatio,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        deviceOrientationsOnFullScreen: [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        autoDetectFullscreenDeviceOrientation: true,
        allowedScreenSleep: false,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(fontSize: 18),
        startAt: Duration(microseconds: startAt),
        controlsConfiguration: customConfiguration);
  }

  static PlaybackProgress getPlaybackProgress(BetterPlayerController controller) {
    PlayMethod _playMethod() {
      final isDirectPlay = streamingProvider.isDirectPlay ?? true;
      if (isDirectPlay) return PlayMethod.directPlay;
      return PlayMethod.transcode;
    }

    return PlaybackProgress(
        itemId: streamingProvider.item!.id,
        audioStreamIndex: streamingProvider.selectedAudioTrack?.jellyfinSubtitleIndex,
        subtitleStreamIndex: streamingProvider.selectedSubtitleTrack?.jellyfinSubtitleIndex,
        canSeek: true,
        isMuted: controller.videoPlayerController!.value.volume == 0 ? true : false,
        isPaused: controller.videoPlayerController!.value.isPlaying,
        playSessionId: streamingProvider.playBackInfos?.playSessionId,
        mediaSourceId: streamingProvider.playBackInfos?.mediaSources.first.id,
        nowPlayingQueue: [],
        playbackStartTimeTicks: null,
        playMethod: _playMethod(),
        positionTicks: controller.videoPlayerController?.value.position.inMicroseconds ?? 0,
        repeatMode: RepeatMode.repeatNone,
        volumeLevel: (controller.videoPlayerController!.value.volume * 100).round());
  }

  static Timer _startProgressTimer(Item item, BetterPlayerController c) {
    return Timer.periodic(
        Duration(seconds: 15), (Timer t) => StreamingService.streamingProgress(getPlaybackProgress(c)));
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
      // customControlsBuilder: (controller, onPlayerVisibilityChanged) =>
      //     CommonControls(),
      controlBarHeight: 40,
    );
  }

  void onPlayerVisibilityChanged() {}

  static List<BetterPlayerSubtitlesSource> _getSubtitlesBP(Item item) {
    // ignore: omit_local_variable_types
    final List<BetterPlayerSubtitlesSource> parsedSubtitlesBP = [];
    var subtitles = item.mediaStreams.where((element) => element.type == MediaStreamType.Subtitle).toList();

    for (var i = 0; i < subtitles.length; i++) {
      final sub = subtitles[i];
      final subtitleSourceBP = BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.network,
          urls: [sub.isRemote() ? sub.deliveryUrl : StreamingService.getSubtitleURL(item.id, 'vtt', sub.index)],
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
      parsedSubtitiles.add(Subtitle(index: i, mediaType: MediaType.LOCAL, name: subtitles[i].name ?? 'Default'));
    }
    return parsedSubtitiles;
  }

  Future<void> disableSubtitles() {
    betterPlayerController.subtitlesLines.clear();
    return Future.value();
  }

  Future<void> setSubtitle(Subtitle subtitle) {
    return betterPlayerController
        .setupSubtitleSource(betterPlayerController.betterPlayerSubtitlesSourceList[subtitle.index]);
  }

  Future<List<AudioTrack>> getAudioTracks() {
    return Future.value(<AudioTrack>[]);
  }

  Future<void> setAudioTrack(AudioTrack audioTrack) {
    return Future.value();
  }

  BehaviorSubject<Duration> positionStream() {
    final streamController = BehaviorSubject<Duration>();
    betterPlayerController.addEventsListener((BetterPlayerEvent betterPlayerEvent) =>
        streamController.add(betterPlayerController.videoPlayerController!.value.position));
    return streamController;
  }

  BehaviorSubject<Duration> durationStream() {
    final streamController = BehaviorSubject<Duration>();
    betterPlayerController.addEventsListener((_) =>
        streamController.add(betterPlayerController.videoPlayerController!.value.duration ?? Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    betterPlayerController.addEventsListener((_) => streamController.add(betterPlayerController.isPlaying() ?? false));
    return streamController;
  }

  Future<void> stopPlayer() async {
    await StreamingService.deleteActiveEncoding();
    await betterPlayerController.pause();
    return betterPlayerController.dispose();
  }
}
