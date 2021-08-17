import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamBP.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLC.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLCComputer.dart';
import 'package:jellyflut/screens/stream/model/audiotrack.dart';
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
  final Function(AudioTrack) _setAudioTrack;
  final BehaviorSubject<Duration> _positionStream;
  final BehaviorSubject<Duration> _durationStream;
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
      required hasPip,
      required getSubtitles,
      required setSubtitle,
      required disableSubtitles,
      required getAudioTracks,
      required setAudioTrack,
      required positionStream,
      required durationStream,
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
        _hasPip = hasPip,
        _getSubtitles = getSubtitles,
        _setSubtitle = setSubtitle,
        _disableSubtitles = disableSubtitles,
        _getAudioTracks = getAudioTracks,
        _setAudioTrack = setAudioTrack,
        _positionStream = positionStream,
        _durationStream = durationStream,
        _initListener = initListener,
        _addListener = addListener,
        _removeListener = removeListener,
        _dispose = dispose;

  void play() => _play();
  void pause() => _pause();
  bool isPlaying() => _isPlaying();
  void seekTo(Duration duration) => _seekTo(duration);
  Duration getBufferingDuration() => _bufferingDuration();
  Duration getDuration() => _duration();
  Duration getCurrentPosition() => _currentPosition();
  bool? isInit() => _isInit;
  Future<bool> hasPip() => _hasPip;
  void pip() => _pip();
  Future<List<Subtitle>> getSubtitles() => _getSubtitles();
  void setSubtitle(Subtitle subtitle) => _setSubtitle(subtitle);
  void disableSubtitles() => _disableSubtitles();
  Future<List<AudioTrack>> getAudioTracks() => _getAudioTracks();
  void setAudioTrack(AudioTrack audioTrack) => _setAudioTrack(audioTrack);
  BehaviorSubject<Duration> getPositionStream() => _positionStream;
  BehaviorSubject<Duration> getDurationStream() => _durationStream;
  void initListener() => _initListener();
  void addListener(VoidCallback listener) => _addListener(listener);
  void removeListener(VoidCallback listener) => _removeListener(listener);
  void disposeStream() => _dispose();

  static CommonStream parseVLCController(
      {required VlcPlayerController vlcPlayerController,
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
        hasPip: Future.value(false),
        pip: () => throw ('Not supported on VLC player'),
        getSubtitles: () => CommonStreamVLC.getSubtitles(vlcPlayerController),
        setSubtitle: (subtitle) =>
            CommonStreamVLC.setSubtitle(subtitle, vlcPlayerController),
        disableSubtitles: () => vlcPlayerController.setSpuTrack(-1),
        getAudioTracks: () =>
            CommonStreamVLC.getAudioTracks(vlcPlayerController),
        setAudioTrack: (audioTrack) =>
            CommonStreamVLC.setAudioTrack(audioTrack, vlcPlayerController),
        positionStream: CommonStreamVLC.positionStream(vlcPlayerController),
        durationStream: CommonStreamVLC.durationStream(vlcPlayerController),
        initListener: () => vlcPlayerController.addListener(listener),
        addListener: vlcPlayerController.addListener,
        removeListener: vlcPlayerController.removeListener,
        dispose: () {
          vlcPlayerController.stop();
          vlcPlayerController.dispose();
        },
        controller: vlcPlayerController);
  }

  static CommonStream parseBetterPlayerController(
      {required BetterPlayerController betterPlayerController,
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
        hasPip: betterPlayerController.isPictureInPictureSupported(),
        pip: () => betterPlayerController.enablePictureInPicture(
            betterPlayerController.betterPlayerGlobalKey!),
        getSubtitles: () => CommonStreamBP.getSubtitles(betterPlayerController),
        setSubtitle: (subtitle) =>
            CommonStreamBP.setSubtitle(subtitle, betterPlayerController),
        disableSubtitles: () => betterPlayerController.subtitlesLines.clear(),
        getAudioTracks: () =>
            CommonStreamBP.getAudioTracks(betterPlayerController),
        setAudioTrack: (audioTrack) =>
            CommonStreamBP.setAudioTrack(audioTrack, betterPlayerController),
        positionStream: CommonStreamBP.positionStream(betterPlayerController),
        durationStream: CommonStreamBP.durationStream(betterPlayerController),
        initListener: () =>
            betterPlayerController.videoPlayerController!.addListener(listener),
        addListener: betterPlayerController.videoPlayerController!.addListener,
        removeListener:
            betterPlayerController.videoPlayerController!.removeListener,
        dispose: () => betterPlayerController.dispose(),
        controller: betterPlayerController);
  }

  static CommonStream parseVlcComputerController(
      {required Player player, VoidCallback? listener}) {
    final commonStreamVLCComputer = CommonStreamVLCComputer();
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
        setAudioTrack: (_) => {},
        positionStream: commonStreamVLCComputer.positionStream(player),
        durationStream: commonStreamVLCComputer.durationStream(player),
        initListener: () => {},
        addListener: commonStreamVLCComputer.addListener,
        removeListener: (_) => commonStreamVLCComputer.removeListener(),
        dispose: () {
          player.stop();
          player.dispose();
        },
        controller: player);
  }
}
