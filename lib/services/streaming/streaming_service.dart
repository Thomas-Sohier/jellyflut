import 'dart:convert';
import 'dart:developer';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/jellyfin/media_played_infos.dart';
import 'package:jellyflut/models/jellyfin/device.dart';
import 'package:jellyflut/models/jellyfin/device_profile_parent.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/models/jellyfin/playback_infos.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/shared/exoplayer.dart';
import 'package:uuid/uuid.dart';

class StreamingService {
  final platform = MethodChannel('com.example.jellyflut/videoPlayer');

  static Future<int> deleteActiveEncoding() async {
    var info = await DeviceInfo.getCurrentDeviceInfo();
    var queryParam = <String, String>{};
    queryParam['deviceId'] = info.id;
    queryParam['PlaySessionId'] =
        StreamingProvider().playBackInfos!.playSessionId;

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
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static void streamingProgress(Item item,
      {bool isMuted = false,
      bool isPaused = false,
      bool canSeek = true,
      int positionTicks = 0,
      int volumeLevel = 100,
      int? subtitlesIndex}) {
    final mediaPlayedInfos = MediaPlayedInfos();
    mediaPlayedInfos.isMuted = isMuted;
    mediaPlayedInfos.isPaused = isPaused;
    mediaPlayedInfos.canSeek = true;
    mediaPlayedInfos.itemId = item.id;
    mediaPlayedInfos.mediaSourceId = item.id;
    mediaPlayedInfos.positionTicks = positionTicks * 10;
    mediaPlayedInfos.volumeLevel = volumeLevel;
    mediaPlayedInfos.subtitleStreamIndex = subtitlesIndex ?? -1;

    final url = '${server.url}/Sessions/Playing/Progress';

    final _mediaPlayedInfos = mediaPlayedInfos.toJson();
    _mediaPlayedInfos.removeWhere((key, value) => value == null);

    final _json = json.encode(_mediaPlayedInfos);

    dio.options.contentType = 'application/json';
    dio
        .post(url, data: _json)
        .then((_) => print('progress ok'))
        .catchError((onError) => print(onError));
  }

  static Future<String> contructAudioURL(
      {required String itemId,
      int? maxStreamingBitrate,
      String container = 'opus,mp3|mp3,aac,m4a,m4b|aac,flac,webma,webm,wav,ogg',
      String transcodingContainer = 'ts',
      String transcodingProtocol = 'hls',
      String audioCodec = 'aac',
      int startTimeTicks = 0,
      bool enableRedirection = true,
      bool enableRemoteMedia = false}) async {
    // Get users settings
    final settings = await AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp!.settingsId);

    maxStreamingBitrate ??= settings.maxVideoBitrate;
    final audioCodecDB = settings.preferredTranscodeAudioCodec;
    final dInfo = await DeviceInfo.getCurrentDeviceInfo();
    final queryParams = <String, String>{};
    queryParams['UserId'] = userJellyfin!.id;
    queryParams['DeviceId'] = dInfo.id;
    queryParams['MaxStreamingBitrate'] = maxStreamingBitrate.toString();
    queryParams['Container'] = container;
    queryParams['TranscodingContainer'] = transcodingContainer;
    queryParams['TranscodingProtocol'] = transcodingProtocol;
    queryParams['AudioCodec'] =
        audioCodecDB != 'auto' ? audioCodecDB : audioCodec;
    queryParams['PlaySessionId'] = Uuid().v1();
    queryParams['StartTimeTicks'] = startTimeTicks.toString();
    queryParams['EnableRedirection'] = enableRedirection.toString();
    queryParams['EnableRemoteMedia'] = enableRemoteMedia.toString();
    queryParams['api_key'] = apiKey!;

    final url = 'Audio/$itemId/universal';

    final uri = Uri.https(
        server.url.replaceAll(RegExp('https?://'), ''), url, queryParams);
    return uri.toString();
  }

  static Future<PlayBackInfos> playbackInfos(String? json, String itemId,
      {startTimeTick = 0,
      int? subtitleStreamIndex,
      int? audioStreamIndex,
      int? maxStreamingBitrate}) async {
    final settings = await AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp!.settingsId);
    final streamingProvider = StreamingProvider();
    final queryParams = <String, dynamic>{};
    queryParams['UserId'] = userJellyfin!.id;
    queryParams['StartTimeTicks'] = startTimeTick;
    queryParams['IsPlayback'] = true;
    queryParams['AutoOpenLiveStream'] = true;
    // queryParams['MaxStreamingBitrate'] = maxStreamingBitrate ?? settings.maxVideoBitrate;
    queryParams['VideoBitrate'] = settings.maxVideoBitrate.toString();
    queryParams['AudioBitrate'] = settings.maxAudioBitrate.toString();
    if (subtitleStreamIndex != null) {
      queryParams['SubtitleStreamIndex'] = subtitleStreamIndex;
    } else if (streamingProvider.selectedSubtitleTrack != null) {
      queryParams['SubtitleStreamIndex'] =
          streamingProvider.selectedSubtitleTrack!.jellyfinSubtitleIndex;
    }
    if (audioStreamIndex != null) {
      queryParams['AudioStreamIndex'] = audioStreamIndex;
    } else if (streamingProvider.selectedAudioTrack != null) {
      queryParams['AudioStreamIndex'] =
          streamingProvider.selectedAudioTrack!.jellyfinSubtitleIndex;
    }

    final url = '${server.url}/Items/$itemId/PlaybackInfo';

    try {
      final response = await dio.post(
        url,
        queryParameters: queryParams,
        data: json,
      );
      return PlayBackInfos.fromMap(response.data);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<String> createURL(Item item, PlayBackInfos playBackInfos,
      {int startTick = 0,
      int? audioStreamIndex,
      int? subtitleStreamIndex}) async {
    final streamModel = StreamingProvider();
    final settings = await AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp!.settingsId);
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParam = <String, String>{};
    queryParam['StartTimeTicks'] = startTick.toString();
    queryParam['Static'] = true.toString();
    queryParam['MediaSourceId'] = item.id;
    queryParam['DeviceId'] = info.id;
    queryParam['VideoBitrate'] = settings.maxVideoBitrate.toString();
    queryParam['AudioBitrate'] = settings.maxAudioBitrate.toString();
    if (playBackInfos.mediaSources.isNotEmpty &&
        playBackInfos.mediaSources.first.eTag != null) {
      queryParam['Tag'] = playBackInfos.mediaSources.first.eTag!;
    }
    if (subtitleStreamIndex != null) {
      queryParam['SubtitleStreamIndex'] = subtitleStreamIndex.toString();
    } else if (streamModel.selectedSubtitleTrack != null) {
      queryParam['SubtitleStreamIndex'] =
          streamModel.selectedSubtitleTrack!.jellyfinSubtitleIndex.toString();
    }
    if (audioStreamIndex != null) {
      queryParam['AudioStreamIndex'] = audioStreamIndex.toString();
    } else if (streamModel.selectedAudioTrack != null) {
      queryParam['AudioStreamIndex'] =
          streamModel.selectedAudioTrack!.jellyfinSubtitleIndex.toString();
    }
    queryParam['api_key'] = apiKey!;

    // TODO rework that shit to be more readable and clear
    late final url;
    switch (item.type) {
      case ItemType.TVCHANNEL:
        url = 'videos/${item.id}/master.m3u8';
        break;
      default:
        final ext = p.extension(playBackInfos.mediaSources.first.path!);
        url = 'Videos/${item.id}/stream$ext';
    }

    final uri = Uri.https(
        server.url.replaceAll(RegExp('https?://'), ''), url, queryParam);
    return uri.toString();
  }

  static Future<String?> isCodecSupported() async {
    // TODO make IOS/Linux/Windows/Macos....
    if (Platform.isAndroid) {
      final deviceProfile = await getExoplayerProfile();
      return json
          .encode(DeviceProfileParent(deviceProfile: deviceProfile).toMap());
    }
    return null;
  }

  static Future<String> getNewAudioSource(int audioIndex,
      {Duration? playbackTick}) async {
    var streamModel = StreamingProvider();
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

  static Future<String> getNewSubtitleSource(int subtitleIndex,
      {Duration? playbackTick}) async {
    var streamModel = StreamingProvider();
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

  static String getSubtitleURL(String itemId, String codec, int subtitleId) {
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

  static Future<dynamic> bitrateTest({required int size}) async {
    var queryParams = <String, dynamic>{};
    queryParams['Size'] = size;

    var url = '${server.url}/Playback/BitrateTest';

    try {
      return await dio.get(url, queryParameters: queryParams)
        ..data;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }
}
