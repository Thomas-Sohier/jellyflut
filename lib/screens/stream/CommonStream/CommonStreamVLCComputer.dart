import 'dart:async';
import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/cupertino.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStream.dart';

class CommonStreamVLCComputer {
  static List<Timer> timers = [];

  static Future<Player> setupData({required Item item}) async {
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    final streamURL = await item.getItemURL(directPlay: true);
    final playerId = Random().nextInt(10000);
    final player = Player(
        id: playerId,
        videoWidth: item.width ?? size.width.toInt(),
        videoHeight: item.height ?? size.height.toInt(),
        commandlineArguments: [
          '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}'
        ]);
    final media = Media.network(streamURL);
    player.open(media);

    // create timer to save progress
    final timer = _startProgressTimer(item, player);
    StreamModel().setTimer(timer);

    // create common stream controller
    final commonStream = CommonStream.parseVlcComputerController(
        player: player, listener: () => {});

    StreamModel().setCommonStream(commonStream);
    return Future.value(player);
  }

  static Future<Player> setupDataFromUrl({required String url}) async {
    final size = MediaQuery.of(navigatorKey.currentContext!).size;
    final playerId = Random().nextInt(10000);
    final player = Player(
      id: playerId,
      videoWidth: size.width.toInt(),
      videoHeight: size.height.toInt(),
    );
    final media = Media.network(url);
    player.open(media);

    // create common stream controller
    final commonStream = CommonStream.parseVlcComputerController(
        player: player, listener: () => {});

    StreamModel().setCommonStream(commonStream);
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
        (Timer t) => itemProgress(item,
            canSeek: player.playback.isSeekable,
            isMuted: player.general.volume > 0 ? true : false,
            isPaused: !player.playback.isPlaying,
            positionTicks: player.position.position?.inMicroseconds ?? 0,
            volumeLevel: player.general.volume.round(),
            subtitlesIndex: 0));
  }
}
