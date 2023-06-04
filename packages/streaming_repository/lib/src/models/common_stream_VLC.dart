import 'dart:async';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:rxdart/rxdart.dart';

import '../models/index.dart';

class CommonStreamVLC extends CommonStream<VlcPlayerController> {
  CommonStreamVLC.fromUri({required Uri uri, Duration? startAtPosition}) {
    controller = _initController(uri: uri, startAtPosition: startAtPosition);
  }

  static VlcPlayerController _initController({required Uri uri, Duration? startAtPosition}) {
    late final VlcPlayerController controller;
    if (uri.isScheme('http') || uri.isScheme('https')) {
      controller = VlcPlayerController.network(
        uri.toString(),
        autoPlay: false,
        autoInitialize: false,
        options: _defaultOptions(startAtPosition),
      );
    } else {
      controller = VlcPlayerController.file(
        File(uri.toFilePath()),
        autoPlay: false,
        autoInitialize: false,
        options: _defaultOptions(startAtPosition),
      );
    }
    return controller;
  }

  static VlcPlayerOptions _defaultOptions(Duration? startAtPosition) {
    return VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          // VlcSubtitleOptions.fontSize(26),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.black),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.white),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
        extras: [
          '--start-time=${startAtPosition?.inSeconds ?? 0}' // Start at x seconds
        ]);
  }

  void listener() async {
    controller.addOnInitListener(() async {
      await controller.startRendererScanning();
    });
    if (controller.value.isInitialized) print('init');
  }

  @override
  Future<void> initialize() async {
    // FIXME vlcplayer is broken if we try to initialize ourselves, it need to be in it's view
    // We cannot init from domain layer
    // [isReadyToInitialize] is always null until we call play()...

    if (controller.isReadyToInitialize ?? false) return controller.initialize();
    final completer = Completer<void>();
    final timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if ((controller.isReadyToInitialize ?? false) && !controller.value.isInitialized && !completer.isCompleted) {
        completer.complete();
      }
    });
    await completer.future;
    timer.cancel();
    return controller.initialize();
  }

  @override
  Widget createView() {
    return VlcPlayer(
      controller: controller,
      aspectRatio: 16 / 9,
      placeholder: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Future<bool> isFullscreen() {
    return Future.value(true);
  }

  @override
  BehaviorSubject<bool> getPlayingStateStream() {
    final streamController = BehaviorSubject<bool>();
    controller.addListener(() => streamController.add(controller.value.isPlaying));
    return streamController;
  }

  @override
  Duration? getCurrentPosition() => controller.value.position;

  @override
  BehaviorSubject<Duration> getPositionStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.addListener(() {
      streamController.add(controller.value.position);
    });
    return streamController;
  }

  @override
  Duration? getDuration() => controller.value.duration;

  @override
  BehaviorSubject<Duration> getDurationStream() {
    final streamController = BehaviorSubject<Duration>();
    controller.addListener(() {
      streamController.add(controller.value.duration);
    });
    return streamController;
  }

  @override
  Duration? getBufferingDuration() {
    final durationCurrentFile = controller.value.duration;
    final totalMilliseconds = durationCurrentFile.inMilliseconds;
    final currentBufferedMilliseconds = totalMilliseconds / controller.value.bufferPercent;
    return Duration(
        milliseconds: currentBufferedMilliseconds.isNaN || currentBufferedMilliseconds.isInfinite
            ? 0
            : currentBufferedMilliseconds.toInt());
  }

  @override
  Future<bool> hasPip() => Future.value(false);

  @override
  bool isInit() => controller.value.isInitialized;

  @override
  bool isPlaying() => controller.value.isPlaying;

  @override
  Future<void> pause() => controller.pause();

  @override
  Future<void>? pip() => throw UnimplementedError();

  @override
  Future<void> play() => controller.play();

  @override
  Future<void> seekTo(Duration duration) => controller.seekTo(duration);

  @override
  Future<List<AudioTrack>> getAudioTracks() async {
    // ignore: omit_local_variable_types
    final List<AudioTrack> parsedAudioTracks = [];
    final audioTracks = await controller.getAudioTracks();
    for (var i = 0; i < audioTracks.length; i++) {
      final audioTrackKey = audioTracks.keys.elementAt(i);
      parsedAudioTracks.add(AudioTrack(
        index: i.toString(),
        mediaType: MediaType.local,
        jellyfinSubtitleIndex: audioTrackKey,
        name: audioTracks[audioTrackKey] ?? 'Track $i',
      ));
    }
    return parsedAudioTracks;
  }

  @override
  Future<void> setAudioTrack(AudioTrack audioTrack) {
    return controller.setAudioTrack(audioTrack.jellyfinSubtitleIndex!);
  }

  @override
  Future<void> disableSubtitles() => controller.setSpuTrack(-1);

  @override
  Future<List<Subtitle>> getSubtitles() async {
    // ignore: omit_local_variable_types
    final List<Subtitle> parsedSubtitiles = [];
    final subtitles = await controller.getSpuTracks();
    for (var i = 0; i < subtitles.length; i++) {
      final subtitleKey = subtitles.keys.elementAt(i);
      parsedSubtitiles.add(Subtitle(
        index: subtitleKey.toString(),
        mediaType: MediaType.local,
        jellyfinSubtitleIndex: null,
        name: subtitles[subtitleKey] ?? 'Track $i',
      ));
    }
    return parsedSubtitiles;
  }

  @override
  Future<void> setSubtitle(Subtitle subtitle) => controller.setSpuTrack(int.parse(subtitle.index));

  @override
  Future<void> dispose() async {
    await controller.stop();
    return await controller.dispose();
  }
}
