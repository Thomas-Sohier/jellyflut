import 'dart:async';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:universal_io/io.dart';

import 'package:better_player/better_player.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream_BP.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream_VLC.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream_VLC_computer.dart';
import 'package:jellyflut/screens/stream/components/player_interface.dart';

//----------------//
// ---- ITEM ---- //
//----------------//

class InitStreamingItemUtil {
  static Future<Widget> initFromItem({required Item item}) async {
    final controller = await initControllerFromItem(item: item);
    return PlayerInterface(controller: controller);
  }

  static Future<dynamic> initControllerFromItem({required Item item}) async {
    // FIXME
    // TODO put in repository
    throw UnimplementedError();
    // final context = context.router.root.navigatorKey.currentContext!;
    final db = AppDatabase().getDatabase;
    // final user = context.read<AuthenticationRepository>().currentUser;
    // final userApp = await db.userAppDao.getUserByJellyfinUserId(user.id);
    // final setting = await db.settingsDao.getSettingsById(userApp.settingsId);
    // final streamingSoftware = StreamingSoftware.fromString(setting.preferredPlayer);

    // We check if item is already downloaded before trying to get it from api
    final itemExist = await db.downloadsDao.doesExist(item.id);

    if (itemExist) {
      final download = await db.downloadsDao.getDownloadById(item.id);
      item = download.item!;
    } else {
      // item = await context.read<ItemsRepository>().getPlayableItemOrLastUnplayed(item: item);
    }
    StreamingProvider().setItem(item);

    // Depending the platform and soft => init video player
    // switch (streamingSoftware) {
    //   case StreamingSoftware.VLC:
    //     return _initVLCMediaPlayer(item);
    //   case StreamingSoftware.AVPLAYER:
    //   case StreamingSoftware.EXOPLAYER:
    //   default:
    //     return _initExoPlayerMediaPlayer(item);
    // }
  }

  static Future<dynamic> _initVLCMediaPlayer(Item item) async {
    if (Platform.isLinux || Platform.isWindows) {
      return await _initVlcComputerPlayer(item);
    } else {
      return await _initVlcPhonePlayer(item);
    }
  }

  static Future<Player> _initVlcComputerPlayer(Item item) async {
    return CommonStreamVLCComputer.setupData(item: item);
  }

  static Future<VlcPlayerController> _initVlcPhonePlayer(Item item) async {
    final vlcPlayerController = await CommonStreamVLC.setupData(item: item);

    vlcPlayerController.addOnInitListener(() async {
      await vlcPlayerController.startRendererScanning();
    });

    return vlcPlayerController;
  }

  static Future<BetterPlayerController> _initExoPlayerMediaPlayer(Item item) async {
    // Setup data with Better Player
    return CommonStreamBP.setupData(item: item);
  }
}

//----------------//
// ---- URL  ---- //
//----------------//

class InitStreamingUrlUtil {
  static Future<Widget> initFromUrl({required String url, required String streamName}) async {
    final controller = await initControllerFromUrl(url: url, streamName: streamName);
    final item = Item(id: '0', name: streamName, type: ItemType.Video);
    final streamingProvider = StreamingProvider();
    streamingProvider.setItem(item);
    streamingProvider.commonStream?.controller = controller;
    return PlayerInterface(controller: controller);
  }

  static Future<dynamic> initControllerFromUrl({required String url, required String streamName}) async {
    final streamingSoftwareDB = await AppDatabase().getDatabase.settingsDao.getSettingsById(userApp!.settingsId);
    final streamingSoftware = StreamingSoftware.fromString(streamingSoftwareDB.preferredPlayer);

    // Depending the platform and soft => init video player
    switch (streamingSoftware) {
      case StreamingSoftware.VLC:
        return _initVLCMediaPlayer(url);
      case StreamingSoftware.AVPLAYER:
      case StreamingSoftware.EXOPLAYER:
      default:
        return _initExoPlayerMediaPlayer(url);
    }
  }

  static Future<dynamic> _initVLCMediaPlayer(String url) async {
    if (Platform.isLinux || Platform.isWindows) {
      return _initVlcComputerPlayer(url);
    } else {
      return _initVlcPhonePlayer(url);
    }
  }

  static Future<Player> _initVlcComputerPlayer(String url) async {
    return CommonStreamVLCComputer.setupDataFromUrl(url: url);
  }

  static Future<VlcPlayerController> _initVlcPhonePlayer(String url) async {
    final vlcPlayerController = await CommonStreamVLC.setupDataFromUrl(url: url);

    vlcPlayerController.addOnInitListener(() async {
      await vlcPlayerController.startRendererScanning();
    });

    return vlcPlayerController;
  }

  static Future<BetterPlayerController> _initExoPlayerMediaPlayer(String url) async {
    // Setup data with Better Player
    return CommonStreamBP.setupDataFromURl(url: url);
  }
}
