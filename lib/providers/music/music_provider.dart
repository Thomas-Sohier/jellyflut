import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_colors.dart';
import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MusicProvider extends ChangeNotifier {
  Item? _item;
  // ignore: prefer_final_fields
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);
  AudioPlayer? _audioPlayer;
  final _colorController = BehaviorSubject<AudioColors>();

  // Singleton
  static final MusicProvider _MusicProvider = MusicProvider._internal();

  factory MusicProvider() {
    return _MusicProvider;
  }

  MusicProvider._internal();

  AudioPlayer? get getAudioPlayer => _audioPlayer;
  ConcatenatingAudioSource get getPlaylist => _playlist;
  Item? get getItemPlayer => _item;
  Stream<AudioColors> get getColorcontroller => _colorController;

  void setAudioPlayer(AudioPlayer audioPlayer) {
    _audioPlayer = audioPlayer;
  }

  void setNewColors(final AudioColors audioColors) {
    final audiocolors = AudioColors(
        backgroundColor1: audioColors.backgroundColor1,
        backgroundColor2: audioColors.backgroundColor2,
        foregroundColor: audioColors.foregroundColor);
    _colorController.add(audiocolors);
  }

  Stream<int?> playingIndex() {
    return _audioPlayer!.currentIndexStream;
  }

  IndexedAudioSource? getCurrentMusic() {
    return _audioPlayer?.sequenceState?.currentSource;
  }

  Stream<SequenceState?> getCurrentMusicStream() {
    return _audioPlayer!.sequenceStateStream;
  }

  void moveMusicItem(int oldIndex, int newIndex) {
    _playlist.move(oldIndex, newIndex);
    notifyListeners();
  }

  void play() {
    _audioPlayer!.play();
    notifyListeners();
  }

  void pause() {
    _audioPlayer!.pause();
    notifyListeners();
  }

  Duration getDuration() {
    return _audioPlayer?.duration ?? Duration.zero;
  }

  Stream<Duration?> getPositionStream() {
    return _audioPlayer!.positionStream;
  }

  Stream<bool> isPlaying() {
    return _audioPlayer!.playingStream;
  }

  void seekTo(Duration duration) {
    _audioPlayer!.seek(duration);
    notifyListeners();
  }

  void playAtIndex(int index) async {
    await _audioPlayer!.seek(Duration(seconds: 0), index: index);
    notifyListeners();
  }

  List<IndexedAudioSource> getPlayList() {
    return _playlist.sequence;
  }

  IndexedAudioSource getItemFromPlaylist(int index) {
    return _playlist.sequence.elementAt(index);
  }

  /// insert item at end of playlist
  /// return index as int
  void insertIntoPlaylist(AudioSource audioSource) {
    _playlist.add(audioSource);
    notifyListeners();
  }

  void deleteFromPlaylist(int index) {
    _playlist.removeAt(index);
    notifyListeners();
  }

  void next() {
    _audioPlayer!.seekToNext();
    notifyListeners();
  }

  void previous() {
    _audioPlayer!.seekToPrevious();
    notifyListeners();
  }

  void reset() {
    _playlist.clear();
    _audioPlayer?.stop();
  }

  Future<void> playRemoteAudio(Item item) async {
    // final streamURL = await StreamingService.contructAudioURL(itemId: item.id);
    final streamURL = await item.getItemURL();
    final audioSource = await AudioMetadata.parseFromItem(streamURL, item);
    await _playlist.add(audioSource);
    await _audioPlayer?.setAudioSource(_playlist);
    await _audioPlayer?.play();
    notifyListeners();
    return;
  }

  Future<void> playPlaylist(Item item) async {
    await ItemService.getItems(parentId: item.id).then((value) async {
      final indexToReturn = _playlist.length;
      final items =
          value.items.where((item) => item.isFolder == false).toList();
      //items.sort((a, b) => a.indexNumber!.compareTo(b.indexNumber!));
      for (var index = 0; index < items.length; index++) {
        final item = items.elementAt(index);
        final streamURL =
            await StreamingService.contructAudioURL(itemId: item.id);
        final musicItem = await AudioMetadata.parseFromItem(streamURL, item);
        insertIntoPlaylist(musicItem);
      }
      return indexToReturn;
    }).then((int index) => playAtIndex(index));
  }
}
