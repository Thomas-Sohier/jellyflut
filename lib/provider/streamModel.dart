import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/playbackInfos.dart';

class StreamModel extends ChangeNotifier {
  Item _item = Item();
  PlayBackInfos _playBackInfos = PlayBackInfos();
  String _url;
  BetterPlayerController _betterPlayerController;
  bool _isDirectPlay;
  int _audioStreamIndex;
  int _subtitleStreamIndex;

  // Singleton
  static final StreamModel _streamProvider = StreamModel._internal();

  Item get item => _item;
  PlayBackInfos get playBackInfos => _playBackInfos;
  String get url => _url;
  BetterPlayerController get betterPlayerController => _betterPlayerController;
  bool get isDirectPlay => _isDirectPlay;
  int get audioStreamIndex => _audioStreamIndex;
  int get subtitleStreamIndex => _subtitleStreamIndex;

  factory StreamModel() {
    return _streamProvider;
  }

  StreamModel._internal();

  void setItem(Item item) {
    _item = item;
  }

  void setPlaybackInfos(PlayBackInfos playBackInfos) {
    _playBackInfos = playBackInfos;
  }

  void setURL(String url) {
    _url = url;
  }

  void setBetterPlayerController(
      BetterPlayerController betterPlayerController) {
    _betterPlayerController = betterPlayerController;
  }

  void setIsDirectPlay(bool isDirectPlay) {
    _isDirectPlay = isDirectPlay;
  }

  void setAudioStreamIndex(int audioStreamIndex) {
    _audioStreamIndex = audioStreamIndex;
  }

  void setSubtitleStreamIndex(int subtitleStreamIndex) {
    _subtitleStreamIndex = subtitleStreamIndex;
  }
}
