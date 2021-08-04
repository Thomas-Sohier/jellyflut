import 'dart:io';
import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/streamingSoftware.dart';
import 'package:jellyflut/screens/stream/model/commonControls.dart';
import 'package:jellyflut/screens/stream/model/CommonStreamBP.dart';
import 'package:jellyflut/screens/stream/model/CommonStreamVLC.dart';
import 'package:jellyflut/screens/stream/stream.dart';

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
      _initVLCMediaPlayer(item);
      break;
    case StreamingSoftwareName.exoplayer:
      _initExoPlayerMediaPlayer(item);
      break;
  }
}

void _initVLCMediaPlayer(Item item) async {
  var playerWidget;
  if (Platform.isLinux || Platform.isWindows) {
    final url = await item.getItemURL(directPlay: true);
    playerWidget = _initVlcComputerPlayer(url, item);
  } else {
    playerWidget = await _initVlcPHonePlayer(item);
  }
  await Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => Stream(player: playerWidget, item: item)));
}

Widget _initVlcComputerPlayer(String url, Item item) {
  final size = MediaQuery.of(navigatorKey.currentContext!).size;
  final playerId = Random().nextInt(10000);
  final player = Player(id: playerId, commandlineArguments: [
    '--start-time=${Duration(microseconds: item.getPlaybackPosition()).inSeconds}',
    '--fullscreen',
    '--embedded-video'
  ]);
  final media = Media.network(url);
  final playerWidget = Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Video(
        playerId: playerId,
        height: size.height,
        width: size.width,
        scale: 1.0, // default
        showControls: false,
      ),
      Expanded(child: CommonControls()),
    ],
  );

  player.open(
    media,
    autoStart: true, // default
  );

  return playerWidget;
}

Future<Widget> _initVlcPHonePlayer(Item item) async {
  final vlcPlayerController = await CommonStreamVLC.setupData(item: item);

  vlcPlayerController.addOnInitListener(() async {
    await vlcPlayerController.startRendererScanning();
  });

  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      VlcPlayer(
        controller: vlcPlayerController,
        aspectRatio: item.getAspectRatio(),
        placeholder: Center(child: CircularProgressIndicator()),
      ),
      Expanded(child: CommonControls()),
    ],
  );
}

void _initExoPlayerMediaPlayer(Item item) async {
  // Setup data with Better Player
  final betterPlayerController = await CommonStreamBP.setupData(item: item);

  // Init widget player to use in Stream widget
  final playerBP = BetterPlayer(
      key: betterPlayerController.betterPlayerGlobalKey,
      controller: betterPlayerController);

  // Redirect to player page
  await Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => Stream(
                player: playerBP,
                item: item,
              )));
}
