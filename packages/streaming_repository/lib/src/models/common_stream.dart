import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import 'audio_track.dart';
import 'subtitle.dart';

@Immutable()
abstract class CommonStream<T> {
  late final T controller;

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
  void enterFullscreen();
  void exitFullscreen();
  void toggleFullscreen();
  Future<bool> isFullscreen();
  Future<List<Subtitle>> getSubtitles();
  Future<void> setSubtitle(Subtitle subtitle);
  Future<void> disableSubtitles();
  Future<List<AudioTrack>> getAudioTracks();
  Future<void> setAudioTrack(AudioTrack audioTrack);
  BehaviorSubject<Duration> getPositionStream();
  BehaviorSubject<Duration> getDurationStream();
  BehaviorSubject<bool> getPlayingStateStream();
  Future<void> dispose();
}
