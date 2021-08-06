import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/streamingSoftware.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/components/commonControls.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamBP.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLC.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLCComputer.dart';
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
  final _tempItem = await item.getPlayableItemOrLastUnplayed();
  final _item = await getItem(_tempItem.id);
  StreamModel().setItem(_item);
  switch (streamingSoftware) {
    case StreamingSoftwareName.vlc:
      _initVLCMediaPlayer(_item);
      break;
    case StreamingSoftwareName.exoplayer:
      _initExoPlayerMediaPlayer(_item);
      break;
  }
}

void _initVLCMediaPlayer(Item item) async {
  var playerWidget;
  if (Platform.isLinux || Platform.isWindows) {
    playerWidget = await _initVlcComputerPlayer(item);
  } else {
    playerWidget = await _initVlcPhonePlayer(item);
  }
  await Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => Stream(player: playerWidget, item: item)));
}

Future<Widget> _initVlcComputerPlayer(Item item) async {
  final player = await CommonStreamVLCComputer.setupData(item: item);
  final size = MediaQuery.of(navigatorKey.currentContext!).size;
  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Video(
        playerId: player.id,
        height: size.height,
        width: size.width,
        scale: 1.0, // default
        showControls: false,
      ),
      CommonControls(isComputer: true),
    ],
  );
}

Future<Widget> _initVlcPhonePlayer(Item item) async {
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
      CommonControls(),
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
