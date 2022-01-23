import 'dart:async';
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream.dart';
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
    final _player = Player(id: videoPlayerId, commandlineArguments: [
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

    _player.open(media, autoStart: false);

    // create timer to save progress
    final timer = _startProgressTimer(item, _player);
    streamingProvider.timer?.cancel();
    streamingProvider.setTimer(timer);

    // create common stream controller
    final commonStream =
        CommonStream.parseVlcComputerController(player: _player);
    _player.play();
    streamingProvider.setCommonStream(commonStream);
    return Future.value(_player);
  }

  static Future<Player> setupDataFromUrl({required String url}) async {
    final player = Player(
      id: videoPlayerId,
    );
    final media = Media.network(url);
    player.open(media);

    // create common stream controller
    final commonStream = CommonStream.parseVlcComputerController(
        player: player, listener: () => {});

    StreamingProvider().setCommonStream(commonStream);
    return Future.value(player);
  }

  void addListener(void Function() listener) {
    final timer =
        Timer.periodic(Duration(milliseconds: 100), (i) => listener());
    timers.add(timer);
  }

  void removeListener() {
    timers.forEach((t) => t.cancel());
  }

  static Timer _startProgressTimer(Item item, Player _player) {
    return Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => StreamingService.streamingProgress(item,
            canSeek: _player.playback.isSeekable,
            isMuted: _player.general.volume > 0 ? true : false,
            isPaused: !_player.playback.isPlaying,
            positionTicks: _player.position.position?.inMicroseconds ?? 0,
            volumeLevel: _player.general.volume.round(),
            subtitlesIndex: 0));
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
