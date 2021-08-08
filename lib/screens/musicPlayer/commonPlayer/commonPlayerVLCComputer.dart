import 'dart:async';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/models/musicItem.dart';

class CommonPlayerVLCComputer {
  static final List<Timer> _timers = [];
  final MusicPlayer _musicPlayer = MusicPlayer();

  Stream<Duration?> getPosition(Player player) {
    final streamController = StreamController<Duration?>.broadcast();
    player.positionStream.listen((event) {
      streamController.add(event.position);
    });
    return streamController.stream;
  }

  Future<void> playRemoteAudio(Item item, Player player) async {
    final musicItemIndex = _musicPlayer.getPlayList().length + 1;
    final streamURL = await contructAudioURL(itemId: item.id);
    final musicItem =
        await MusicItem.parseFromItem(musicItemIndex, streamURL, item);
    final insertedIndex = _musicPlayer.insertIntoPlaylist(musicItem);
    final playlist = Playlist(
        medias: _getPlaylistMusicItemAsMedia(),
        playlistMode: PlaylistMode.single);
    player.open(playlist, autoStart: false);
    player.jump(insertedIndex);
    _musicPlayer.setCurrentMusic(musicItem);
  }

  List<Media> _getPlaylistMusicItemAsMedia() {
    return _musicPlayer.getMusicItems
        .map((MusicItem musicItem) => Media.network(musicItem.url))
        .toList();
  }

  void playAtIndex(int index, Player player) {
    player.jump(index);
  }

  /// play previous track
  /// return index of current media
  int previous(Player player) {
    player.back();
    return player.current.index ?? 0;
  }

  /// play next track
  /// return index of current media
  int next(Player player) {
    player.next();
    return player.current.index ?? 0;
  }

  // MusicItem metasToMusicItem(Map<String, String> metas) {
  //   return MusicItem(
  //       id: 0,
  //       title: metas['title'],
  //       artist: metas['artist'],
  //       album: metas['album'],
  //       image: null);
  // }

  void addListener(void Function() listener) {
    final timer =
        Timer.periodic(Duration(milliseconds: 100), (i) => listener());
    _timers.add(timer);
  }

  void removeListener() {
    _timers.forEach((t) => t.cancel());
  }
}
