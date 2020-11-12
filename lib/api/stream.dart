import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/api/api.dart';
import 'package:jellyflut/models/deviceProfileParent.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/playbackInfos.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/shared/exoplayer.dart';

import '../globals.dart';
import 'items.dart';

BaseOptions options = BaseOptions(
  connectTimeout: 60000,
  receiveTimeout: 60000,
  contentType: 'JSON',
);
const platform = MethodChannel('com.example.jellyflut/videoPlayer');

Dio dio = Dio(options);

Future<String> createURL(Item item, PlayBackInfos playBackInfos,
    {int startTick = 0}) async {
  var info = await deviceInfo();
  return '${server.url}/Videos/${item.id}/stream.${playBackInfos.mediaSources.first.container}?startTimeTicks=${startTick}&Static=true&mediaSourceId=${item.id}&deviceId=${info.id}&api_key=${apiKey}&Tag=${playBackInfos.mediaSources.first.eTag}';
}

Future<String> getItemURL(Item item) {
  if (item.type == 'Episode' || item.type == 'Movie') {
    StreamModel().setItem(item);
    return getStreamURL(item: item);
  }
  return getFirstUnplayedItemURL(item);
}

Future<String> getFirstUnplayedItemURL(Item item) async {
  var category =
      await getItems(item.id, filter: 'IsNotFolder', fields: 'MediaStreams');
  category.items.removeWhere((element) => element.indexNumber == null);
  category.items.sort((a, b) => a.indexNumber.compareTo(b.indexNumber));
  var itemToPlay = category.items.firstWhere(
      (element) => !element.userData.played,
      orElse: () => category.items.first);
  StreamModel().setItem(itemToPlay);
  return getStreamURL(item: itemToPlay);
}

Future<String> getStreamURL({Item item}) async {
  var data = await isCodecSupported(item, platform);
  // var dataJSON = json.encode(data);
  var backInfos = await playbackInfos(data, item.id,
      startTimeTick: item.userData.playbackPositionTicks);
  var completeTranscodeUrl;
  if (backInfos.mediaSources.first.transcodingUrl != null) {
    completeTranscodeUrl =
        '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
  }
  return completeTranscodeUrl ??
      await createURL(item, backInfos, startTick: item.runTimeTicks);
}

Future<String> isCodecSupported(Item item, MethodChannel platform) async {
  var result;
  // TODO finish this method to know if video can be direct play
  if (Platform.isAndroid) {
    var deviceProfile = await getExoplayerProfile();
    var x = DeviceProfileParent(deviceProfile: deviceProfile);
    result = x.toMap();
    // log(result);
  } else if (Platform.isIOS) {
    // TODO make IOS
    result = '';
  }
  log(result.toString());
  var x = json.encode(result);
  return x;
}
