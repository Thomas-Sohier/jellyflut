import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/api/api.dart';
import 'package:jellyflut/models/deviceProfileParent.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/playbackInfos.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/shared/exoplayer.dart';

import '../globals.dart';
import 'dio.dart';
import 'items.dart';

const platform = MethodChannel('com.example.jellyflut/videoPlayer');

Future<int> deleteActiveEncoding({String playSessionId}) async {
  var info = await deviceInfo();
  var queryParam = <String, String>{};
  queryParam['deviceId'] = info.id;
  queryParam['PlaySessionId'] =
      StreamModel().playBackInfos?.playSessionId ?? playSessionId;

  var url = '${server.url}/Videos/ActiveEncodings';

  Response response;
  try {
    response = await dio.delete(url, queryParameters: queryParam);
  } catch (e) {
    print(e);
  }
  if (response.statusCode == 204) {
    print('Stream decoding successfully deleted');
  } else {
    print('Stream encoding cannot be deleted, ${response.data}');
  }

  return response.statusCode;
}

Future<String> createURL(Item item, PlayBackInfos playBackInfos,
    {int startTick = 0, int audioStreamIndex, int subtitleStreamIndex}) async {
  var streamModel = StreamModel();
  var info = await deviceInfo();
  var queryParam = <String, String>{};
  queryParam['StartTimeTicks'] = startTick.toString();
  queryParam['Static'] = true.toString();
  queryParam['MediaSourceId'] = item.id;
  queryParam['DeviceId'] = info.id;
  queryParam['Tag'] = playBackInfos.mediaSources.first.eTag;
  if (subtitleStreamIndex != null) {
    queryParam['SubtitleStreamIndex'] = subtitleStreamIndex.toString();
  } else {
    queryParam['SubtitleStreamIndex'] =
        streamModel.subtitleStreamIndex.toString();
  }
  if (audioStreamIndex != null) {
    queryParam['AudioStreamIndex'] = audioStreamIndex.toString();
  } else {
    queryParam['AudioStreamIndex'] = streamModel.audioStreamIndex.toString();
  }
  queryParam['api_key'] = apiKey;

  var url =
      'Videos/${item.id}/stream.${playBackInfos.mediaSources.first.container}';

  var uri = Uri.https(
      server.url.replaceAll(RegExp('https?://'), ''), url, queryParam);
  return uri.toString();
}

Future<String> getItemURL(Item item) async {
  await bitrateTest(size: 500000);
  await bitrateTest(size: 1000000);
  await bitrateTest(size: 3000000);

  if (item.type == 'Episode' || item.type == 'Movie') {
    StreamModel().setItem(item);
    return getStreamURL(item: item);
  }
  return getFirstUnplayedItemURL(item);
}

Future<String> getFirstUnplayedItemURL(Item item) async {
  var category = await getItems(
      parentId: item.id, filter: 'IsNotFolder', fields: 'MediaStreams');
  // remove all item without an index to avoid sort error
  category.items.removeWhere((element) => element.indexNumber == null);
  // sort by index to get the next item to stream
  category.items.sort((a, b) => a.indexNumber.compareTo(b.indexNumber));
  var itemToPlay = category.items.firstWhere(
      (element) => !element.userData.played,
      orElse: () => category.items.first);
  return getStreamURL(item: itemToPlay);
}

Future<String> getStreamURL({Item item}) async {
  var data = await isCodecSupported(item, platform);
  var backInfos = await playbackInfos(data, item.id,
      startTimeTick: item.userData.playbackPositionTicks);
  var completeTranscodeUrl;
  var finalUrl;

  // Check if we have a transcide url or we create it
  if (backInfos.mediaSources.first.transcodingUrl != null) {
    completeTranscodeUrl =
        '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
  }
  finalUrl = completeTranscodeUrl ??
      await createURL(item, backInfos, startTick: item.runTimeTicks);
  // Current item, playbackinfos and stream url
  StreamModel().setItem(item);
  StreamModel().setPlaybackInfos(backInfos);
  StreamModel().setURL(finalUrl);
  return finalUrl;
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

Future<String> changeAudioSource(int audioIndex, {int playbackTick}) async {
  var streamModel = StreamModel();
  var item = streamModel.item;
  var backInfos = streamModel.playBackInfos;
  var startTick = (streamModel.betterPlayerController.videoPlayerController
          .value.position.inMicroseconds *
      10);

  if (backInfos.mediaSources.first.transcodingUrl != null) {
    var url = backInfos.mediaSources.first.transcodingUrl;
    var uri = Uri.parse(url);
    var queryParams = Map<String, String>.from(uri.queryParameters);
    queryParams['AudioStreamIndex'] = audioIndex.toString();
    return await Uri.https(server.url.replaceAll(RegExp('http?s://'), ''),
            Uri.parse(url).path, queryParams)
        .toString();
  }
  return createURL(item, backInfos,
      startTick: startTick, audioStreamIndex: audioIndex);
}

Future<String> getSubtitleURL(
    String itemId, String codec, int subtitleId) async {
  var mediaSourceId = itemId.substring(0, 8) +
      '-' +
      itemId.substring(8, 12) +
      '-' +
      itemId.substring(12, 16) +
      '-' +
      itemId.substring(16, 20) +
      '-' +
      itemId.substring(20, itemId.length);

  var parsedCodec = codec.substring(codec.indexOf('.') + 1);

  var queryParam = <String, String>{};
  queryParam['api_key'] = apiKey;

  var uri = Uri.https(
      server.url.replaceAll(RegExp('http?s://'), ''),
      '/Videos/${mediaSourceId}/${itemId}/Subtitles/${subtitleId}/0/Stream.${parsedCodec}',
      queryParam);
  return uri.origin + uri.path;
}

Future<dynamic> bitrateTest({@required int size}) async {
  var queryParams = <String, dynamic>{};
  queryParams['Size'] = size;

  var url = '${server.url}/Playback/BitrateTest';

  Response response;
  try {
    response = await dio.get(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  return response.data;
}
