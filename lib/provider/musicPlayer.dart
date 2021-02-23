import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';

class MusicPlayer extends ChangeNotifier {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  // Singleton
  static final MusicPlayer _musicPlayer = MusicPlayer._internal();

  factory MusicPlayer() {
    return _musicPlayer;
  }

  MusicPlayer._internal();

  String currentMusicTitle() {
    return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current
        .audio.audio.metas.title;
  }

  String currentMusicArtist() {
    return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current
        .audio.audio.metas.artist;
  }

  double currentMusicMaxDuration() {
    return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value.current
        .audio.duration.inMilliseconds
        .toDouble();
  }

  double currentMusicDuration() {
    return _musicPlayer.assetsAudioPlayer.realtimePlayingInfos.value
        .currentPosition.inMilliseconds
        .toDouble();
  }

  String getCurrentAudioImagePath() {
    return assetsAudioPlayer.current.value.audio.audio.metas.image.path;
  }

  void addPlaylist(Item item) async {
    assetsAudioPlayer.playlist.add(await _createAudioNetwork(item));
  }

  void playAtIndex(int index) {
    assetsAudioPlayer.playlistPlayAtIndex(index);
    notifyListeners();
  }

  void removePlaylistItemAtIndex(int index) {
    assetsAudioPlayer.playlist.removeAtIndex(index);
    notifyListeners();
  }

  void play() {
    _musicPlayer.assetsAudioPlayer.play();
    notifyListeners();
  }

  void pause() {
    _musicPlayer.assetsAudioPlayer.pause();
    notifyListeners();
  }

  void toggle() {
    _musicPlayer.assetsAudioPlayer.isPlaying.value
        ? _musicPlayer.assetsAudioPlayer.pause()
        : _musicPlayer.assetsAudioPlayer.play();
    notifyListeners();
  }

  void playPlaylist(String parentId) {
    getItems(parentId: parentId)
        .then((value) => value.items
                .where((_item) => _item.isFolder == false)
                .forEach((Item _item) async {
              if (assetsAudioPlayer.playlist == null) {
                playRemoteItem(_item);
              } else {
                await addPlaylist(_item);
              }
            }))
        .then((value) => assetsAudioPlayer.playlistPlayAtIndex(0));
  }

  void playRemoteItem(Item item) async {
    await getItem(item.id).then((Item _item) async => {
          _musicPlayer.assetsAudioPlayer
              .open(
                await _createAudioNetwork(item),
                showNotification: true,
              )
              .then((_) => notifyListeners())
        });
  }

  Future<Audio> _createAudioNetwork(Item item) async {
    var url = await contructAudioURL(itemId: item.id);
    return Audio.network(
      url,
      metas: Metas(
        id: item.id,
        title: item.name,
        artist: item.artists.map((e) => e.name).join(', ').toString(),
        album: item.album,
        image: MetasImage.network(getItemImageUrl(
            item.correctImageId(), item.correctImageTags(),
            imageBlurHashes: item.imageBlurHashes)),
      ),
    );
  }
}
