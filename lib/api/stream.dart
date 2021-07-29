import 'dart:convert';
import 'package:jellyflut/models/device.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:jellyflut/models/deviceProfileParent.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/playbackInfos.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/shared/exoplayer.dart';

import '../globals.dart';
import 'dio.dart';

const platform = MethodChannel('com.example.jellyflut/videoPlayer');

Future<int> deleteActiveEncoding() async {
  var info = await DeviceInfo.getCurrentDeviceInfo();
  var queryParam = <String, String>{};
  queryParam['deviceId'] = info.id;
  queryParam['PlaySessionId'] = StreamModel().playBackInfos!.playSessionId;

  var url = '${server.url}/Videos/ActiveEncodings';

  try {
    var response = await dio.delete(url, queryParameters: queryParam);
    if (response.statusCode == 204) {
      print('Stream decoding successfully deleted');
    } else {
      print('Stream encoding cannot be deleted, ${response.data}');
      throw ('Stream encoding cannot be deleted, ${response.data}');
    }
    return response.statusCode!;
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<String> createURL(Item item, PlayBackInfos playBackInfos,
    {int startTick = 0,
    int? audioStreamIndex,
    int? subtitleStreamIndex}) async {
  var streamModel = StreamModel();
  var info = await DeviceInfo.getCurrentDeviceInfo();
  var queryParam = <String, String>{};
  queryParam['StartTimeTicks'] = startTick.toString();
  queryParam['Static'] = true.toString();
  queryParam['MediaSourceId'] = item.id;
  queryParam['DeviceId'] = info.id;
  queryParam['Tag'] = playBackInfos.mediaSources.first.eTag!;
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
  queryParam['api_key'] = apiKey!;

  var extension = p.extension(playBackInfos.mediaSources.first.path!);

  var url = 'Videos/${item.id}/stream$extension';

  var uri = Uri.https(
      server.url.replaceAll(RegExp('https?://'), ''), url, queryParam);
  return uri.toString();
}

Future<String> isCodecSupported() async {
  var result;
  // TODO finish this method to know if video can be direct play
  if (Platform.isAndroid) {
    var deviceProfile = await getExoplayerProfile();
    result = DeviceProfileParent(deviceProfile: deviceProfile).toMap();
    // log(result);
  } else if (Platform.isIOS) {
    // TODO make IOS
    result = '';
  }
  // log(result.toString());;
  return json.encode(result);
}

Future<String> getNewAudioSource(int audioIndex,
    {Duration? playbackTick}) async {
  var streamModel = StreamModel();
  var item = streamModel.item;
  var backInfos = streamModel.playBackInfos;
  var startTick = playbackTick != null ? playbackTick.inMicroseconds * 10 : 0;

  if (backInfos!.mediaSources.first.transcodingUrl != null) {
    var url = backInfos.mediaSources.first.transcodingUrl;
    var uri = Uri.parse(url!);
    var queryParams = Map<String, String>.from(uri.queryParameters);
    queryParams['AudioStreamIndex'] = audioIndex.toString();
    return Uri.https(server.url.replaceAll(RegExp('http?s://'), ''),
            Uri.parse(url).path, queryParams)
        .toString();
  }
  return createURL(item!, backInfos,
      startTick: startTick, audioStreamIndex: audioIndex);
}

Future<String> getNewSubtitleSource(int subtitleIndex,
    {Duration? playbackTick}) async {
  var streamModel = StreamModel();
  var item = streamModel.item;
  var backInfos = streamModel.playBackInfos;
  var startTick = playbackTick != null ? playbackTick.inMicroseconds * 10 : 0;

  if (backInfos!.mediaSources.first.transcodingUrl != null) {
    var url = backInfos.mediaSources.first.transcodingUrl;
    var uri = Uri.parse(url!);
    var queryParams = Map<String, String>.from(uri.queryParameters);
    queryParams['SubtitleStreamIndex'] = subtitleIndex.toString();
    return Uri.https(server.url.replaceAll(RegExp('http?s://'), ''),
            Uri.parse(url).path, queryParams)
        .toString();
  }
  return createURL(item!, backInfos,
      startTick: startTick, subtitleStreamIndex: subtitleIndex);
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
  queryParam['api_key'] = apiKey!;

  var uri = Uri.https(
      server.url.replaceAll(RegExp('http?s://'), ''),
      '/Videos/$mediaSourceId/$itemId/Subtitles/$subtitleId/0/Stream.$parsedCodec',
      queryParam);
  return uri.origin + uri.path;
}

Future<dynamic> bitrateTest({required int size}) async {
  var queryParams = <String, dynamic>{};
  queryParams['Size'] = size;

  var url = '${server.url}/Playback/BitrateTest';

  try {
    return await dio.get(url, queryParameters: queryParams)
      ..data;
  } catch (e) {
    print(e);
  }
}
