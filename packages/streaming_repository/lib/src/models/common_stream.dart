import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:window_manager/window_manager.dart';

import 'audio_track.dart';
import 'subtitle.dart';

@Immutable()
abstract class CommonStream<T> {
  late final T controller;
  final bool _isComputer = Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  CommonStream();

  CommonStream.fromUri({required Uri uri, int startAtPosition = 0});

  Future<void> play();
  Future<void> pause();
  bool isPlaying();
  Future<void> seekTo(Duration duration);
  Duration? getBufferingDuration();
  Duration? getDuration();
  Duration? getCurrentPosition();
  bool isInit();
  Future<bool> hasPip();
  Future<void>? pip();
  Future<void> initialize();
  Future<List<Subtitle>> getSubtitles();
  Future<void> setSubtitle(Subtitle subtitle);
  Future<void> disableSubtitles();
  Future<List<AudioTrack>> getAudioTracks();
  Future<void> setAudioTrack(AudioTrack audioTrack);
  BehaviorSubject<Duration> getPositionStream();
  BehaviorSubject<Duration> getDurationStream();
  BehaviorSubject<bool> getPlayingStateStream();
  Widget createView();
  Future<void> dispose();

  Future<bool> isFullscreen() async {
    if (!_isComputer) return Future.value(true); // fullscreen by default on handled devices
    final windowInstance = WindowManager.instance;
    return windowInstance.isFullScreen();
  }

  void enterFullscreen() async {
    if (!_isComputer) return; // fullscreen by default on handled devices
    final windowInstance = WindowManager.instance;
    await windowInstance.setFullScreen(true);
  }

  void exitFullscreen() async {
    if (!_isComputer) return; // fullscreen by default on handled devices
    final windowInstance = WindowManager.instance;
    await windowInstance.setFullScreen(false);
  }

  void toggleFullscreen() async {
    if (!_isComputer) return; // fullscreen by default on handled devices
    final windowInstance = WindowManager.instance;
    await windowInstance.isFullScreen().then((bool isFullscreen) => windowInstance.setFullScreen(!isFullscreen));
  }
}
