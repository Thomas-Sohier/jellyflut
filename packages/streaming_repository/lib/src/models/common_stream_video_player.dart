import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

import '../models/index.dart';

class CommonStreamVideoPlayer extends CommonStream<VideoPlayerController> {
  void _isInitListener(Completer<void> completer) {
    if (controller.value.isInitialized) completer.complete();
  }

  CommonStreamVideoPlayer.fromUri(
      {required Uri uri, Duration? startAtPosition}) {
    controller = _initController(uri: uri, startAtPosition: startAtPosition);
  }

  static VideoPlayerController _initController(
      {required Uri uri, Duration? startAtPosition}) {
    // Detect if media is available locdally or only remotely
    late final VideoPlayerController controller;
    if (uri.isScheme('http') || uri.isScheme('https')) {
      controller = VideoPlayerController.network(uri.toString());
    } else {
      throw UnsupportedError(
          'No suitable player implementation was found to play local file.');
    }

    return controller;
  }

  @override
  Future<void> initialize() {
    if (controller.value.isInitialized) return Future.value();
    final completer = Completer<void>();
    controller.addListener(() => _isInitListener(completer));
    return completer.future;
  }

  @override
  Widget createView() {
    return VideoPlayer(controller);
  }

  @override
  Duration? getBufferingDuration() {
    // final durationCurrentFile = controller.value.duration;
    // final totalMilliseconds = durationCurrentFile.inMilliseconds;
    final currentBufferedMilliseconds = 0;
    return Duration(
        milliseconds: currentBufferedMilliseconds.isNaN ||
                currentBufferedMilliseconds.isInfinite
            ? 0
            : currentBufferedMilliseconds.toInt());
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<List<Subtitle>> getSubtitles() async {
    final parsedSubtitiles = <Subtitle>[];
    return parsedSubtitiles;
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<List<AudioTrack>> getAudioTracks() async {
    final parsedAudioTracks = <AudioTrack>[];
    return parsedAudioTracks;
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> setAudioTrack(AudioTrack trackIndex) {
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> setSubtitle(Subtitle subtitle) {
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> disableSubtitles() {
    return Future.value();
  }

  @override
  BehaviorSubject<Duration> getPositionStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.addListener(() {
      streamController.add(controller.value.position);
    });
    return streamController;
  }

  @override
  BehaviorSubject<Duration> getDurationStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.addListener(() {
      streamController.add(controller.value.duration);
    });
    return streamController;
  }

  @override
  BehaviorSubject<bool> getPlayingStateStream() {
    final streamController = BehaviorSubject<bool>();
    controller
        .addListener(() => streamController.add(controller.value.isPlaying));
    return streamController;
  }

  @override
  Duration? getCurrentPosition() => controller.value.position;

  @override
  Duration? getDuration() => controller.value.duration;

  @override
  Future<bool> hasPip() => Future.value(false);

  @override
  bool isInit() => controller.value.isInitialized;

  @override
  bool isPlaying() => controller.value.isPlaying;

  @override
  Future<void> pause() => controller.pause();

  @override
  Future<void>? pip() => Future.value(false);

  @override
  Future<void> play() => controller.play();

  @override
  Future<void> seekTo(Duration duration) => controller.seekTo(duration);

  @override
  void enterFullscreen() {
    // already in fullscreen by default
  }

  @override
  void exitFullscreen() {
    // already in fullscreen by default
  }

  @override
  void toggleFullscreen() {
    // already in fullscreen by default
  }

  @override
  Future<bool> isFullscreen() async {
    return Future.value(true);
  }

  @override
  Future<void> dispose() async {
    await controller.pause();
    return controller.dispose();
  }
}
