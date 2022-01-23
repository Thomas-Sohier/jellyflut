import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart' as vlc;
// import 'package:libmpv/libmpv.dart' as mpv;
import 'package:flutter/foundation.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream_BP.dart';
// import 'package:jellyflut/screens/stream/CommonStream/common_stream_MPV.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream_VLC.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream_VLC_computer.dart';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:rxdart/rxdart.dart';

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
  bool? isInit() => _isInit;
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

  static CommonStream parseVLCController(
      {required VlcPlayerController vlcPlayerController,
      VoidCallback? listener}) {
    final commonStreamVLC =
        CommonStreamVLC(vlcPlayerController: vlcPlayerController);
    return CommonStream._(
        pause: vlcPlayerController.pause,
        play: vlcPlayerController.play,
        isPlaying: () => vlcPlayerController.value.isPlaying,
        seekTo: vlcPlayerController.seekTo,
        duration: () => vlcPlayerController.value.duration,
        bufferingDuration: commonStreamVLC.getBufferingDurationVLC,
        currentPosition: () => vlcPlayerController.value.position,
        isInit: vlcPlayerController.value.isInitialized,
        hasPip: Future.value(false),
        pip: () => throw ('Not supported on VLC player'),
        getSubtitles: commonStreamVLC.getSubtitles,
        setSubtitle: (subtitle) => commonStreamVLC.setSubtitle(subtitle),
        disableSubtitles: () => vlcPlayerController.setSpuTrack(-1),
        getAudioTracks: commonStreamVLC.getAudioTracks,
        setAudioTrack: (audioTrack) =>
            commonStreamVLC.setAudioTrack(audioTrack),
        positionStream: commonStreamVLC.positionStream(),
        durationStream: commonStreamVLC.durationStream(),
        isPlayingStream: commonStreamVLC.playingStateStream(),
        enterFullscreen: () => {},
        exitFullscreen: () => {},
        toggleFullscreen: () => {},
        initListener: () =>
            listener != null ? vlcPlayerController.addListener(listener) : {},
        dispose: commonStreamVLC.stopPlayer,
        controller: vlcPlayerController);
  }

  static CommonStream parseBetterPlayerController(
      {required BetterPlayerController betterPlayerController,
      VoidCallback? listener}) {
    final commonStreamBP =
        CommonStreamBP(betterPlayerController: betterPlayerController);
    return CommonStream._(
        pause: betterPlayerController.pause,
        play: betterPlayerController.play,
        isPlaying: () =>
            betterPlayerController.videoPlayerController!.value.isPlaying,
        seekTo: betterPlayerController.seekTo,
        duration: () =>
            betterPlayerController.videoPlayerController!.value.duration,
        bufferingDuration: commonStreamBP.getBufferingDurationBP,
        currentPosition: () =>
            betterPlayerController.videoPlayerController!.value.position,
        isInit: betterPlayerController.isVideoInitialized(),
        hasPip: betterPlayerController.isPictureInPictureSupported(),
        pip: () => betterPlayerController.enablePictureInPicture(
            betterPlayerController.betterPlayerGlobalKey!),
        getSubtitles: commonStreamBP.getSubtitles,
        setSubtitle: (subtitle) => commonStreamBP.setSubtitle(subtitle),
        disableSubtitles: betterPlayerController.subtitlesLines.clear,
        getAudioTracks: commonStreamBP.getAudioTracks,
        setAudioTrack: (audioTrack) => commonStreamBP.setAudioTrack(audioTrack),
        positionStream: commonStreamBP.positionStream(),
        durationStream: commonStreamBP.durationStream(),
        isPlayingStream: commonStreamBP.playingStateStream(),
        enterFullscreen: () => {},
        exitFullscreen: () => {},
        toggleFullscreen: () => {},
        initListener: () => listener != null
            ? betterPlayerController.videoPlayerController!
                .addListener(listener)
            : {},
        dispose: commonStreamBP.stopPlayer,
        controller: betterPlayerController);
  }

  static CommonStream parseVlcComputerController(
      {required vlc.Player player, VoidCallback? listener}) {
    final commonStreamVLCComputer = CommonStreamVLCComputer(player: player);
    return CommonStream._(
        pause: player.pause,
        play: player.play,
        isPlaying: () => player.playback.isPlaying,
        seekTo: player.seek,
        duration: () => player.position.duration,
        bufferingDuration: () => Duration(seconds: 0),
        currentPosition: () => player.position.position,
        isInit: true,
        hasPip: Future.value(false),
        pip: () => {},
        getSubtitles: () {
          // ignore: omit_local_variable_types
          final List<Subtitle> subtitles = [];
          return Future.value(subtitles);
        },
        setSubtitle: (_) => {},
        disableSubtitles: () => {},
        getAudioTracks: () {
          // ignore: omit_local_variable_types
          final List<AudioTrack> audioTracks = [];
          return Future.value(audioTracks);
        },
        enterFullscreen: commonStreamVLCComputer.enterFullscreen,
        exitFullscreen: commonStreamVLCComputer.exitFullscreen,
        toggleFullscreen: commonStreamVLCComputer.toggleFullscreen,
        setAudioTrack: (_) => {},
        positionStream: commonStreamVLCComputer.positionStream(),
        durationStream: commonStreamVLCComputer.durationStream(),
        isPlayingStream: commonStreamVLCComputer.playingStateStream(),
        initListener: () => {},
        dispose: commonStreamVLCComputer.stopPlayer,
        controller: player);
  }

  // static CommonStream parseMpvController({required mpv.Player mpvPlayer}) {
  //   final commonStreamMPV = CommonStreamMPV(mpvPlayer: mpvPlayer);
  //   return CommonStream._(
  //       pause: mpvPlayer.pause,
  //       play: mpvPlayer.play,
  //       isPlaying: () => mpvPlayer.state.isPlaying,
  //       seekTo: mpvPlayer.seek,
  //       duration: () => mpvPlayer.state.duration,
  //       bufferingDuration: () => Duration(seconds: 0),
  //       currentPosition: () => mpvPlayer.state.position,
  //       isInit: true,
  //       hasPip: Future.value(false),
  //       pip: () => {},
  //       getSubtitles: () {
  //         // ignore: omit_local_variable_types
  //         final List<Subtitle> subtitles = [];
  //         return Future.value(subtitles);
  //       },
  //       setSubtitle: (_) => {},
  //       disableSubtitles: () => {},
  //       getAudioTracks: () {
  //         // ignore: omit_local_variable_types
  //         final List<AudioTrack> audioTracks = [];
  //         return Future.value(audioTracks);
  //       },
  //       enterFullscreen: commonStreamMPV.enterFullscreen,
  //       exitFullscreen: commonStreamMPV.exitFullscreen,
  //       toggleFullscreen: commonStreamMPV.toggleFullscreen,
  //       setAudioTrack: (_) => {},
  //       positionStream: commonStreamMPV.positionStream(),
  //       durationStream: commonStreamMPV.durationStream(),
  //       isPlayingStream: commonStreamMPV.playingStateStream(),
  //       initListener: () => {},
  //       dispose: commonStreamMPV.stopPlayer,
  //       controller: mpvPlayer);
  // }
}
