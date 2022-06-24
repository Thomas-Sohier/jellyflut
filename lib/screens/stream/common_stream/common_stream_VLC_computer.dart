import 'dart:async';
import 'package:jellyflut/screens/stream/model/audio_track.dart';
import 'package:jellyflut/screens/stream/model/subtitle.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:universal_io/io.dart';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:window_manager/window_manager.dart';

class CommonStreamVLCComputer {
  static final streamingProvider = StreamingProvider();
  static final List<Timer> timers = [];
  final Player player;

  const CommonStreamVLCComputer({required this.player});

  static Future<Player> setupData({required Item item}) async {
    final streamURL = await item.getItemURL();
    final player = Player(id: videoPlayerId, commandlineArguments: [
      '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}',
      '--no-spu'
    ]);

    // Detect if media is available locdally or only remotely
    late final media;
    if (streamURL.startsWith(RegExp('^(http|https)://'))) {
      media = Media.network(streamURL);
    } else {
      media = Media.file(File(streamURL));
    }

    player.open(media, autoStart: false);

    // create timer to save progress
    final timer = _startProgressTimer(item, player);
    streamingProvider.timer?.cancel();
    streamingProvider.setTimer(timer);

    // create common stream controller
    final commonStream = CommonStream.parse(player);
    player.play();
    streamingProvider.setCommonStream(commonStream);
    return Future.value(player);
  }

  static Future<Player> setupDataFromUrl({required String url}) async {
    final player = Player(
      id: videoPlayerId,
    );
    final media = Media.network(url);
    player.open(media);

    // create common stream controller
    final commonStream = CommonStream.parse(player);

    StreamingProvider().setCommonStream(commonStream);
    return Future.value(player);
  }

  void addListener(void Function() listener) {
    final timer =
        Timer.periodic(Duration(milliseconds: 100), (i) => listener());
    timers.add(timer);
  }

  void removeListener() {
    for (var t in timers) {
      t.cancel();
    }
  }

  static PlaybackProgress getPlaybackProgress(Player controller) {
    PlayMethod _playMethod() {
      final isDirectPlay = streamingProvider.isDirectPlay ?? true;
      if (isDirectPlay) return PlayMethod.directPlay;
      return PlayMethod.transcode;
    }

    return PlaybackProgress(
        itemId: streamingProvider.item!.id,
        audioStreamIndex:
            streamingProvider.selectedAudioTrack!.jellyfinSubtitleIndex ?? 0,
        subtitleStreamIndex:
            streamingProvider.selectedSubtitleTrack!.jellyfinSubtitleIndex ?? 0,
        canSeek: true,
        isMuted: controller.general.volume == 0 ? true : false,
        isPaused: controller.playback.isPlaying,
        playSessionId: streamingProvider.playBackInfos?.playSessionId,
        mediaSourceId: streamingProvider.playBackInfos?.mediaSources.first.id,
        nowPlayingQueue: [],
        playbackStartTimeTicks: null,
        playMethod: _playMethod(),
        positionTicks: controller.position.position?.inMicroseconds,
        repeatMode: RepeatMode.repeatNone,
        volumeLevel: (controller.general.volume * 100).round());
  }

  static Timer _startProgressTimer(Item item, Player player) {
    return Timer.periodic(
        Duration(seconds: 15),
        (Timer t) =>
            StreamingService.streamingProgress(getPlaybackProgress(player)));
  }

  Future<void> play() {
    player.play();
    return Future.value();
  }

  Future<void> pause() {
    player.pause();
    return Future.value();
  }

  Future<void> seek(Duration duration) {
    player.seek(duration);
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  Future<void> pip() {
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  Future<List<Subtitle>> getSubtitles() {
    return Future.value(<Subtitle>[]);
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  Future<void> setSubtitle(Subtitle subtitle) {
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  Future<void> disableSubtitles() {
    return Future.value();
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  Future<List<AudioTrack>> getAudioTracks() {
    return Future.value(<AudioTrack>[]);
  }

  /// No implemented, do nothing
  /// Only there to comply to common stream interface
  Future<void> setAudioTrack(AudioTrack audioTrack) {
    return Future.value();
  }

  void enterFullscreen() async {
    final windowInstance = WindowManager.instance;
    await windowInstance.setFullScreen(true);
  }

  void exitFullscreen() async {
    final windowInstance = WindowManager.instance;
    await windowInstance.setFullScreen(false);
  }

  void toggleFullscreen() async {
    final windowInstance = WindowManager.instance;
    await windowInstance.isFullScreen().then(
        (bool isFullscreen) => windowInstance.setFullScreen(!isFullscreen));
  }

  BehaviorSubject<Duration> positionStream() {
    final streamController = BehaviorSubject<Duration>();
    player.positionStream.listen((PositionState positionState) =>
        streamController.add(positionState.position ?? Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<Duration> durationStream() {
    final streamController = BehaviorSubject<Duration>();
    player.positionStream.listen((PositionState positionState) =>
        streamController.add(positionState.duration ?? Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<bool> playingStateStream() {
    final streamController = BehaviorSubject<bool>();
    player.playbackStream
        .listen((PlaybackState event) => streamController.add(event.isPlaying));
    return streamController;
  }

  Future<void> stopPlayer() async {
    await StreamingService.deleteActiveEncoding();
    player.stop();
    return player.dispose();
  }
}
