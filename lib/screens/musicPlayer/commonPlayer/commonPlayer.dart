import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dart_vlc/dart_vlc.dart' as vlc;
import 'package:flutter/foundation.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/commonPlayerAssetsAudioPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/commonPlayerVLCComputer.dart';

class CommonPlayer {
  final VoidCallback _pause;
  final VoidCallback _play;
  final Function _isPlaying;
  final Function(Duration) _seekTo;
  final Function _previous;
  final Function _next;
  final Function(int) _playAtIndex;
  final Function _bufferingDuration;
  final Function _duration;
  final Stream<Duration?> _currentPosition;
  final Function(Item) _playRemoteAudio;
  final bool _isInit;
  final Function _dispose;
  final Object controller;

  CommonPlayer._(
      {required pause,
      required play,
      required isPlaying,
      required seekTo,
      required previous,
      required next,
      required playAtIndex,
      required bufferingDuration,
      required duration,
      required currentPosition,
      required playRemoteAudio,
      required isInit,
      required dispose,
      required this.controller})
      : _play = play,
        _pause = pause,
        _isPlaying = isPlaying,
        _seekTo = seekTo,
        _previous = previous,
        _next = next,
        _playAtIndex = playAtIndex,
        _bufferingDuration = bufferingDuration,
        _duration = duration,
        _currentPosition = currentPosition,
        _playRemoteAudio = playRemoteAudio,
        _isInit = isInit,
        _dispose = dispose;

  void play() => _play;
  void pause() => _pause;
  bool isPlaying() => _isPlaying();
  void seekTo(Duration duration) => _seekTo(duration);
  int next() => _next();
  int previous() => _previous();
  void playAtIndex(int index) => _playAtIndex(index);
  Duration getBufferingDuration() => _bufferingDuration();
  Duration getDuration() => _duration();
  Stream<Duration?> getCurrentPosition() => _currentPosition;
  Future<void> playRemoteAudio(Item item) => _playRemoteAudio(item);
  bool isInit() => _isInit;
  void disposeStream() => _dispose();

  static CommonPlayer parseAssetsAudioPlayer(
      {required AssetsAudioPlayer assetsAudioPlayer}) {
    return CommonPlayer._(
        pause: assetsAudioPlayer.pause,
        play: assetsAudioPlayer.play,
        isPlaying: () => assetsAudioPlayer.isPlaying,
        seekTo: assetsAudioPlayer.seek,
        next: assetsAudioPlayer.next,
        previous: assetsAudioPlayer.previous,
        playAtIndex: (int index) =>
            assetsAudioPlayer.playlistPlayAtIndex(index),
        duration: () => assetsAudioPlayer.current.value!.audio.duration,
        bufferingDuration: () => Duration(seconds: 0),
        currentPosition: assetsAudioPlayer.currentPosition,
        playRemoteAudio: (Item item) async => assetsAudioPlayer.open(
              await CommonPlayerAssetsAudioPlayer.createAudioNetwork(item),
              showNotification: true,
            ),
        isInit: true,
        dispose: () => assetsAudioPlayer.dispose(),
        controller: assetsAudioPlayer);
  }

  static CommonPlayer parseVlcComputerController({required vlc.Player player}) {
    final commonPlayerVLCComputer = CommonPlayerVLCComputer();
    return CommonPlayer._(
        pause: player.pause,
        play: player.play,
        isPlaying: () => player.playback.isPlaying,
        seekTo: player.seek,
        previous: () => commonPlayerVLCComputer.previous(player),
        next: () => commonPlayerVLCComputer.next(player),
        playAtIndex: (int index) =>
            commonPlayerVLCComputer.playAtIndex(index, player),
        duration: () => player.position.duration,
        bufferingDuration: () => Duration(seconds: 0),
        currentPosition: commonPlayerVLCComputer.getPosition(player),
        playRemoteAudio: (Item item) =>
            commonPlayerVLCComputer.playRemoteAudio(item, player),
        isInit: true,
        dispose: () {
          player.stop();
          Future.delayed(Duration(milliseconds: 200), player.dispose);
        },
        controller: player);
  }
}
