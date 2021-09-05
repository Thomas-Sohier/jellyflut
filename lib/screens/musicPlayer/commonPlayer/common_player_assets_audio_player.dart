import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/musicPlayer/models/music_item.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/rxdart.dart';

class CommonPlayerAssetsAudioPlayer {
  final MusicProvider _musicProvider = MusicProvider();

  Future<void> playRemoteAudio(
      AssetsAudioPlayer assetsAudioPlayer, Item item) async {
    final musicItemIndex = _musicProvider.getPlayList().length + 1;
    final streamURL = await StreamingService.contructAudioURL(itemId: item.id);
    final musicItem =
        await MusicItem.parseFromItem(musicItemIndex, streamURL, item);
    final insertedIndex = _musicProvider.insertIntoPlaylist(musicItem);
    final playlist = Playlist(
        audios: _getPlaylistMusicItemAsMedia(), startIndex: insertedIndex);
    await assetsAudioPlayer
        .open(playlist, loopMode: LoopMode.single, showNotification: true)
        .then((_) => _musicProvider.setCurrentMusic(musicItem));
  }

  List<Audio> _getPlaylistMusicItemAsMedia() {
    return _musicProvider.getMusicItems
        .map((MusicItem musicItem) => Audio.network(musicItem.url ?? ''))
        .toList();
  }

  bool isInit(AssetsAudioPlayer assetsAudioPlayer) {
    if (assetsAudioPlayer.current.hasValue) {
      return assetsAudioPlayer.current.value != null ||
          assetsAudioPlayer.isPlaying.value;
    }
    return false;
  }

  BehaviorSubject<bool> isInitStream(AssetsAudioPlayer assetsAudioPlayer) {
    final streamController = BehaviorSubject<bool>();
    assetsAudioPlayer.isPlaying
        .listen((isPlaying) => streamController.add(isPlaying));
    return streamController;
  }

  BehaviorSubject<bool> isPlaying(AssetsAudioPlayer assetsAudioPlayer) {
    final streamController = BehaviorSubject<bool>();
    assetsAudioPlayer.isPlaying.listen((event) => streamController.add(event));
    return streamController;
  }

  BehaviorSubject<int?> listenPlayingIndex(
      AssetsAudioPlayer assetsAudioPlayer) {
    final streamController = BehaviorSubject<int?>();
    assetsAudioPlayer.current
        .listen((event) => streamController.add(event?.index));
    return streamController;
  }

  void insertIntoPlaylist(
      int index, MusicItem musicItem, AssetsAudioPlayer assetsAudioPlayer) {
    assetsAudioPlayer.playlist!
        .insert(index, Audio.network(musicItem.url ?? ''));
  }

  void removeFromPlaylist(int index, AssetsAudioPlayer assetsAudioPlayer) {
    assetsAudioPlayer.playlist!.removeAtIndex(index);
  }
}
