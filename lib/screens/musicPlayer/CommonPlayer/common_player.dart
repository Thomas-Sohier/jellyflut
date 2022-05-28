import 'package:dart_vlc/dart_vlc.dart';
import 'package:jellyflut/screens/musicPlayer/CommonPlayer/common_player_just_audio.dart';
import 'package:jellyflut/screens/musicPlayer/CommonPlayer/common_player_mpv.dart';
import 'package:jellyflut/screens/musicPlayer/CommonPlayer/common_player_vlc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_mpv/src/mpv_player.dart' as mpv_player;
import 'package:rxdart/rxdart.dart';

class CommonPlayer {
  final Function _pause;
  final Function _play;
  final Function _isPlaying;
  final Function(Duration) _seekTo;
  final Function _bufferingDuration;
  final Function _duration;
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
  Duration getCurrentPosition() => _currentPosition();
  BehaviorSubject<Duration> getPositionStream() => _positionStream;
  BehaviorSubject<Duration> getDurationStream() => _durationStream;
  BehaviorSubject<bool> getPlayingStateStream() => _isPlayingStream;
  Future<void> disposeStream() => _dispose();

  static CommonPlayer parseJustAudioController(
      {required AudioPlayer audioPlayer}) {
    final commonPlayerJustAudio =
        CommonPlayerJustAudio(audioPlayer: audioPlayer);
    return CommonPlayer._(
        pause: audioPlayer.pause,
        play: audioPlayer.play,
        isPlaying: audioPlayer.playerState.playing,
        seekTo: audioPlayer.seek,
        duration: audioPlayer.duration,
        bufferingDuration: audioPlayer.durationStream,
        currentPosition: audioPlayer.position,
        positionStream: audioPlayer.positionStream,
        durationStream: audioPlayer.durationStream,
        isPlayingStream: commonPlayerJustAudio.playingStateStream,
        dispose: audioPlayer.dispose,
        controller: audioPlayer);
  }

  static CommonPlayer parseMPVController(
      {required mpv_player.JustAudioMPVPlayer audioPlayer}) {
    final commonPlayerMPV = CommonPlayerMPV(audioPlayer: audioPlayer);
    return CommonPlayer._(
        pause: audioPlayer.pause,
        play: audioPlayer.play,
        isPlaying: () => {},
        seekTo: commonPlayerMPV.seek,
        duration: () => {},
        bufferingDuration: () => {},
        currentPosition: () => {},
        positionStream: () => {},
        durationStream: () => {},
        isPlayingStream: commonPlayerMPV.playingStateStream,
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
        bufferingDuration: () => Duration(seconds: 0),
        currentPosition: () => audioPlayer.position.position,
        positionStream: commonPlayerVLC.positionStream(),
        durationStream: commonPlayerVLC.durationStream(),
        isPlayingStream: commonPlayerVLC.playingStateStream(),
        dispose: commonPlayerVLC.stopPlayer,
        controller: audioPlayer);
  }
}
