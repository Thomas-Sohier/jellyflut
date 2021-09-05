import 'dart:async';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/models/music_item.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/rxdart.dart';

class CommonPlayerVLCComputer {
  static final List<Timer> _timers = [];
  final MusicProvider _musicProvider = MusicProvider();

  Stream<Duration?> getPosition(Player player) {
    final streamController = StreamController<Duration?>.broadcast();
    player.positionStream.listen((event) {
      streamController.add(event.position);
    });
    return streamController.stream;
  }

  Future<void> playRemoteAudio(Item item, Player player) async {
    final musicItemIndex = _musicProvider.getPlayList().length + 1;
    final streamURL = await StreamingService.contructAudioURL(itemId: item.id);
    final musicItem =
        await MusicItem.parseFromItem(musicItemIndex, streamURL, item);
    final insertedIndex = _musicProvider.insertIntoPlaylist(musicItem);
    final playlist = Playlist(
        medias: _getPlaylistMusicItemAsMedia(),
        playlistMode: PlaylistMode.single);
    player.open(playlist, autoStart: false);
    player.jump(insertedIndex);
    _musicProvider.setCurrentMusic(musicItem);
  }

  List<Media> _getPlaylistMusicItemAsMedia() {
    return _musicProvider.getMusicItems
        .map((MusicItem musicItem) => Media.network(musicItem.url ?? ''))
        .toList();
  }

  void playAtIndex(int index, Player player) {
    player.jump(index);
  }

  BehaviorSubject<bool> isPlaying(Player player) {
    final streamController = BehaviorSubject<bool>();
    player.playbackStream
        .listen((PlaybackState event) => streamController.add(event.isPlaying));
    return streamController;
  }

  BehaviorSubject<int?> listenPlayingIndex(Player player) {
    final streamController = BehaviorSubject<int?>();
    player.currentStream.listen((event) => streamController.add(event.index));
    return streamController;
  }

  void addListener(void Function() listener) {
    final timer =
        Timer.periodic(Duration(milliseconds: 100), (i) => listener());
    _timers.add(timer);
  }

  void removeListener() {
    _timers.forEach((t) => t.cancel());
  }

  void insertIntoPlaylist(int index, MusicItem musicItem, Player player) {
    final correctIndex = index > player.current.medias.length
        ? player.current.medias.length
        : index;
    final currentState = player.current;
    currentState.medias
        .insert(correctIndex, Media.network(musicItem.url ?? ''));
    player.currentController.add(currentState);
  }

  void removeFromPlaylist(int index, Player player) {
    player.current.medias.removeAt(index);
  }
}
