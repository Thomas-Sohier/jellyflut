import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/commonPlayer.dart';
import 'package:jellyflut/screens/musicPlayer/models/musicItem.dart';

class MusicProvider extends ChangeNotifier {
  Item? _item;
  // ignore: prefer_final_fields
  List<MusicItem> _musicItems = [];
  MusicItem? _currentlyPlayedMusicItem;
  CommonPlayer? _commonPlayer;

  // Singleton
  static final MusicProvider _MusicProvider = MusicProvider._internal();

  factory MusicProvider() {
    return _MusicProvider;
  }

  MusicProvider._internal();

  CommonPlayer? get getCommonPlayer => _commonPlayer;
  List<MusicItem> get getMusicItems => _musicItems;
  MusicItem? get getCurrentMusic => _currentlyPlayedMusicItem;
  Item? get getItemPlayer => _item;

  Stream<int?> playingIndex() {
    return _commonPlayer!.listenPlayingindex();
  }

  // TODO rework when playlist will be reordable
  void moveMusicItem(int oldIndex, int newIndex) {
    final index = newIndex - 1;
    final musicItem = _musicItems.removeAt(oldIndex);
    _commonPlayer!.removeFromPlaylist(oldIndex);
    _musicItems.insert(index, musicItem);
    _commonPlayer!.insertIntoPlaylist(index, musicItem);
    notifyListeners();
  }

  void setPlayingIndex(int? index) {
    if (index == null) throw ('index null');
    _currentlyPlayedMusicItem = _musicItems.elementAt(index);
  }

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
    _commonPlayer!.next();
    notifyListeners();
  }

  void previous() {
    _commonPlayer!.previous();
    notifyListeners();
  }

  void playRemoteAudio(Item item) async {
    await _commonPlayer!.playRemoteAudio(item);
    notifyListeners();
  }

  Future<void> playPlaylist(Item item) async {
    await getItems(parentId: item.id).then((value) async {
      final indexToReturn = _musicItems.length;
      final items =
          value.items.where((_item) => _item.isFolder == false).toList();
      //items.sort((a, b) => a.indexNumber!.compareTo(b.indexNumber!));
      for (var index = 0; index < items.length; index++) {
        final _item = items.elementAt(index);
        final streamURL = await contructAudioURL(itemId: _item.id);
        final musicItem =
            await MusicItem.parseFromItem(index, streamURL, _item);
        insertIntoPlaylist(musicItem);
      }
      return indexToReturn;
    }).then((int index) => playAtIndex(index));
  }
}
