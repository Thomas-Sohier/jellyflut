import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:dart_vlc/dart_vlc.dart';
import 'package:jellyflut/screens/musicPlayer/CommonPlayer/common_player_just_audio.dart';
import 'package:jellyflut/screens/musicPlayer/CommonPlayer/common_player_audioplayers.dart';
import 'package:jellyflut/screens/musicPlayer/CommonPlayer/common_player_vlc.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:rxdart/rxdart.dart';

class CommonPlayer {
  final Function _pause;
  final Function _play;
  final Function _isPlaying;
  final Function(Duration) _seekTo;
  final Function _bufferingDuration;
  final Function _duration;
  final Function _nextTrack;
  final Function _previousTrack;
  final Function _currentPosition;
  final BehaviorSubject<Duration> _positionStream;
  final BehaviorSubject<Duration> _durationStream;
  final BehaviorSubject<bool> _isPlayingStream;
  final Future<void> Function() _dispose;
  dynamic controller;

  CommonPlayer._(
      {required pause,
      required play,
      required isPlaying,
      required seekTo,
      required bufferingDuration,
      required duration,
      required nextTrack,
      required previousTrack,
      required currentPosition,
      required positionStream,
      required durationStream,
      required isPlayingStream,
      required dispose,
      required this.controller})
      : _play = play,
        _pause = pause,
        _isPlaying = isPlaying,
        _seekTo = seekTo,
        _bufferingDuration = bufferingDuration,
        _duration = duration,
        _nextTrack = nextTrack,
        _previousTrack = previousTrack,
        _currentPosition = currentPosition,
        _positionStream = positionStream,
        _durationStream = durationStream,
        _isPlayingStream = isPlayingStream,
        _dispose = dispose;

  void play() => _play();
  void pause() => _pause();
  bool isPlaying() => _isPlaying();
  void seekTo(Duration duration) => _seekTo(duration);
  Duration getBufferingDuration() => _bufferingDuration();
  Duration? getDuration() => _duration();
  void nextTrack() => _nextTrack();
  void previousTrack() => _previousTrack();
  Duration getCurrentPosition() => _currentPosition();
  BehaviorSubject<Duration> getPositionStream() => _positionStream;
  BehaviorSubject<Duration> getDurationStream() => _durationStream;
  BehaviorSubject<bool> getPlayingStateStream() => _isPlayingStream;
  Future<void> disposeStream() => _dispose();

  static CommonPlayer parseJustAudioController(
      {required just_audio.AudioPlayer audioPlayer}) {
    final commonPlayerJustAudio =
        CommonPlayerJustAudio(audioPlayer: audioPlayer);
    return CommonPlayer._(
        pause: audioPlayer.pause,
        play: audioPlayer.play,
        isPlaying: audioPlayer.playerState.playing,
        seekTo: audioPlayer.seek,
        duration: audioPlayer.duration,
        nextTrack: audioPlayer.seekToPrevious,
        previousTrack: audioPlayer.seekToNext,
        bufferingDuration: audioPlayer.durationStream,
        currentPosition: audioPlayer.position,
        positionStream: audioPlayer.positionStream,
        durationStream: audioPlayer.durationStream,
        isPlayingStream: commonPlayerJustAudio.playingStateStream,
        dispose: audioPlayer.dispose,
        controller: audioPlayer);
  }

  static CommonPlayer parseAudioplayerController(
      {required audioplayers.AudioPlayer audioPlayer}) {
    final commonPlayerAudioplayers =
        CommonPlayerAudioplayers(audioPlayer: audioPlayer);
    return CommonPlayer._(
        pause: audioPlayer.pause,
        play: audioPlayer.play,
        isPlaying: audioPlayer.state == audioplayers.PlayerState.playing,
        seekTo: audioPlayer.seek,
        duration: audioPlayer.getDuration,
        nextTrack: () => {},
        previousTrack: () => {},
        bufferingDuration: () => {},
        currentPosition: audioPlayer.getCurrentPosition(),
        positionStream: audioPlayer.onPositionChanged,
        durationStream: audioPlayer.onDurationChanged,
        isPlayingStream: commonPlayerAudioplayers.playingStateStream,
        dispose: audioPlayer.dispose,
        controller: audioPlayer);
  }

  static CommonPlayer parseVLCController({required Player audioPlayer}) {
    final commonPlayerVLC = CommonPlayerVLC(audioPlayer: audioPlayer);
    return CommonPlayer._(
        pause: audioPlayer.pause,
        play: audioPlayer.play,
        isPlaying: audioPlayer.playback.isPlaying,
        seekTo: audioPlayer.seek,
        duration: audioPlayer.position.duration,
        nextTrack: audioPlayer.previous,
        previousTrack: audioPlayer.next,
        bufferingDuration: () => Duration(seconds: 0),
        currentPosition: () => audioPlayer.position.position,
        positionStream: commonPlayerVLC.positionStream(),
        durationStream: commonPlayerVLC.durationStream(),
        isPlayingStream: commonPlayerVLC.playingStateStream(),
        dispose: commonPlayerVLC.stopPlayer,
        controller: audioPlayer);
  }
}
