import 'package:flutter/foundation.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:rxdart/rxdart.dart';
import './stream_controller/stream_controller.dart.dart' as impl;

class CommonStream {
  final Function _pause;
  final Function _play;
  final Function _isPlaying;
  final Function(Duration) _seekTo;
  final Function _bufferingDuration;
  final Function _duration;
  final Function _currentPosition;
  final bool _isInit;
  final Function _pip;
  final Future<bool> _hasPip;
  final Function _getSubtitles;
  final Function(Subtitle) _setSubtitle;
  final VoidCallback _disableSubtitles;
  final Function _getAudioTracks;
  final VoidCallback _enterFullscreen;
  final VoidCallback _exitFullscreen;
  final VoidCallback _toggleFullscreen;
  final Function(AudioTrack) _setAudioTrack;
  final BehaviorSubject<Duration> _positionStream;
  final BehaviorSubject<Duration> _durationStream;
  final BehaviorSubject<bool> _isPlayingStream;
  final VoidCallback _initListener;
  final Future<void> Function() _dispose;
  dynamic controller;

  CommonStream(
      {required pause,
      required play,
      required isPlaying,
      required seekTo,
      required bufferingDuration,
      required duration,
      required currentPosition,
      required isInit,
      required pip,
      required hasPip,
      required getSubtitles,
      required enterFullscreen,
      required exitFullscreen,
      required toggleFullscreen,
      required setSubtitle,
      required disableSubtitles,
      required getAudioTracks,
      required setAudioTrack,
      required positionStream,
      required durationStream,
      required isPlayingStream,
      required initListener,
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
        _hasPip = hasPip,
        _getSubtitles = getSubtitles,
        _setSubtitle = setSubtitle,
        _disableSubtitles = disableSubtitles,
        _enterFullscreen = enterFullscreen,
        _exitFullscreen = exitFullscreen,
        _toggleFullscreen = toggleFullscreen,
        _getAudioTracks = getAudioTracks,
        _setAudioTrack = setAudioTrack,
        _positionStream = positionStream,
        _durationStream = durationStream,
        _isPlayingStream = isPlayingStream,
        _initListener = initListener,
        _dispose = dispose;

  void play() => _play();
  void pause() => _pause();
  bool isPlaying() => _isPlaying();
  void seekTo(Duration duration) => _seekTo(duration);
  Duration getBufferingDuration() => _bufferingDuration();
  Duration? getDuration() => _duration();
  Duration getCurrentPosition() => _currentPosition();
  bool isInit() => _isInit;
  Future<bool> hasPip() => _hasPip;
  void pip() => _pip();
  void enterFullscreen() => _enterFullscreen();
  void exitFullscreen() => _exitFullscreen();
  void toggleFullscreen() => _toggleFullscreen();
  Future<List<Subtitle>> getSubtitles() => _getSubtitles();
  void setSubtitle(Subtitle subtitle) => _setSubtitle(subtitle);
  void disableSubtitles() => _disableSubtitles();
  Future<List<AudioTrack>> getAudioTracks() => _getAudioTracks();
  void setAudioTrack(AudioTrack audioTrack) => _setAudioTrack(audioTrack);
  BehaviorSubject<Duration> getPositionStream() => _positionStream;
  BehaviorSubject<Duration> getDurationStream() => _durationStream;
  BehaviorSubject<bool> getPlayingStateStream() => _isPlayingStream;
  void initListener() => _initListener();
  Future<void> disposeStream() => _dispose();

  static CommonStream parse(dynamic controller) {
    return impl.parse(controller);
  }
}
