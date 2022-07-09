import 'dart:io';

import 'package:flutter/foundation.dart';

/// {@template music_player_api}
/// A dart API client for the music player API
/// {@endtemplate}
class MusicPlayerApi {
  /// {@macro music_player_api}
  const MusicPlayerApi({required ItemsRepository? itemsRepository}) : _itemsRepository = itemsRepository;

  AudioSource? _currentMusic;
  CommonPlayer? _commonPlayer;
  final _currentMusicStream = BehaviorSubject<AudioSource>();
  final _currentlyPlayingIndex = BehaviorSubject<int>();
  final _audioPlaylist = AudioPlaylist(audioSources: <AudioSource>[]);
  final _colorController = BehaviorSubject<AudioColors>(); // TODO move to music player BLoC
  final _itemsRepository;

  CommonPlayer initPlayer() async {
    // If player already instanciated, return current instance
    if (_commonPlayer != null) {
      return _commonPlayer;
    }

    // Use audio player depending of current platform
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isWindows || kIsWeb) {
      final player = just_audio.AudioPlayer();
      _commonPlayer = CommonPlayer.parseJustAudioController(audioPlayer: player);
    } else if (Platform.isLinux) {
      final player = Player(id: audioPlayerId, registerTexture: false);
      _commonPlayer = CommonPlayer.parseVLCController(audioPlayer: player);
    } else {
      final currentPlatform = Theme.of(customRouter.navigatorKey.currentContext!).platform;
      throw UnimplementedError('No audio player on this platform (platform : $currentPlatform');
    }

    // Notify that player is init
    _commonPlayer?.init();
    return _commonPlayer;
  }

  // TODO move to music player BLoC
  void setNewColors(final AudioColors audioColors) {
    final audiocolors = AudioColors(
        backgroundColor1: audioColors.backgroundColor1,
        backgroundColor2: audioColors.backgroundColor2,
        foregroundColor: audioColors.foregroundColor);
    _colorController.add(audiocolors);
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
      _currentlyPlayingIndex.add(_audioPlaylist.getPlaylist.indexOf(_currentMusic!));
    }
  }

  void play() {
    _commonPlayer?.play();
  }

  void pause() {
    _commonPlayer?.pause();
  }

  Duration getDuration() {
    return _commonPlayer?.getDuration ?? Duration.zero;
  }

  BehaviorSubject<Duration?> getDurationStream() {
    return _commonPlayer?.getDurationStream ?? BehaviorSubject<Duration?>();
  }

  Stream<Duration?> getPositionStream() {
    return _commonPlayer?.getPositionStream ?? Stream.value(Duration.zero);
  }

  Stream<bool?> isPlaying() {
    return _commonPlayer?.getPlayingStateStream ?? Stream.value(false);
  }

  void seekTo(Duration duration) {
    _commonPlayer!.seekTo(duration);
  }

  Future<void> playAtIndex(int index) async {
    final audioSource = _audioPlaylist.getPlaylist[index];
    return _commonPlayer?.playRemote(audioSource).then((_) {
      setCurrentlyPlayingMusic(audioSource);
    });
  }

  List<AudioSource> getPlayList() {
    return _audioPlaylist.getPlaylist;
  }

  AudioSource getItemFromPlaylist(int index) {
    return _audioPlaylist.getPlaylist.elementAt(index);
  }

  /// insert item at end of playlist
  /// return index as int
  void insertIntoPlaylist(AudioSource audioSource) {
    _audioPlaylist.insert(audioSource);
  }

  void deleteFromPlaylist(int index) {
    _audioPlaylist.removeAt(index);
  }

  Future<void> next() {
    if (_currentMusic == null) return Future.value();
    final nextIndex = _audioPlaylist.getPlaylist.indexOf(_currentMusic!) + 1;
    if (nextIndex == _audioPlaylist.getPlaylist.length) return Future.value();
    return playAtIndex(nextIndex);
  }

  void previous() {
    if (_currentMusic == null) return;
    final previousIndex = _audioPlaylist.getPlaylist.indexOf(_currentMusic!) - 1;
    if (previousIndex < 0) return;
    playAtIndex(previousIndex);
  }

  void reset() {
    _isInit = false;
    _audioPlaylist.clear();
    _commonPlayer?.dispose();
  }

  Future<void> playRemoteAudio(Item item) async {
    initPlayer();
    final streamURL = await item.getItemURL();
    final audioSource = await AudioMetadata.parseFromItem(streamURL, item);
    _audioPlaylist.clear();
    _audioPlaylist.insert(audioSource);
    return playAtIndex(0);
  }

  Future<void> playPlaylist(Item item) async {
    initPlayer();
    await _itemsRepository.getItems(parentId: item.id).then((value) async {
      final indexToReturn = _audioPlaylist.getPlaylist.length;
      final items = value.items.where((item) => item.isFolder == false).toList();
      //items.sort((a, b) => a.indexNumber!.compareTo(b.indexNumber!));
      for (var index = 0; index < items.length; index++) {
        final item = items.elementAt(index);
        final streamURL = await StreamingService.contructAudioURL(itemId: item.id);
        final musicItem = await AudioMetadata.parseFromItem(streamURL, item);
        insertIntoPlaylist(musicItem);
      }
      return indexToReturn;
    }).then((int index) => playAtIndex(index));
  }

  void setCurrentlyPlayingMusic(AudioSource audioSource) {
    _currentMusic = audioSource;
    _currentMusicStream.add(audioSource);
    _currentlyPlayingIndex.add(_audioPlaylist.getPlaylist.indexOf(audioSource));
  }
}
