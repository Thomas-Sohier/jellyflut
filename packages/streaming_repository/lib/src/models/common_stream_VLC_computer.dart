import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:universal_io/io.dart';

import 'package:dart_vlc/dart_vlc.dart' hide MediaType;
import 'package:rxdart/rxdart.dart';

import '../models/index.dart';

class CommonStreamVLCComputer extends CommonStream<Player> {
  final List<Timer> timers;

  CommonStreamVLCComputer.fromUri({required Uri uri, Duration? startAtPosition, this.timers = const <Timer>[]}) {
    controller = _initController(uri: uri, startAtPosition: startAtPosition);
  }

  static Player _initController({required Uri uri, Duration? startAtPosition}) {
    final controller =
        Player(id: 0, commandlineArguments: ['--start-time=${startAtPosition?.inSeconds ?? 0}', '--no-spu']);

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
  Widget createView() {
    return Video(
      player: controller,
      showControls: false,
    );
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

  @override
  Future<void> initialize() {
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
    final audioTracks = <AudioTrack>[];
    for (var i = 0; i < controller.audioTrackCount; i++) {
      final audioTrack = AudioTrack(index: i.toString(), name: 'Audio track #$i', mediaType: MediaType.local);
      audioTracks.add(audioTrack);
    }
    return Future.value(audioTracks);
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> setAudioTrack(AudioTrack audioTrack) {
    controller.setAudioTrack(int.parse(audioTrack.index));
    return Future.value();
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
    return Duration.zero;
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
