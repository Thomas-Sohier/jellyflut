import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:media_kit/media_kit.dart' hide AudioTrack;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:rxdart/rxdart.dart';

import '../models/index.dart';

class CommonStreamMediaKit extends CommonStream<Player> {
  VideoController? _videoController;

  CommonStreamMediaKit.fromUri({required Uri uri, Duration? startAtPosition}) {
    controller = _initController(uri: uri, startAtPosition: startAtPosition);
  }

  static Player _initController({required Uri uri, Duration? startAtPosition}) {
    // Detect if media is available locally or only remotely
    MediaKit.ensureInitialized();
    final player = Player();
    var media = Media(uri.toString());
    player.open(media);
    return player;
  }

  @override
  Future<void> initialize() async {
    return Future.microtask(() async {
      _videoController = VideoController(controller);
      await controller.play();
    });
  }

  @override
  Widget createView() {
    if (_videoController == null) {
      throw Exception('VideoController is null');
    }
    return Video(
      controller: _videoController!,
      width: 1920,
      height: 1080,
    );
  }

  @override
  Duration? getBufferingDuration() {
    // final durationCurrentFile = controller.value.duration;
    // final totalMilliseconds = durationCurrentFile.inMilliseconds;
    final currentBufferedMilliseconds = 0;
    return Duration(
        milliseconds: currentBufferedMilliseconds.isNaN || currentBufferedMilliseconds.isInfinite
            ? 0
            : currentBufferedMilliseconds.toInt());
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<List<Subtitle>> getSubtitles() async {
    final parsedSubtitiles = controller.state.tracks.audio
        .map((e) => Subtitle(index: e.id, mediaType: MediaType.local, name: e.title ?? e.id))
        .toList();
    return parsedSubtitiles;
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> setSubtitle(Subtitle subtitle) {
    final track = controller.state.tracks.subtitle.firstWhere((e) => e.id == subtitle.index);
    controller.setSubtitleTrack(track);
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
  Future<List<AudioTrack>> getAudioTracks() async {
    final parsedAudioTracks = controller.state.tracks.audio
        .map((e) => AudioTrack(index: e.id, mediaType: MediaType.local, name: e.title ?? e.id))
        .toList();
    return Future.value(parsedAudioTracks);
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  @override
  Future<void> setAudioTrack(AudioTrack audioTrack) {
    final track = controller.state.tracks.audio.firstWhere((e) => e.id == audioTrack.index);
    controller.setAudioTrack(track);
    return Future.value();
  }

  @override
  BehaviorSubject<Duration> getPositionStream() {
    final streamController = BehaviorSubject<Duration>();
    final subscription = controller.streams.position.listen((event) {});
    subscription.onData((data) {
      streamController.add(data);
    });
    return streamController;
  }

  @override
  BehaviorSubject<Duration> getDurationStream() {
    final streamController = BehaviorSubject<Duration>();
    final subscription = controller.streams.duration.listen((event) {});
    subscription.onData((data) {
      streamController.add(data);
    });
    return streamController;
  }

  @override
  BehaviorSubject<bool> getPlayingStateStream() {
    final streamController = BehaviorSubject<bool>();
    final subscription = controller.streams.playing.listen((event) {});
    subscription.onData((data) {
      streamController.add(data);
    });
    return streamController;
  }

  @override
  Duration? getCurrentPosition() => controller.state.position;

  @override
  Duration? getDuration() => controller.state.duration;

  @override
  Future<bool> hasPip() => Future.value(false);

  @override
  bool isInit() => true;

  @override
  bool isPlaying() => controller.state.playing;

  @override
  Future<void> pause() => controller.pause();

  @override
  Future<void>? pip() => Future.value(false);

  @override
  Future<void> play() => controller.play();

  @override
  Future<void> seekTo(Duration duration) => controller.seek(duration);

  @override
  Future<void> dispose() async {
    return Future.microtask(() async {
      // Release allocated resources back to the system.
      await controller.pause();
      await controller.dispose();
    });
  }
}
