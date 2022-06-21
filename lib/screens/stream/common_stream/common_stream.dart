import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:rxdart/rxdart.dart';

import './stream_controller/stream_controller.dart.dart' as impl;

class CommonStream {
  final Future<void> Function() _pause;
  final Future<void> Function() _play;
  final bool Function() _isPlaying;
  final Future<void> Function(Duration) _seekTo;
  final Duration? Function() _bufferingDuration;
  final Duration? Function() _duration;
  final Duration? Function() _currentPosition;
  final bool Function() _isInit;
  final Future<void>? Function() _pip;
  final Future<bool> _hasPip;
  final Future<List<Subtitle>> Function() _getSubtitles;
  final Future<void> Function(Subtitle) _setSubtitle;
  final Future<void> Function() _disableSubtitles;
  final Future<List<AudioTrack>> Function() _getAudioTracks;
  final void Function() _enterFullscreen;
  final void Function() _exitFullscreen;
  final void Function() _toggleFullscreen;
  final Future<void> Function(AudioTrack) _setAudioTrack;
  final BehaviorSubject<Duration> _positionStream;
  final BehaviorSubject<Duration> _durationStream;
  final BehaviorSubject<bool> _isPlayingStream;
  final Future<void> Function() _dispose;
  dynamic controller;

  CommonStream(
      {required Future<void> Function() pause,
      required Future<void> Function() play,
      required bool Function() isPlaying,
      required Future<void> Function(Duration) seekTo,
      required Duration? Function() bufferingDuration,
      required Duration? Function() duration,
      required Duration? Function() currentPosition,
      required bool Function() isInit,
      required Future<void>? Function() pip,
      required Future<bool> hasPip,
      required Future<List<Subtitle>> Function() getSubtitles,
      required Future<void> Function(Subtitle) setSubtitle,
      required Future<void> Function() disableSubtitles,
      required void Function() enterFullscreen,
      required void Function() exitFullscreen,
      required void Function() toggleFullscreen,
      required Future<List<AudioTrack>> Function() getAudioTracks,
      required Future<void> Function(AudioTrack) setAudioTrack,
      required BehaviorSubject<Duration> positionStream,
      required BehaviorSubject<Duration> durationStream,
      required BehaviorSubject<bool> isPlayingStream,
      required Future<void> Function() dispose,
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
        _dispose = dispose;

  Future<void> play() => _play();
  Future<void> pause() => _pause();
  bool isPlaying() => _isPlaying();
  Future<void> seekTo(Duration duration) => _seekTo(duration);
  Duration? getBufferingDuration() => _bufferingDuration() ?? Duration.zero;
  Duration? getDuration() => _duration();
  Duration? getCurrentPosition() => _currentPosition() ?? Duration.zero;
  bool isInit() => _isInit();
  Future<bool> hasPip() => _hasPip;
  Future<void>? pip() => _pip();
  void enterFullscreen() => _enterFullscreen();
  void exitFullscreen() => _exitFullscreen();
  void toggleFullscreen() => _toggleFullscreen();
  Future<List<Subtitle>> getSubtitles() => _getSubtitles();
  Future<void> setSubtitle(Subtitle subtitle) => _setSubtitle(subtitle);
  Future<void> disableSubtitles() => _disableSubtitles();
  Future<List<AudioTrack>> getAudioTracks() => _getAudioTracks();
  Future<void> setAudioTrack(AudioTrack audioTrack) =>
      _setAudioTrack(audioTrack);
  BehaviorSubject<Duration> getPositionStream() => _positionStream;
  BehaviorSubject<Duration> getDurationStream() => _durationStream;
  BehaviorSubject<bool> getPlayingStateStream() => _isPlayingStream;
  Future<void> dispose() => _dispose();

  static CommonStream parse(dynamic controller) {
    return impl.parse(controller);
  }
}
