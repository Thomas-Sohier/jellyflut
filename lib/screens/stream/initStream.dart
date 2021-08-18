import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/streamingSoftware.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streamingProvider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/stream/components/commonControls.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamBP.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLC.dart';
import 'package:jellyflut/screens/stream/CommonStream/CommonStreamVLCComputer.dart';
import 'package:jellyflut/services/item/itemService.dart';

void automaticStreamingSoftwareChooser({required Item item}) async {
  var streamingSoftwareDB = await AppDatabase()
      .getDatabase
      .settingsDao
      .getSettingsById(userApp!.settingsId);
  var streamingSoftware = StreamingSoftwareName.values.firstWhere((e) =>
      e.toString() ==
      'StreamingSoftwareName.' + streamingSoftwareDB.preferredPlayer);
  final _tempItem = await item.getPlayableItemOrLastUnplayed();
  final _item = await ItemService.getItem(_tempItem.id);
  StreamingProvider().setItem(_item);

  // Depending the platform and soft => init video player
  late Widget playerWidget;
  switch (streamingSoftware) {
    case StreamingSoftwareName.vlc:
      playerWidget = await _initVLCMediaPlayer(_item);
      break;
    case StreamingSoftwareName.exoplayer:
      playerWidget = await _initExoPlayerMediaPlayer(_item);
      break;
  }
  await customRouter.push(StreamRoute(player: playerWidget, item: _item));
}

Future<Widget> _initVLCMediaPlayer(Item item) async {
  if (Platform.isLinux || Platform.isWindows) {
    return await _initVlcComputerPlayer(item);
  } else {
    return await _initVlcPhonePlayer(item);
  }
}

Future<Widget> _initVlcComputerPlayer(Item item) async {
  final player = await CommonStreamVLCComputer.setupData(item: item);

  return Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Video(
        player: player,
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
    clipBehavior: Clip.none,
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

Future<Widget> _initExoPlayerMediaPlayer(Item item) async {
  // Setup data with Better Player
  final betterPlayerController = await CommonStreamBP.setupData(item: item);

  // Init widget player to use in Stream widget
  return BetterPlayer(
      key: betterPlayerController.betterPlayerGlobalKey,
      controller: betterPlayerController);
}
