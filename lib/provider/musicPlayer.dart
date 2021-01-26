import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';

import '../globals.dart';

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

  void addPlaylist(String path, String id, String title, String artist,
      String album, MetasImage image) {
    _musicPlayer.assetsAudioPlayer.playlist.add(Audio.network(path,
        metas: Metas(
            id: id, title: title, album: album, artist: artist, image: image)));
    print(_musicPlayer.assetsAudioPlayer.playlist.audios);
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

  void playRemoteItem(Item item) async {
    var url = await contructAudioURL(itemId: item.id);
    await getItem(item.id).then((Item _item) => {
          _musicPlayer.assetsAudioPlayer
              .open(
                Audio.network(
                  url,
                  metas: Metas(
                    title: item.name,
                    artist:
                        item.artists.map((e) => e.name).join(', ').toString(),
                    album: item.album,
                    image: MetasImage.network(getItemImageUrl(
                        item.correctImageId(), item.correctImageTags(),
                        imageBlurHashes: item.imageBlurHashes)),
                  ),
                ),
                showNotification: true,
              )
              .then((_) => notifyListeners())
        });
  }

  String _createURl(String id, {String codec = 'mp3'}) {
    var url = '${server.url}/Audio/${id}/stream.${codec}';
    return url;
  }
}
