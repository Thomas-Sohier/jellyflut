import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart' hide AudioSource;
import 'package:rxdart/rxdart.dart';

import 'models/audio_playlist.dart';
import 'models/audio_source.dart';
import 'models/common_player.dart';

/// Exception thrown when item request fails.
class InitFailure implements Exception {}

/// {@template music_player_api}
/// A dart API client for the music player API
/// {@endtemplate}
class MusicPlayerApi {
  /// {@macro music_player_api}
  MusicPlayerApi();

  AudioSource? _currentMusic;
  CommonPlayer? _commonPlayer;
  final _currentMusicStream = BehaviorSubject<AudioSource>();
  final _currentlyPlayingIndex = BehaviorSubject<int>();
  final _audioPlaylist = AudioPlaylist(playlist: <AudioSource>[]);

  Future<CommonPlayer> initPlayer() async {
    // If player already instanciated, return current instance
    if (_commonPlayer != null) {
      return Future.value(_commonPlayer);
    }

    // Use audio player depending of current platform
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isWindows || kIsWeb) {
      final player = AudioPlayer();
      _commonPlayer = CommonPlayer.parseJustAudioController(audioPlayer: player);
    } else if (Platform.isLinux) {
      final player = Player(id: 0);
      _commonPlayer = CommonPlayer.parseVLCController(audioPlayer: player);
    } else {
      throw UnimplementedError('No audio player on this platform');
    }

    if (_commonPlayer == null) {
      throw InitFailure();
    }

    // Notify that player is init
    _commonPlayer!.init();
    return _commonPlayer!;
  }

  Stream<int> playingIndex() {
    return _currentlyPlayingIndex;
  }

  AudioSource? getCurrentMusic() {
    return _currentMusic;
  }

  Stream<AudioSource> getCurrentMusicStream() {
    return _currentMusicStream;
  }

  void moveMusicItem(int oldIndex, int newIndex) {
    _audioPlaylist.move(oldIndex, newIndex);
    if (_currentMusic != null) {
      _currentlyPlayingIndex.add(_audioPlaylist.playlist.indexOf(_currentMusic!));
    }
  }

  void play() => _commonPlayer?.play();

  void pause() => _commonPlayer?.pause();

  Duration getDuration() => _commonPlayer?.getDuration ?? Duration.zero;

  BehaviorSubject<Duration?> getDurationStream() {
    return _commonPlayer?.getDurationStream ?? BehaviorSubject<Duration?>();
  }

  BehaviorSubject<Duration?> getPositionStream() {
    return _commonPlayer?.getPositionStream ?? BehaviorSubject.seeded(Duration.zero);
  }

  bool isPlaying() {
    return _commonPlayer?.isPlaying() ?? false;
  }

  Stream<bool?> isPlayingStream() {
    return _commonPlayer?.getPlayingStateStream ?? Stream.value(false);
  }

  void seekTo(Duration duration) {
    _commonPlayer!.seekTo(duration);
  }

  Future<void> playAtIndex(int index) async {
    final audioSource = _audioPlaylist.playlist[index];
    return _commonPlayer?.playRemote(audioSource).then((_) {
      setCurrentlyPlayingMusic(audioSource);
    });
  }

  List<AudioSource> getPlayList() {
    return _audioPlaylist.playlist;
  }

  AudioSource getItemFromPlaylist(int index) {
    return _audioPlaylist.playlist.elementAt(index);
  }

  /// insert audio source at end of playlist
  /// return index as int
  void addToPlaylist(AudioSource audioSource) {
    _audioPlaylist.add(audioSource);
  }

  /// insert all audio sources at end of playlist
  /// return index as int
  void addAllToPlaylist(List<AudioSource> audioSources) {
    _audioPlaylist.addAll(audioSources);
  }

  void deleteFromPlaylist(int index) {
    _audioPlaylist.removeAt(index);
  }

  Future<void> next() {
    if (_currentMusic == null) return Future.value();
    final nextIndex = _audioPlaylist.playlist.indexOf(_currentMusic!) + 1;
    if (nextIndex == _audioPlaylist.playlist.length) return Future.value();
    return playAtIndex(nextIndex);
  }

  Future<void> previous() {
    if (_currentMusic == null) return Future.value();
    final previousIndex = _audioPlaylist.playlist.indexOf(_currentMusic!) - 1;
    if (previousIndex < 0) return Future.value();
    return playAtIndex(previousIndex);
  }

  Future<void> reset() {
    _audioPlaylist.clear();
    // Prevent null handling
    return _commonPlayer?.dispose() ?? Future.value();
  }

  Future<void> playRemoteAudio(AudioSource audioSource) async {
    await initPlayer();
    _audioPlaylist.clear();
    _audioPlaylist.add(audioSource);
    return playAtIndex(0);
  }

  Future<void> playPlaylist(List<AudioSource> playlist) async {
    await initPlayer();
    _audioPlaylist.addAll(playlist);
    return playAtIndex(0);
  }

  void setCurrentlyPlayingMusic(AudioSource audioSource) {
    _currentMusic = audioSource;
    _currentMusicStream.add(audioSource);
    _currentlyPlayingIndex.add(_audioPlaylist.playlist.indexOf(audioSource));
  }
}
