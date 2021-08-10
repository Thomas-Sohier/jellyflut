import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/models/musicItem.dart';
import 'package:rxdart/rxdart.dart';

class CommonPlayerAssetsAudioPlayer {
  final MusicPlayer _musicPlayer = MusicPlayer();

  Future<void> playRemoteAudio(
      AssetsAudioPlayer assetsAudioPlayer, Item item) async {
    final musicItemIndex = _musicPlayer.getPlayList().length + 1;
    final streamURL = await contructAudioURL(itemId: item.id);
    final musicItem =
        await MusicItem.parseFromItem(musicItemIndex, streamURL, item);
    final insertedIndex = _musicPlayer.insertIntoPlaylist(musicItem);
    final playlist = Playlist(
        audios: _getPlaylistMusicItemAsMedia(), startIndex: insertedIndex);
    await assetsAudioPlayer
        .open(playlist, loopMode: LoopMode.single, showNotification: true)
        .then((_) => _musicPlayer.setCurrentMusic(musicItem));
  }

  List<Audio> _getPlaylistMusicItemAsMedia() {
    return _musicPlayer.getMusicItems
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
}
