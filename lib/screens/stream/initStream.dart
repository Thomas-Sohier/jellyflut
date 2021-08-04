import 'dart:io';
import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_vlc_player_platform_interface/flutter_vlc_player_platform_interface.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/streamingSoftware.dart';
import 'package:jellyflut/screens/stream/model/CommonStreamBP.dart';
import 'package:jellyflut/screens/stream/stream.dart';
import 'package:jellyflut/screens/stream/streamVLC.dart';
import 'package:jellyflut/screens/stream/streamVLCcomputer.dart';

import '../../main.dart';

void automaticStreamingSoftwareChooser({required Item item}) async {
  var streamingSoftwareDB = await AppDatabase()
      .getDatabase
      .settingsDao
      .getSettingsById(userApp!.settingsId);
  var streamingSoftware = StreamingSoftwareName.values.firstWhere((e) =>
      e.toString() ==
      'StreamingSoftwareName.' + streamingSoftwareDB.preferredPlayer);
  switch (streamingSoftware) {
    case StreamingSoftwareName.vlc:
      initVLCMediaPlayer(item);
      break;
    case StreamingSoftwareName.exoplayer:
      initExoPlayerMediaPlayer(item);
      break;
  }
}

void initVLCMediaPlayer(Item item) async {
  var url = await item.getItemURL(directPlay: true);
  if (Platform.isLinux || Platform.isWindows) {
    var playerId = Random().nextInt(10000);
    var player = Player(id: playerId, commandlineArguments: [
      '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}',
      '--fullscreen',
      '--embedded-video'
    ]);
    var media = Media.network(url);
    await Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => StreamVLCComputer(
                playerId: playerId, media: media, player: player)));
  } else {
    var _controller = initVlcController(url, item);
    await Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) =>
                StreamVLC(controller: _controller, showControls: true)));
  }
}

void initExoPlayerMediaPlayer(Item item) async {
  var url = await item.getItemURL();

  final betterPlayerController =
      await CommonStreamBP.setupData(streamURL: url, item: item);

  final playerBP = BetterPlayer(
      key: betterPlayerController.betterPlayerGlobalKey,
      controller: betterPlayerController);
  await Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => Stream(
                player: playerBP,
                item: item,
              )));
}

VlcPlayerController initVlcController(String url, Item item) {
  var vlcPlayerController = VlcPlayerController.network(
    url,
    autoPlay: true,
    options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        extras: [
          '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}' // Start at x seconds
        ]),
  );
  vlcPlayerController.addOnInitListener(() async {
    await vlcPlayerController.startRendererScanning();
  });

  return vlcPlayerController;
}
