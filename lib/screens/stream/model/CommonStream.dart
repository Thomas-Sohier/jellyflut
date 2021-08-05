import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/stream/model/CommonStreamBP.dart';
import 'package:jellyflut/screens/stream/model/CommonStreamVLC.dart';

class CommonStream {
  final Function _pause;
  final Function _play;
  final Function _isPlaying;
  final Function(Duration) _seekTo;
  final Function _bufferingDuration;
  final Function _duration;
  final Function _currentPosition;
  final bool? _isInit;
  final Function _pip;
  final VoidCallback _initListener;
  final Function(VoidCallback) _addListener;
  final Function(VoidCallback) _removeListener;
  final Function _dispose;
  final Object controller;

  CommonStream._(
      {required pause,
      required play,
      required isPlaying,
      required seekTo,
      required bufferingDuration,
      required duration,
      required currentPosition,
      required isInit,
      required pip,
      required initListener,
      required addListener,
      required removeListener,
      required dispose,
      required this.controller})
      : _play = play,
        _pause = pause,
        _isPlaying = isPlaying,
        _seekTo = seekTo,
        _bufferingDuration = bufferingDuration,
        _duration = duration,
        _currentPosition = currentPosition,
        _isInit = isInit,
        _pip = pip,
        _initListener = initListener,
        _addListener = addListener,
        _removeListener = removeListener,
        _dispose = dispose;

  void play() {
    _play();
  }

  void pause() {
    _pause();
  }

  bool isPlaying() {
    return _isPlaying();
  }

  void seekTo(Duration duration) {
    _seekTo(duration);
  }

  Duration getBufferingDuration() {
    return _bufferingDuration();
  }

  Duration getDuration() {
    return _duration();
  }

  Duration getCurrentPosition() {
    return _currentPosition();
  }

  bool? isInit() {
    return _isInit;
  }

  void pip() {
    _pip();
  }

  void initListener() {
    _initListener();
  }

  void addListener(VoidCallback listener) {
    _addListener(listener);
  }

  void removeListener(VoidCallback listener) {
    _removeListener(listener);
  }

  void disposeStream() {
    _dispose();
  }

  static CommonStream parseVLCController(
      {required Item item,
      required VlcPlayerController vlcPlayerController,
      required VoidCallback listener}) {
    return CommonStream._(
        pause: vlcPlayerController.pause,
        play: vlcPlayerController.play,
        isPlaying: () => vlcPlayerController.value.isPlaying,
        seekTo: vlcPlayerController.seekTo,
        duration: () => vlcPlayerController.value.duration,
        bufferingDuration: () =>
            CommonStreamVLC.getBufferingDurationVLC(vlcPlayerController),
        currentPosition: () => vlcPlayerController.value.position,
        isInit: vlcPlayerController.value.isInitialized,
        pip: () => throw ('Not supported on VLC player'),
        initListener: () => vlcPlayerController.addListener(listener),
        addListener: vlcPlayerController.addListener,
        removeListener: vlcPlayerController.removeListener,
        dispose: () => vlcPlayerController.dispose(),
        controller: vlcPlayerController);
  }

  static CommonStream parseBetterPlayerController(
      {required Item item,
      required BetterPlayerController betterPlayerController,
      required VoidCallback listener}) {
    return CommonStream._(
        pause: betterPlayerController.pause,
        play: betterPlayerController.play,
        isPlaying: () =>
            betterPlayerController.videoPlayerController!.value.isPlaying,
        seekTo: betterPlayerController.seekTo,
        duration: () =>
            betterPlayerController.videoPlayerController!.value.duration,
        bufferingDuration: () =>
            CommonStreamBP.getBufferingDurationBP(betterPlayerController),
        currentPosition: () =>
            betterPlayerController.videoPlayerController!.value.position,
        isInit: betterPlayerController.isVideoInitialized(),
        pip: () => betterPlayerController.enablePictureInPicture(
            betterPlayerController.betterPlayerGlobalKey!),
        initListener: () =>
            betterPlayerController.videoPlayerController!.addListener(listener),
        addListener: betterPlayerController.videoPlayerController!.addListener,
        removeListener:
            betterPlayerController.videoPlayerController!.removeListener,
        dispose: () => betterPlayerController.dispose(),
        controller: betterPlayerController);
  }
}
