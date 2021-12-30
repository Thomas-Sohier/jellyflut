import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/streaming_software.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/components/common_controls.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream_BP.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream_VLC.dart';
import 'package:jellyflut/screens/stream/CommonStream/common_stream_VLC_computer.dart';
import 'package:jellyflut/services/item/item_service.dart';

//----------------//
// ---- ITEM ---- //
//----------------//

class InitStreamingItemUtil {
  static Future<Widget> initFromItem({required Item item}) async {
    final streamingSoftwareDB = await AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp!.settingsId);
    final streamingSoftware = StreamingSoftwareName.values.firstWhere((e) =>
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
    return playerWidget;
    // await customRouter.push(StreamRoute(player: playerWidget, item: _item));
  }

  static Future<Widget> _initVLCMediaPlayer(Item item) async {
    if (Platform.isLinux || Platform.isWindows) {
      return await _initVlcComputerPlayer(item);
    } else {
      return await _initVlcPhonePlayer(item);
    }
  }

  static Future<Widget> _initVlcComputerPlayer(Item item) async {
    final player = await CommonStreamVLCComputer.setupData(item: item);

    // If no error while init then play
    player.play();

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

  static Future<Widget> _initVlcPhonePlayer(Item item) async {
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

  static Future<Widget> _initExoPlayerMediaPlayer(Item item) async {
    // Setup data with Better Player
    final betterPlayerController = await CommonStreamBP.setupData(item: item);

    // Init widget player to use in Stream widget
    return BetterPlayer(
        key: betterPlayerController.betterPlayerGlobalKey,
        controller: betterPlayerController);
  }
}

//----------------//
// ---- URL  ---- //
//----------------//

class InitStreamingUrlUtil {
  static Future<Widget> initFromUrl(
      {required String url, required String streamName}) async {
    final streamingSoftwareDB = await AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp!.settingsId);
    final streamingSoftware = StreamingSoftwareName.values.firstWhere((e) =>
        e.toString() ==
        'StreamingSoftwareName.' + streamingSoftwareDB.preferredPlayer);
    final _item = Item(id: '0', name: streamName, type: ItemType.VIDEO);
    StreamingProvider().setItem(_item);

    // Depending the platform and soft => init video player
    late Widget playerWidget;
    switch (streamingSoftware) {
      case StreamingSoftwareName.vlc:
        playerWidget = await _initVLCMediaPlayer(url);
        break;
      case StreamingSoftwareName.exoplayer:
        playerWidget = await _initExoPlayerMediaPlayer(url);
        break;
    }
    return playerWidget;
  }

  static Future<Widget> _initVLCMediaPlayer(String url) async {
    if (Platform.isLinux || Platform.isWindows) {
      return await _initVlcComputerPlayer(url);
    } else {
      return await _initVlcPhonePlayer(url);
    }
  }

  static Future<Widget> _initVlcComputerPlayer(String url) async {
    final player = await CommonStreamVLCComputer.setupDataFromUrl(url: url);

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

  static Future<Widget> _initVlcPhonePlayer(String url) async {
    final vlcPlayerController =
        await CommonStreamVLC.setupDataFromUrl(url: url);

    vlcPlayerController.addOnInitListener(() async {
      await vlcPlayerController.startRendererScanning();
    });

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: <Widget>[
        VlcPlayer(
          controller: vlcPlayerController,
          aspectRatio: 16 / 9,
          placeholder: Center(child: CircularProgressIndicator()),
        ),
        CommonControls(),
      ],
    );
  }

  static Future<Widget> _initExoPlayerMediaPlayer(String url) async {
    // Setup data with Better Player
    final betterPlayerController =
        await CommonStreamBP.setupDataFromURl(url: url);

    // Init widget player to use in Stream widget
    return BetterPlayer(
        key: betterPlayerController.betterPlayerGlobalKey,
        controller: betterPlayerController);
  }
}
