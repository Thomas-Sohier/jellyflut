import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';

import '../globals.dart';

class MusicPlayer extends ChangeNotifier {
  AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();

  // Singleton
  static final MusicPlayer _musicPlayer = MusicPlayer._internal();

  factory MusicPlayer() {
    return _musicPlayer;
  }

  MusicPlayer._internal();

  void play() {
    _musicPlayer.assetsAudioPlayer.play();
    notifyListeners();
  }

  void pause() {
    _musicPlayer.assetsAudioPlayer.pause();
    notifyListeners();
  }

  void playRemoteItem(Item item) {
    _musicPlayer.assetsAudioPlayer
        .open(
          Audio.network(
            _createURl(item),
            metas: Metas(
              title: item.name,
              artist: item.artists.map((e) => e.name).join(", ").toString(),
              album: item.album,
              image: MetasImage.network(getItemImageUrl(
                  item.id, item.imageBlurHashes)), //can be MetasImage.network
            ),
          ),
          showNotification: true,
        )
        .then((_) => notifyListeners());
  }

  String _createURl(Item item) {
    String url = "${server.url}/Audio/${item.id}/stream.mp3";
    return url;
  }
}
