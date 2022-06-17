import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/musicPlayer/CommonPlayer/common_player.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_colors.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_playlist.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:rxdart/rxdart.dart';

import '../../screens/musicPlayer/models/audio_source.dart';

class MusicProvider extends ChangeNotifier {
  Item? _item;
  CommonPlayer? _commonPlayer;
  final _audioPlaylist = AudioPlaylist(audioSources: []);
  final _colorController = BehaviorSubject<AudioColors>();

  // Singleton
  static final MusicProvider _MusicProvider = MusicProvider._internal();

  factory MusicProvider() {
    return _MusicProvider;
  }

  MusicProvider._internal();

  CommonPlayer? get getAudioPlayer => _commonPlayer;
  List<AudioSource> get getPlaylist => _audioPlaylist.getPlaylist;
  Item? get getItemPlayer => _item;
  Stream<AudioColors> get getColorcontroller => _colorController;

  void initPlayer() async {
    if (_commonPlayer != null) return;

    if (Platform.isLinux || Platform.isWindows) {
      final player = audioplayers.AudioPlayer();
      _commonPlayer =
          CommonPlayer.parseAudioplayerController(audioPlayer: player);
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      final player = just_audio.AudioPlayer();
      _commonPlayer =
          CommonPlayer.parseJustAudioController(audioPlayer: player);
    } else {
      final currentPlatform =
          Theme.of(customRouter.navigatorKey.currentContext!).platform;
      throw UnimplementedError(
          'No audio player on this platform (platform : $currentPlatform');
    }
  }

  void setNewColors(final AudioColors audioColors) {
    final audiocolors = AudioColors(
        backgroundColor1: audioColors.backgroundColor1,
        backgroundColor2: audioColors.backgroundColor2,
        foregroundColor: audioColors.foregroundColor);
    _colorController.add(audiocolors);
  }

  Stream<int?> playingIndex() {
    return Stream.value(0);
  }

  AudioSource? getCurrentMusic() {
    // return _commonPlayer?.sequenceState?.currentSource;
    return null;
  }

  Stream<AudioSource> getCurrentMusicStream() {
    // return _commonPlayer!.sequenceStateStream;
    return Stream.empty();
  }

  void moveMusicItem(int oldIndex, int newIndex) {
    _audioPlaylist.move(oldIndex, newIndex);
    notifyListeners();
  }

  void play() {
    _commonPlayer?.play();
    notifyListeners();
  }

  void pause() {
    _commonPlayer?.pause();
    notifyListeners();
  }

  Duration getDuration() {
    return _commonPlayer?.getDuration() ?? Duration.zero;
  }

  Stream<Duration?> getPositionStream() {
    return _commonPlayer!.getPositionStream();
  }

  Stream<bool> isPlaying() {
    return _commonPlayer!.getPlayingStateStream();
  }

  void seekTo(Duration duration) {
    _commonPlayer!.seekTo(duration);
    notifyListeners();
  }

  void playAtIndex(int index) async {
    // await _commonPlayer!.seekTo(Duration(seconds: 0), index: index);
    notifyListeners();
  }

  List<AudioSource> getPlayList() {
    return _audioPlaylist.getPlaylist;
  }

  AudioSource getItemFromPlaylist(int index) {
    return _audioPlaylist.getPlaylist.elementAt(index);
  }

  /// insert item at end of playlist
  /// return index as int
  void insertIntoPlaylist(AudioSource audioSource) {
    _audioPlaylist.insert(audioSource);
    notifyListeners();
  }

  void deleteFromPlaylist(int index) {
    _audioPlaylist.removeAt(index);
    notifyListeners();
  }

  void next() {
    _commonPlayer!.nextTrack();
    notifyListeners();
  }

  void previous() {
    _commonPlayer!.previousTrack();
    notifyListeners();
  }

  void reset() {
    _audioPlaylist.clear();
    // _commonPlayer?.stop();
  }

  Future<void> playRemoteAudio(Item item) async {
    final streamURL = await item.getItemURL();
    final audioSource = await AudioMetadata.parseFromItem(streamURL, item);
    _audioPlaylist.insert(audioSource);
    // await _commonPlayer?.setAudioSource(_playlist);
    _commonPlayer?.play();
    notifyListeners();
    return;
  }

  Future<void> playPlaylist(Item item) async {
    await ItemService.getItems(parentId: item.id).then((value) async {
      final indexToReturn = _audioPlaylist.getPlaylist.length;
      final items =
          value.items.where((_item) => _item.isFolder == false).toList();
      //items.sort((a, b) => a.indexNumber!.compareTo(b.indexNumber!));
      for (var index = 0; index < items.length; index++) {
        final _item = items.elementAt(index);
        final streamURL =
            await StreamingService.contructAudioURL(itemId: _item.id);
        final musicItem = await AudioMetadata.parseFromItem(streamURL, _item);
        insertIntoPlaylist(musicItem);
      }
      return indexToReturn;
    }).then((int index) => playAtIndex(index));
  }
}
