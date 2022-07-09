import 'dart:collection';

/// {@template music_player_repository}
/// A repository that handle music player
/// {@endtemplate}
class MusicPlayerRepository {
  /// {@macro music_player_repository}
  const MusicPlayerRepository({required MusicPlayerApi musicPlayerApi}) : _musicPlayerApi = musicPlayerApi;

  final MusicPlayerApi _musicPlayerApi;

  void initPlayer() => _musicPlayerApi.initPlayer();

  Stream<int> playingIndex() => _musicPlayerApi.playingIndex();

  AudioSource? getCurrentMusic()  => _musicPlayerApi.getCurrentMusic();

  Stream<AudioSource> getCurrentMusicStream() => _musicPlayerApi.getCurrentMusicStream();

  void moveMusicItem(int oldIndex, int newIndex)  => _musicPlayerApi.moveMusicItem(int oldIndex, int newIndex);

  void play()  => _musicPlayerApi.play();

  void pause()  => _musicPlayerApi.pause();

  Duration getDuration()  => _musicPlayerApi.getDuration();

  BehaviorSubject<Duration?> getDurationStream()  => _musicPlayerApi.getDurationStream();
  Stream<Duration?> getPositionStream()  => _musicPlayerApi.getPositionStream();

  Stream<bool?> isPlaying()  => _musicPlayerApi.isPlaying();

  void seekTo(Duration duration)  => _musicPlayerApi.seekTo(Duration duration);

  Future<void> playAtIndex(int index) => _musicPlayerApi.playAtIndex(int index);

  UnmodifiableListView<AudioSource> getPlayList()  => _musicPlayerApi.getPlayList();

  AudioSource getItemFromPlaylist(int index) => _musicPlayerApi.getItemFromPlaylist(int index);
  
  /// insert item at end of playlist
  /// return index as int
  void insertIntoPlaylist(AudioSource audioSource)  => _musicPlayerApi.insertIntoPlaylist(AudioSource audioSource);
  
  void deleteFromPlaylist(int index)  => _musicPlayerApi.deleteFromPlaylist(int index);

  Future<void> next()  => _musicPlayerApi.next();

  void previous() => _musicPlayerApi.previous();

  void reset()  => _musicPlayerApi.reset();

  Future<void> playRemoteAudio(Item item) => _musicPlayerApi.playRemoteAudio(Item item);

  Future<void> playPlaylist(Item item)  => _musicPlayerApi.playPlaylist(Item item);
}
