import 'dart:async';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStream.dart';
import 'package:jellyflut/services/streaming/streamingService.dart';
import 'package:rxdart/rxdart.dart';

class CommonStreamVLCComputer {
  static List<Timer> timers = [];

  static Future<Player> setupData({required Item item}) async {
    final streamURL = await item.getItemURL(directPlay: true);
    final playerId = Random().nextInt(10000);
    final player = Player(id: playerId, commandlineArguments: [
      '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}'
    ]);
    final media = Media.network(streamURL);
    player.open(media);

    // create timer to save progress
    final timer = _startProgressTimer(item, player);
    StreamingProvider().setTimer(timer);

    // create common stream controller
    final commonStream = CommonStream.parseVlcComputerController(
        player: player, listener: () => {});

    StreamingProvider().setCommonStream(commonStream);
    return Future.value(player);
  }

  static Future<Player> setupDataFromUrl({required String url}) async {
    final playerId = Random().nextInt(10000);
    final player = Player(
      id: playerId,
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

  static Timer _startProgressTimer(Item item, Player player) {
    return Timer.periodic(
        Duration(seconds: 15),
        (Timer t) => StreamingService.streamingProgress(item,
            canSeek: player.playback.isSeekable,
            isMuted: player.general.volume > 0 ? true : false,
            isPaused: !player.playback.isPlaying,
            positionTicks: player.position.position?.inMicroseconds ?? 0,
            volumeLevel: player.general.volume.round(),
            subtitlesIndex: 0));
  }

  BehaviorSubject<Duration> positionStream(Player player) {
    final streamController = BehaviorSubject<Duration>();
    player.positionStream.listen((PositionState positionState) =>
        streamController.add(positionState.position ?? Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<Duration> durationStream(Player player) {
    final streamController = BehaviorSubject<Duration>();
    player.positionStream.listen((PositionState positionState) =>
        streamController.add(positionState.duration ?? Duration(seconds: 0)));
    return streamController;
  }

  BehaviorSubject<bool> isPlaying(Player player) {
    final streamController = BehaviorSubject<bool>();
    player.playbackStream
        .listen((PlaybackState event) => streamController.add(event.isPlaying));
    return streamController;
  }
}
