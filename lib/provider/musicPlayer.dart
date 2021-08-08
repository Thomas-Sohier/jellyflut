import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/commonPlayer.dart';

class MusicPlayer extends ChangeNotifier {
  Item? _item;
  CommonPlayer? _commonPlayer;

  // Singleton
  static final MusicPlayer _musicPlayer = MusicPlayer._internal();

  factory MusicPlayer() {
    return _musicPlayer;
  }

  MusicPlayer._internal();

  CommonPlayer? get getCommonPlayer => _commonPlayer;
  Item? get getItemPlayer => _item;

  void setCommonPlayer(CommonPlayer cp) {
    _commonPlayer = cp;
  }

  void play() {
    _commonPlayer!.play();
    notifyListeners();
  }

  void pause() {
    _commonPlayer!.pause();
    notifyListeners();
  }

  void toggle() {
    if (_commonPlayer!.isPlaying()) {
      _commonPlayer!.pause();
    }
    _commonPlayer!.play();
    notifyListeners();
  }

  void seekTo(Duration duration) {
    _commonPlayer!.seekTo(duration);
    notifyListeners();
  }

  void playRemoteAudio(Item item) {
    _commonPlayer!.playRemoteAudio(item);
    notifyListeners();
  }
}
