import 'package:media_kit/media_kit.dart';
import 'package:rxdart/rxdart.dart';

import 'audio_source.dart';
import 'common_player_vlc.dart';

class CommonPlayer {
  final void Function() _pause;
  final void Function() _play;
  final bool _isPlaying;
  final void Function(Duration) _seekTo;
  final Stream<Duration?> _bufferingDuration;
  final Duration? Function() _duration;
  final void Function() _init;
  final void Function() _nextTrack;
  final void Function() _previousTrack;
  final Future<void> Function(AudioSource) _playRemote;
  final Duration? Function() _currentPosition;
  final BehaviorSubject<Duration?> _positionStream;
  final BehaviorSubject<Duration?> _durationStream;
  final BehaviorSubject<bool?> _isPlayingStream;
  final Future<void> Function() _dispose;
  dynamic controller;

  CommonPlayer._(
      {required void Function() pause,
      required void Function() play,
      required bool Function() isPlaying,
      required void Function(Duration) seekTo,
      required Stream<Duration?> bufferingDuration,
      required Duration? Function() duration,
      required void Function() init,
      required void Function() nextTrack,
      required void Function() previousTrack,
      required Future<void> Function(AudioSource) playRemote,
      required Duration? Function() currentPosition,
      required BehaviorSubject<Duration?> positionStream,
      required BehaviorSubject<Duration?> durationStream,
      required BehaviorSubject<bool?> isPlayingStream,
      required Future<void> Function() dispose,
      required this.controller})
      : _play = play,
        _pause = pause,
        _isPlaying = isPlaying(),
        _seekTo = seekTo,
        _bufferingDuration = bufferingDuration,
        _duration = duration,
        _init = init,
        _nextTrack = nextTrack,
        _previousTrack = previousTrack,
        _playRemote = playRemote,
        _currentPosition = currentPosition,
        _positionStream = positionStream,
        _durationStream = durationStream,
        _isPlayingStream = isPlayingStream,
        _dispose = dispose;

  void play() => _play();
  void pause() => _pause();
  bool isPlaying() => _isPlaying;
  void seekTo(Duration duration) => _seekTo(duration);
  Stream<Duration?> getBufferingDuration() => _bufferingDuration;
  Duration? get getDuration => _duration();
  void init() => _init();
  void nextTrack() => _nextTrack();
  void previousTrack() => _previousTrack();
  Future<void> playRemote(AudioSource audioSource) => _playRemote(audioSource);
  Duration? get getCurrentPosition => _currentPosition();
  BehaviorSubject<Duration?> get getPositionStream => _positionStream;
  BehaviorSubject<Duration?> get getDurationStream => _durationStream;
  BehaviorSubject<bool?> get getPlayingStateStream => _isPlayingStream;
  Future<void> dispose() => _dispose();

  static CommonPlayer parseMediaKitController({required Player audioPlayer}) {
    final commonPlayerVLC = MediaKitAudio(audioPlayer: audioPlayer);
    return CommonPlayer._(
        pause: audioPlayer.pause,
        play: audioPlayer.play,
        isPlaying: () => audioPlayer.state.playing,
        seekTo: audioPlayer.seek,
        duration: () => audioPlayer.state.duration,
        init: commonPlayerVLC.init,
        nextTrack: audioPlayer.next,
        previousTrack: audioPlayer.previous,
        bufferingDuration: audioPlayer.stream.buffer,
        playRemote: commonPlayerVLC.playRemote,
        currentPosition: () => audioPlayer.state.position,
        positionStream: commonPlayerVLC.positionStream(),
        durationStream: commonPlayerVLC.durationStream(),
        isPlayingStream: commonPlayerVLC.playingStateStream(),
        dispose: commonPlayerVLC.dispose,
        controller: audioPlayer);
  }
}
