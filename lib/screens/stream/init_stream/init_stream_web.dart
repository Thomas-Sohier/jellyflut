import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/screens/stream/common_stream/common_stream_video_player.dart';
import 'package:jellyflut/screens/stream/components/player_interface.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart';

//----------------//
// ---- ITEM ---- //
//----------------//

class InitStreamingItemUtil {
  static Future<Widget> initFromItem({required Item item}) async {
    final controller = await initControllerFromItem(item: item);
    final streamingProvider = StreamingProvider();
    streamingProvider.setItem(item);
    return PlayerInterface(controller: controller);
  }

  static Future<dynamic> initControllerFromItem({required Item item}) async {
    final db = AppDatabase().getDatabase;
    final setting = await db.settingsDao.getSettingsById(userApp!.settingsId);
    final streamingSoftware =
        StreamingSoftware.fromString(setting.preferredPlayer);

    // We check if item is already downloaded before trying to get it from api
    final tempItem = await item.getPlayableItemOrLastUnplayed();
    item = await ItemService.getItem(tempItem.id);

    // Depending the platform and soft => init video player
    switch (streamingSoftware) {
      case StreamingSoftware.HTMLPlayer:
        return _initVideoPlayer(item);
      default:
        throw UnsupportedError(
            'No suitable player controller implementation was found.');
    }
  }

  static Future<dynamic> _initVideoPlayer(Item item) async {
    return CommonStreamVideoPlayer.setupData(item: item);
  }
}

//----------------//
// ---- URL  ---- //
//----------------//

class InitStreamingUrlUtil {
  static Future<Widget> initFromUrl(
      {required String url, required String streamName}) async {
    final controller =
        await initControllerFromUrl(url: url, streamName: streamName);
    final item = Item(id: '0', name: streamName, type: ItemType.VIDEO);
    final streamingProvider = StreamingProvider();
    streamingProvider.setItem(item);
    streamingProvider.commonStream?.controller = controller;
    return PlayerInterface(controller: controller);
  }

  static Future<dynamic> initControllerFromUrl(
      {required String url, required String streamName}) async {
    final streamingSoftwareDB = await AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp!.settingsId);
    final streamingSoftware =
        StreamingSoftware.fromString(streamingSoftwareDB.preferredPlayer);

    // Depending the platform and soft => init video player
    switch (streamingSoftware) {
      case StreamingSoftware.HTMLPlayer:
        return _initVideoPlayer(url);
      default:
        throw UnsupportedError(
            'No suitable player controller implementation was found.');
    }
  }

  static Future<dynamic> _initVideoPlayer(String url) async {
    return CommonStreamVideoPlayer.setupDataFromUrl(url: url);
  }
}
