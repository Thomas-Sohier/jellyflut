import 'dart:async';
import 'package:universal_io/io.dart';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:window_manager/window_manager.dart';

import '../models/index.dart';

class CommonStreamVLCComputer extends CommonStream {
  @override
  // ignore: overridden_fields
  final Player controller;
  final List<Timer> timers;

  const CommonStreamVLCComputer({required this.controller, this.timers = const <Timer>[]})
      : super(controller: controller);

  CommonStreamVLCComputer.fromUri(
      {required Uri uri, int startAtPosition = 0, required this.controller, this.timers = const <Timer>[]})
      : super(controller: _initController(uri: uri, startAtPosition: startAtPosition));

  static Player _initController({required Uri uri, int startAtPosition = 0}) {
    final controller = Player(
        id: 0, commandlineArguments: ['--start-time=${Duration(microseconds: startAtPosition).inSeconds}', '--no-spu']);

    late final Media media;
    if (uri.isScheme('http') || uri.isScheme('https')) {
      media = Media.network(uri.toString());
    } else {
      media = Media.file(File(uri.toFilePath()));
    }

    controller.open(media, autoStart: false);
    return controller;
  }

  void addListener(void Function() listener) {
    final timer = Timer.periodic(Duration(milliseconds: 100), (i) => listener());
    timers.add(timer);
  }

  void removeListener() {
    for (var t in timers) {
      t.cancel();
    }
  }

  @override
  Future<void> play() {
    controller.play();
    return Future.value();
  }

  @override
  Future<void> pause() {
    controller.pause();
    return Future.value();
  }

  @override
  Future<void> seekTo(Duration duration) {
    controller.seek(duration);
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> pip() {
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<List<Subtitle>> getSubtitles() {
    return Future.value(<Subtitle>[]);
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

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<List<AudioTrack>> getAudioTracks() {
    return Future.value(<AudioTrack>[]);
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> setAudioTrack(AudioTrack audioTrack) {
    return Future.value();
  }

  @override
  void enterFullscreen() async {
    final windowInstance = WindowManager.instance;
    await windowInstance.setFullScreen(true);
  }

  @override
  void exitFullscreen() async {
    final windowInstance = WindowManager.instance;
    await windowInstance.setFullScreen(false);
  }

  @override
  void toggleFullscreen() async {
    final windowInstance = WindowManager.instance;
    await windowInstance.isFullScreen().then((bool isFullscreen) => windowInstance.setFullScreen(!isFullscreen));
  }

  @override
  BehaviorSubject<Duration> getPositionStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.positionStream
        .listen((PositionState positionState) => streamController.add(positionState.position ?? Duration(seconds: 0)));
    return streamController;
  }

  @override
  BehaviorSubject<Duration> getDurationStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.positionStream
        .listen((PositionState positionState) => streamController.add(positionState.duration ?? Duration(seconds: 0)));
    return streamController;
  }

  @override
  BehaviorSubject<bool> getPlayingStateStream() {
    final streamController = BehaviorSubject<bool>();
    controller.playbackStream.listen((PlaybackState event) => streamController.add(event.isPlaying));
    return streamController;
  }

  @override
  Future<void> dispose() async {
    controller.stop();
    return controller.dispose();
  }

  @override
  Duration? getBufferingDuration() {
    // TODO: implement getBufferingDuration
    throw UnimplementedError();
  }

  @override
  Duration? getCurrentPosition() => controller.position.position;

  @override
  Duration? getDuration() => controller.position.duration;

  @override
  Future<bool> hasPip() => Future.value(false);

  @override
  bool isInit() => true;

  @override
  bool isPlaying() => controller.playback.isPlaying;
}
