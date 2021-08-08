import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/commonPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/models/musicItem.dart';

class MusicPlayer extends ChangeNotifier {
  Item? _item;
  // ignore: prefer_final_fields
  List<MusicItem> _musicItems = [];
  MusicItem? _currentlyPlayedMusicItem;
  CommonPlayer? _commonPlayer;

  // Singleton
  static final MusicPlayer _musicPlayer = MusicPlayer._internal();

  factory MusicPlayer() {
    return _musicPlayer;
  }

  MusicPlayer._internal();

  CommonPlayer? get getCommonPlayer => _commonPlayer;
  List<MusicItem> get getMusicItems => _musicItems;
  MusicItem? get getCurrentMusic => _currentlyPlayedMusicItem;
  Item? get getItemPlayer => _item;

  void setCommonPlayer(CommonPlayer cp) {
    _commonPlayer = cp;
  }

  void setCurrentMusic(MusicItem musicItem) {
    _currentlyPlayedMusicItem = musicItem;
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
    } else {
      _commonPlayer!.play();
    }
    notifyListeners();
  }

  void seekTo(Duration duration) {
    _commonPlayer!.seekTo(duration);
    notifyListeners();
  }

  void playAtIndex(int index) {
    _commonPlayer!.playAtIndex(index);
    _currentlyPlayedMusicItem = _musicItems.elementAt(index);
    notifyListeners();
  }

  List<MusicItem> getPlayList() {
    return _musicItems;
  }

  MusicItem getItemFromPlaylist(int index) {
    return _musicItems.elementAt(index);
  }

  /// insert item at end of playlist
  /// return index as int
  int insertIntoPlaylist(MusicItem musicItem) {
    _musicItems.add(musicItem);
    notifyListeners();
    return _musicItems.indexOf(musicItem);
  }

  void deleteFromPlaylist(int index) {
    _musicItems.removeAt(index);
    notifyListeners();
  }

  void next() {
    final index = _commonPlayer!.next();
    _currentlyPlayedMusicItem = _musicItems.elementAt(index);
    notifyListeners();
  }

  void previous() {
    final index = _commonPlayer!.previous();
    _currentlyPlayedMusicItem = _musicItems.elementAt(index);
    notifyListeners();
  }

  void playRemoteAudio(Item item) async {
    await _commonPlayer!.playRemoteAudio(item);
    notifyListeners();
  }
}
