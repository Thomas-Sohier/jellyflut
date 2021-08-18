import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dart_vlc/dart_vlc.dart' as vlc;
import 'package:flutter/foundation.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/commonPlayerAssetsAudioPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/commonPlayerVLCComputer.dart';
import 'package:jellyflut/screens/musicPlayer/models/musicItem.dart';
import 'package:rxdart/rxdart.dart';

void insertIntoPlaylist(
    int index, MusicItem musicItem, AssetsAudioPlayer assetsAudioPlayer) {
  assetsAudioPlayer.playlist!.insert(index, Audio.network(musicItem.url ?? ''));
}

void removeFromPlaylist(int index, AssetsAudioPlayer assetsAudioPlayer) {
  assetsAudioPlayer.playlist!.removeAtIndex(index);
}

class CommonPlayer {
  final VoidCallback _pause;
  final VoidCallback _play;
  final BehaviorSubject<bool> _isPlaying;
  final Function(Duration) _seekTo;
  final VoidCallback _previous;
  final VoidCallback _next;
  final Function(int) _playAtIndex;
  final Function _bufferingDuration;
  final Function _duration;
  final Function _insertIntoPlaylist;
  final Function _removeFromPlaylist;
  final Stream<Duration?> _currentPosition;
  final BehaviorSubject<int?> _listenPlayingindex;
  final BehaviorSubject<bool> _isInitStream;
  final Function(Item) _playRemoteAudio;
  final Function _isInit;
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
      required insertIntoPlaylist,
      required removeFromPlaylist,
      required currentPosition,
      required listenPlayingindex,
      required isInitStream,
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
        _insertIntoPlaylist = insertIntoPlaylist,
        _removeFromPlaylist = removeFromPlaylist,
        _currentPosition = currentPosition,
        _listenPlayingindex = listenPlayingindex,
        _isInitStream = isInitStream,
        _playRemoteAudio = playRemoteAudio,
        _isInit = isInit,
        _dispose = dispose;

  void play() => _play();
  void pause() => _pause();
  BehaviorSubject<bool> isPlaying() => _isPlaying;
  void seekTo(Duration duration) => _seekTo(duration);
  void next() => _next();
  void previous() => _previous();
  void playAtIndex(int index) => _playAtIndex(index);
  Duration getBufferingDuration() => _bufferingDuration();
  Duration getDuration() => _duration();
  void insertIntoPlaylist(int index, MusicItem musicItem) =>
      _insertIntoPlaylist(index, musicItem);
  void removeFromPlaylist(int index) => _removeFromPlaylist(index);
  Stream<Duration?> getCurrentPosition() => _currentPosition;
  BehaviorSubject<int?> listenPlayingindex() => _listenPlayingindex;
  BehaviorSubject<bool> listenIsPlaying() => _isInitStream;
  Future<void> playRemoteAudio(Item item) => _playRemoteAudio(item);
  bool isInit() => _isInit();
  void disposeStream() => _dispose();

  static CommonPlayer parseAssetsAudioPlayer(
      {required AssetsAudioPlayer assetsAudioPlayer}) {
    final commonPlayerAssetsAudioPlayer = CommonPlayerAssetsAudioPlayer();
    return CommonPlayer._(
        pause: assetsAudioPlayer.pause,
        play: assetsAudioPlayer.play,
        isPlaying: commonPlayerAssetsAudioPlayer.isPlaying(assetsAudioPlayer),
        seekTo: assetsAudioPlayer.seek,
        next: assetsAudioPlayer.next,
        previous: assetsAudioPlayer.previous,
        playAtIndex: (int index) =>
            assetsAudioPlayer.playlistPlayAtIndex(index),
        duration: () => assetsAudioPlayer.current.value!.audio.duration,
        bufferingDuration: () => Duration(seconds: 0),
        insertIntoPlaylist: (int index, MusicItem musicItem) =>
            commonPlayerAssetsAudioPlayer.insertIntoPlaylist(
                index, musicItem, assetsAudioPlayer),
        removeFromPlaylist: (int index) => commonPlayerAssetsAudioPlayer
            .removeFromPlaylist(index, assetsAudioPlayer),
        currentPosition: assetsAudioPlayer.currentPosition.asBroadcastStream(),
        listenPlayingindex:
            commonPlayerAssetsAudioPlayer.listenPlayingIndex(assetsAudioPlayer),
        isInitStream:
            commonPlayerAssetsAudioPlayer.isPlaying(assetsAudioPlayer),
        playRemoteAudio: (Item item) => commonPlayerAssetsAudioPlayer
            .playRemoteAudio(assetsAudioPlayer, item),
        isInit: () => commonPlayerAssetsAudioPlayer.isInit(assetsAudioPlayer),
        dispose: () => assetsAudioPlayer.dispose(),
        controller: assetsAudioPlayer);
  }

  static CommonPlayer parseVlcComputerController({required vlc.Player player}) {
    final commonPlayerVLCComputer = CommonPlayerVLCComputer();
    return CommonPlayer._(
        pause: player.pause,
        play: player.play,
        isPlaying: commonPlayerVLCComputer.isPlaying(player),
        seekTo: player.seek,
        previous: player.back,
        next: player.next,
        playAtIndex: (int index) =>
            commonPlayerVLCComputer.playAtIndex(index, player),
        duration: () => player.position.duration,
        bufferingDuration: () => Duration(seconds: 0),
        insertIntoPlaylist: (int index, MusicItem musicItem) =>
            commonPlayerVLCComputer.insertIntoPlaylist(
                index, musicItem, player),
        removeFromPlaylist: (int index) =>
            commonPlayerVLCComputer.removeFromPlaylist(index, player),
        currentPosition: commonPlayerVLCComputer.getPosition(player),
        listenPlayingindex: commonPlayerVLCComputer.listenPlayingIndex(player),
        playRemoteAudio: (Item item) =>
            commonPlayerVLCComputer.playRemoteAudio(item, player),
        isInit: () => true,
        isInitStream: commonPlayerVLCComputer.isPlaying(player),
        dispose: () {
          player.stop();
          Future.delayed(Duration(milliseconds: 200), player.dispose);
        },
        controller: player);
  }
}
