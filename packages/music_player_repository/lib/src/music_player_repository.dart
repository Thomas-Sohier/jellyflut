import 'dart:collection';

import 'package:music_player_api/music_player_api.dart';
import 'package:rxdart/rxdart.dart';

/// {@template music_player_repository}
/// A repository that handle music player
/// {@endtemplate}
class MusicPlayerRepository {
  /// {@macro music_player_repository}
  const MusicPlayerRepository({required MusicPlayerApi musicPlayerApi}) : _musicPlayerApi = musicPlayerApi;

  final MusicPlayerApi _musicPlayerApi;

  void initPlayer() => _musicPlayerApi.initPlayer();

  Stream<int> playingIndex() => _musicPlayerApi.playingIndex();

  AudioSource? getCurrentMusic() => _musicPlayerApi.getCurrentMusic();

  Stream<AudioSource> getCurrentMusicStream() => _musicPlayerApi.getCurrentMusicStream();

  void moveMusicItem(int oldIndex, int newIndex) => _musicPlayerApi.moveMusicItem(oldIndex, newIndex);

  void play() => _musicPlayerApi.play();

  void pause() => _musicPlayerApi.pause();

  Duration get getDuration => _musicPlayerApi.getDuration();

  BehaviorSubject<Duration?> getDurationStream() => _musicPlayerApi.getDurationStream();

  BehaviorSubject<Duration?> get getPositionStream => _musicPlayerApi.getPositionStream();

  bool isPlaying() => _musicPlayerApi.isPlaying();

  Stream<bool?> isPlayingStream() => _musicPlayerApi.isPlayingStream();

  void seekTo(Duration duration) => _musicPlayerApi.seekTo(duration);

  Future<void> playAtIndex(int index) => _musicPlayerApi.playAtIndex(index);

  UnmodifiableListView<AudioSource> get getPlayList => UnmodifiableListView(_musicPlayerApi.getPlayList());

  AudioSource getItemFromPlaylist(int index) => _musicPlayerApi.getItemFromPlaylist(index);

  void addToPlaylist(AudioSource audioSource) => _musicPlayerApi.addToPlaylist(audioSource);

  void addAllToPlaylist(List<AudioSource> audioSources) => _musicPlayerApi.addAllToPlaylist(audioSources);

  void deleteFromPlaylist(int index) => _musicPlayerApi.deleteFromPlaylist(index);

  Future<void> next() => _musicPlayerApi.next();

  Future<void> previous() => _musicPlayerApi.previous();

  Future<void> reset() => _musicPlayerApi.reset();

  Future<void> playRemoteAudio(AudioSource audioSource) => _musicPlayerApi.playRemoteAudio(audioSource);

  Future<void> playPlaylist(List<AudioSource> audioSources) => _musicPlayerApi.playPlaylist(audioSources);
}
