import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:rxdart/rxdart.dart';

import '../models/index.dart';

/// CommonStream Better Player specific code
class CommonStreamBP extends CommonStream<BetterPlayerController> {
  void _isInitListener(BetterPlayerEvent event, Completer<void> completer) {
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      return completer.complete();
    }
  }

  CommonStreamBP.fromUri({required Uri uri, Duration? startAtPosition}) {
    controller = _initController(uri: uri, startAtPosition: startAtPosition);
  }

  static BetterPlayerController _initController(
      {required Uri uri, Duration? startAtPosition}) {
    late final BetterPlayerDataSource dataSource;
    if (uri.isScheme('http') || uri.isScheme('https')) {
      dataSource = BetterPlayerDataSource.network(uri.toString());
    } else {
      dataSource = BetterPlayerDataSource.file(uri.toFilePath());
    }

    final controller =
        BetterPlayerController(_setupPlayerControllerConfiguration(
      customConfiguration: _configuration(),
      startAt: startAtPosition,
    ));
    controller.setupDataSource(dataSource);
    return controller;
  }

  static BetterPlayerConfiguration _setupPlayerControllerConfiguration(
      {double aspectRatio = 16 / 9,
      Duration? startAt,
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
        startAt: startAt,
        controlsConfiguration: customConfiguration);
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
      controlBarHeight: 40,
    );
  }

  @override
  Future<void> initialize() {
    if (controller.isVideoInitialized() ?? false) return Future.value();
    final completer = Completer<void>();
    controller.addEventsListener((event) => _isInitListener(event, completer));
    return completer.future;
  }

  @override
  Widget createView() {
    return BetterPlayer(controller: controller);
  }

  @override
  Duration? getBufferingDuration() {
    try {
      final duration = controller.videoPlayerController?.value.buffered
          .map((element) =>
              element.end.inMilliseconds - element.start.inMilliseconds)
          .reduce((value, element) => value + element);
      if (duration == null) return Duration(seconds: 0);
      return Duration(milliseconds: duration);
    } catch (e) {
      return Duration(seconds: 0);
    }
  }

  // static List<BetterPlayerSubtitlesSource> _getSubtitlesBP(Item item) {
  //   // ignore: omit_local_variable_types
  //   final List<BetterPlayerSubtitlesSource> parsedSubtitlesBP = [];
  //   var subtitles = item.mediaStreams.where((element) => element.type == MediaStreamType.Subtitle).toList();

  //   for (var i = 0; i < subtitles.length; i++) {
  //     final sub = subtitles[i];
  //     final subtitleSourceBP = BetterPlayerSubtitlesSource(
  //         type: BetterPlayerSubtitlesSourceType.network,
  //         urls: [sub.isRemote() ? sub.deliveryUrl : StreamingService.getSubtitleURL(item.id, 'vtt', sub.index)],
  //         selectedByDefault: false,
  //         name: '${sub.language} - ${sub.title}');
  //     parsedSubtitlesBP.add(subtitleSourceBP);
  //   }
  //   return parsedSubtitlesBP;
  // }

  @override
  Future<List<Subtitle>> getSubtitles() async {
    // ignore: omit_local_variable_types
    final List<Subtitle> parsedSubtitiles = [];
    final subtitles = controller.betterPlayerSubtitlesSourceList;
    for (var i = 0; i < subtitles.length - 1; i++) {
      parsedSubtitiles.add(Subtitle(
          index: i,
          mediaType: MediaType.local,
          name: subtitles[i].name ?? 'Default'));
    }
    return parsedSubtitiles;
  }

  @override
  Future<void> disableSubtitles() {
    controller.subtitlesLines.clear();
    return Future.value();
  }

  @override
  Future<void> setSubtitle(Subtitle subtitle) {
    return controller.setupSubtitleSource(
        controller.betterPlayerSubtitlesSourceList[subtitle.index]);
  }

  @override
  Future<List<AudioTrack>> getAudioTracks() {
    return Future.value(<AudioTrack>[]);
  }

  @override
  Future<void> setAudioTrack(AudioTrack audioTrack) {
    return Future.value();
  }

  @override
  BehaviorSubject<Duration> getPositionStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.addEventsListener((BetterPlayerEvent betterPlayerEvent) =>
        streamController.add(controller.videoPlayerController!.value.position));
    return streamController;
  }

  @override
  BehaviorSubject<Duration> getDurationStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.addEventsListener((_) => streamController.add(
        controller.videoPlayerController!.value.duration ??
            Duration(seconds: 0)));
    return streamController;
  }

  @override
  BehaviorSubject<bool> getPlayingStateStream() {
    final streamController = BehaviorSubject<bool>();
    controller.addEventsListener(
        (_) => streamController.add(controller.isPlaying() ?? false));
    return streamController;
  }

  @override
  void enterFullscreen() {
    // TODO: implement enterFullscreen
  }

  @override
  void exitFullscreen() {
    // TODO: implement exitFullscreen
  }

  @override
  void toggleFullscreen() {
    // TODO: implement toggleFullscreen
  }

  @override
  Future<bool> isFullscreen() async {
    return Future.value(true);
  }

  @override
  Duration? getCurrentPosition() =>
      controller.videoPlayerController?.value.position ?? Duration.zero;

  @override
  Duration? getDuration() =>
      controller.videoPlayerController?.value.duration ?? Duration.zero;

  @override
  Future<bool> hasPip() => controller.isPictureInPictureSupported();

  @override
  bool isInit() => controller.isVideoInitialized() ?? false;

  @override
  bool isPlaying() =>
      controller.videoPlayerController?.value.isPlaying ?? false;

  @override
  Future<void> pause() => controller.pause();

  @override
  Future<void>? pip() =>
      controller.enablePictureInPicture(controller.betterPlayerGlobalKey!);

  @override
  Future<void> play() => controller.play();

  @override
  Future<void> seekTo(Duration duration) => controller.seekTo(duration);

  @override
  Future<void> dispose() async {
    await controller.pause();
    return controller.dispose();
  }
}
