import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:jellyflut/theme/theme.dart' as personnal_theme;
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:music_player_api/music_player_api.dart';
import 'package:music_player_repository/music_player_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:streaming_repository/streaming_repository.dart';

part 'music_player_event.dart';
part 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  MusicPlayerBloc({
    required Database database,
    required ItemsRepository itemsRepository,
    required MusicPlayerRepository musicPlayerRepository,
    required StreamingRepository streamingRepository,
    required ThemeData theme,
  })  : _itemsRepository = itemsRepository,
        _musicPlayerRepository = musicPlayerRepository,
        _streamingRepository = streamingRepository,
        _database = database,
        super(MusicPlayerState(theme: theme, postionStream: BehaviorSubject.seeded(Duration.zero))) {
    on<LayoutChanged>(_onLayoutChange);
    on<SeekRequested>(_onSeek);
    on<ReoderList>(_onReoder);
    on<PlayAtIndex>(_onPlayAtIndex);
    on<DeleteAudioFromPlaylist>(_onDeleteFromPlaylist);
    on<NextSongRequested>(_onNextSong);
    on<TogglePlayPauseRequested>(_onTogglePlayPause);
    on<PreviousSongRequested>(_onPreviousSong);
    on<PlaySongRequested>(_onPlaySong);
    on<PlayPlaylistRequested>(_onPlayPlaylist);
    on<StopRequested>(_onStop);
  }

  final Database _database;
  final ItemsRepository _itemsRepository;
  final MusicPlayerRepository _musicPlayerRepository;
  final StreamingRepository _streamingRepository;

  Future<void> _onPlaySong(PlaySongRequested event, Emitter<MusicPlayerState> emit) async {
    final streamURL = await _itemsRepository.createMusicURL(event.item.id);
    final audioSource = await _parseItemToAudioSource(streamURL, event.item);
    await _musicPlayerRepository.playRemoteAudio(audioSource);
    emit(state.copyWith(
        currentlyPlaying: _musicPlayerRepository.getCurrentMusic(),
        playlist: _musicPlayerRepository.getPlayList,
        playingState: PlayingState.fromBool(_musicPlayerRepository.isPlaying()),
        duration: _musicPlayerRepository.getDuration,
        postionStream: _musicPlayerRepository.getPositionStream,
        status: MusicPlayerStatus.playing));
    await _setAlbumPrimaryColor(emit);
  }

  Future<void> _onPlayPlaylist(PlayPlaylistRequested event, Emitter<MusicPlayerState> emit) async {
    final audioSources = <AudioSource>[];
    final category = await _itemsRepository.getCategory(parentId: event.item.id);
    final items = category.items.where((item) => item.isFolder == false).toList();
    items.sort(sortMusic);

    for (var index = 0; index < items.length; index++) {
      final item = items.elementAt(index);
      final streamURL = await _streamingRepository.createMusicURL(item);
      final musicItem = await _parseItemToAudioSource(streamURL.url, item);
      audioSources.add(musicItem);
    }
    _musicPlayerRepository.addAllToPlaylist(audioSources);
    await _musicPlayerRepository.playAtIndex(0);
    emit(state.copyWith(
        currentlyPlaying: _musicPlayerRepository.getCurrentMusic(),
        playlist: _musicPlayerRepository.getPlayList,
        playingState: PlayingState.fromBool(_musicPlayerRepository.isPlaying()),
        duration: _musicPlayerRepository.getDuration,
        postionStream: _musicPlayerRepository.getPositionStream,
        status: MusicPlayerStatus.playing));
    await _setAlbumPrimaryColor(emit);
  }

  int sortMusic(Item? a, Item? b) {
    final aIndex = a?.indexNumber;
    final bIndex = b?.indexNumber;
    if (aIndex != null && bIndex != null) {
      return bIndex.compareTo(aIndex);
    } else if (aIndex != null && bIndex == null) {
      return -1;
    }
    if (aIndex == null && bIndex == null) {
      return 1;
    }
    return 0;
  }

  Future<void> _onStop(StopRequested event, Emitter<MusicPlayerState> emit) async {
    await _musicPlayerRepository.reset();
    emit(state.copyWith(status: MusicPlayerStatus.stopped));
  }

  Future<void> _onSeek(SeekRequested event, Emitter<MusicPlayerState> emit) async {
    _musicPlayerRepository.seekTo(event.position);
  }

  Future<void> _onNextSong(NextSongRequested event, Emitter<MusicPlayerState> emit) async {
    await _musicPlayerRepository.next();
    emit(state.copyWith(
        currentlyPlaying: _musicPlayerRepository.getCurrentMusic(),
        playingState: PlayingState.fromBool(_musicPlayerRepository.isPlaying()),
        duration: _musicPlayerRepository.getDuration,
        postionStream: _musicPlayerRepository.getPositionStream,
        status: MusicPlayerStatus.playing));
    await _setAlbumPrimaryColor(emit);
  }

  Future<void> _onReoder(ReoderList event, Emitter<MusicPlayerState> emit) async {
    _musicPlayerRepository.moveMusicItem(event.oldIndex, event.newIndex);
    emit(state.copyWith(playlist: _musicPlayerRepository.getPlayList));
  }

  Future<void> _onPlayAtIndex(PlayAtIndex event, Emitter<MusicPlayerState> emit) async {
    await _musicPlayerRepository.playAtIndex(event.index);
    emit(state.copyWith(
        currentlyPlaying: _musicPlayerRepository.getCurrentMusic(),
        playingState: PlayingState.fromBool(_musicPlayerRepository.isPlaying()),
        duration: _musicPlayerRepository.getDuration,
        postionStream: _musicPlayerRepository.getPositionStream,
        status: MusicPlayerStatus.playing));
    await _setAlbumPrimaryColor(emit);
  }

  Future<void> _onDeleteFromPlaylist(DeleteAudioFromPlaylist event, Emitter<MusicPlayerState> emit) async {
    _musicPlayerRepository.deleteFromPlaylist(event.index);
    emit(state.copyWith(playlist: _musicPlayerRepository.getPlayList));
  }

  Future<void> _onTogglePlayPause(TogglePlayPauseRequested event, Emitter<MusicPlayerState> emit) async {
    if (state.playingState == PlayingState.pause) {
      _musicPlayerRepository.play();
      emit(state.copyWith(playingState: PlayingState.play));
    } else {
      _musicPlayerRepository.pause();
      emit(state.copyWith(playingState: PlayingState.pause));
    }
  }

  Future<void> _onPreviousSong(PreviousSongRequested event, Emitter<MusicPlayerState> emit) async {
    await _musicPlayerRepository.previous();
    emit(state.copyWith(
        currentlyPlaying: _musicPlayerRepository.getCurrentMusic(),
        playingState: PlayingState.fromBool(_musicPlayerRepository.isPlaying()),
        duration: _musicPlayerRepository.getDuration,
        postionStream: _musicPlayerRepository.getPositionStream,
        status: MusicPlayerStatus.playing));
    await _setAlbumPrimaryColor(emit);
  }

  // Yield screen layout change
  Future<void> _onLayoutChange(LayoutChanged event, Emitter<MusicPlayerState> emit) async {
    emit(state.copyWith(screenLayout: event.screenLayout));
  }

  Future<AudioSource> _parseItemToAudioSource(String url, Item item) async {
    // Detect if media is available locally or only remotely
    late final Uint8List artwork;
    if (url.startsWith(RegExp('^(http|https)://'))) {
      artwork = await _itemsRepository.downloadRemoteImage(item.correctImageId());
      // artwork = (await NetworkAssetBundle(Uri.parse(urlImage)).load(urlImage)).buffer.asUint8List();
    } else {
      final download = await _database.downloadsDao.getDownloadById(item.id);
      artwork = download.primary ?? Uint8List(0);
    }
    return AudioSource.network(Uri.parse(url),
        metadata: AudioMetadata(
            item: item,
            album: item.album,
            title: item.name ?? '',
            artist: item.artists.isNotEmpty ? item.artists.join(', ').toString() : '',
            artworkUrl: null,
            artworkByte: artwork));
  }

  Future<void> _setAlbumPrimaryColor(Emitter<MusicPlayerState> emit) async {
    if (state.currentlyPlaying != null) {
      final metadata = state.currentlyPlaying!.metadata;
      final colors = await compute(ColorUtil.extractPixelsColors, metadata.artworkByte);
      final brightness = state.theme.brightness;
      final newTheme = personnal_theme.Theme.generateThemeDataFromSeedColor(brightness, colors[0]);
      emit(state.copyWith(theme: newTheme));
    }
  }
}
