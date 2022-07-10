import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:jellyflut/shared/exoplayer.dart';
import 'package:jellyflut/shared/utils/uri_utils.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite_database/sqlite_database.dart';
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';

class StreamingService {
  final platform = MethodChannel('com.example.jellyflut/videoPlayer');

  static Future<int> deleteActiveEncoding() async {
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParam = <String, String>{};
    final streamingProvider = StreamingProvider();

    if (streamingProvider.playBackInfos == null || streamingProvider.playBackInfos!.playSessionId == null) return 200;

    queryParam['deviceId'] = info.id;
    queryParam['PlaySessionId'] = streamingProvider.playBackInfos!.playSessionId!;

    final url = '${server.url}/Videos/ActiveEncodings';

    return await dio.delete(url, queryParameters: queryParam).then((response) {
      if (response.statusCode == 204) {
        print('Stream decoding successfully deleted');
        return response.statusCode!;
      } else {
        throw ('Stream encoding cannot be deleted, ${response.data}');
      }
    });
  }

  static void streamingProgress(PlaybackProgress playbackProgress) {
    final url = '${server.url}/Sessions/Playing/Progress';
    final playbackProgressJSON = playbackProgress.toMap();
    playbackProgressJSON.removeWhere((key, value) => value == null);

    final json = convert.json.encode(playbackProgressJSON);

    dio.options.contentType = 'application/json';
    dio.post(url, data: json).then((_) => print('progress ok')).catchError((onError) => print(onError));
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
    final settings = await AppDatabase().getDatabase.settingsDao.getSettingsById(userApp!.settingsId);

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
    queryParams['AudioCodec'] = audioCodecDB != 'auto' ? audioCodecDB : audioCodec;
    queryParams['PlaySessionId'] = Uuid().v1();
    queryParams['StartTimeTicks'] = startTimeTicks.toString();
    queryParams['EnableRedirection'] = enableRedirection.toString();
    queryParams['EnableRemoteMedia'] = enableRemoteMedia.toString();
    queryParams['api_key'] = apiKey!;

    final url = 'Audio/$itemId/universal';

    return UriUtils.contructUrl(url, queryParams);
  }

  static Future<PlayBackInfos> playbackInfos(DeviceProfileParent? profile, String itemId,
      {startTimeTick = 0, int? subtitleStreamIndex, int? audioStreamIndex, int? maxStreamingBitrate}) async {
    final settings = await AppDatabase().getDatabase.settingsDao.getSettingsById(userApp!.settingsId);
    final streamingProvider = StreamingProvider();

    // Query params are deprecated but still used for older version of jellyfin server
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
      queryParams['SubtitleStreamIndex'] = streamingProvider.selectedSubtitleTrack!.jellyfinSubtitleIndex;
    }

    if (audioStreamIndex != null) {
      queryParams['AudioStreamIndex'] = audioStreamIndex;
    } else if (streamingProvider.selectedAudioTrack != null) {
      queryParams['AudioStreamIndex'] = streamingProvider.selectedAudioTrack!.jellyfinSubtitleIndex;
    }

    final finalAudioStreamIndex = audioStreamIndex ?? streamingProvider.selectedAudioTrack?.jellyfinSubtitleIndex;
    final finalSubtitleStreamIndex = subtitleStreamIndex ?? streamingProvider.selectedAudioTrack?.jellyfinSubtitleIndex;

    profile ??= DeviceProfileParent();
    profile.userId ??= userJellyfin!.id;
    profile.enableDirectPlay ??= true;
    profile.allowAudioStreamCopy ??= true;
    profile.allowVideoStreamCopy ??= true;
    profile.enableTranscoding ??= true;
    profile.enableDirectStream ??= true;
    profile.autoOpenLiveStream ??= true;
    profile.deviceProfile ??= DeviceProfile();
    profile.audioStreamIndex ??= finalAudioStreamIndex;
    profile.subtitleStreamIndex ??= finalSubtitleStreamIndex;
    profile.startTimeTicks ??= startTimeTick;
    profile.maxStreamingBitrate ??= settings.maxVideoBitrate;

    final url = '${server.url}/Items/$itemId/PlaybackInfo';

    try {
      final response = await dio.post(url, queryParameters: queryParams, data: profile.toJson());
      final playbackInfos = PlayBackInfos.fromJson(response.data);

      // If there is an error response from API then we throw an error
      if (playbackInfos.hasError()) {
        throw playbackInfos.getErrorMessage();
      }

      return playbackInfos;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<String> createURL(Item item, PlayBackInfos playBackInfos,
      {int startTick = 0, int? audioStreamIndex, int? subtitleStreamIndex}) async {
    final streamModel = StreamingProvider();
    final settings = await AppDatabase().getDatabase.settingsDao.getSettingsById(userApp!.settingsId);
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParam = <String, String?>{};
    queryParam['StartTimeTicks'] = startTick.toString();
    queryParam['Static'] = true.toString();
    queryParam['MediaSourceId'] = item.id;
    queryParam['DeviceId'] = info.id;
    queryParam['VideoBitrate'] = settings.maxVideoBitrate.toString();
    queryParam['AudioBitrate'] = settings.maxAudioBitrate.toString();
    if (playBackInfos.mediaSources.isNotEmpty && playBackInfos.mediaSources.first.eTag != null) {
      queryParam['Tag'] = playBackInfos.mediaSources.first.eTag!;
    }
    if (subtitleStreamIndex != null) {
      queryParam['SubtitleStreamIndex'] = subtitleStreamIndex.toString();
    } else if (streamModel.selectedSubtitleTrack != null) {
      queryParam['SubtitleStreamIndex'] = streamModel.selectedSubtitleTrack!.jellyfinSubtitleIndex.toString();
    }
    if (audioStreamIndex != null) {
      queryParam['AudioStreamIndex'] = audioStreamIndex.toString();
    } else if (streamModel.selectedAudioTrack != null) {
      queryParam['AudioStreamIndex'] = streamModel.selectedAudioTrack!.jellyfinSubtitleIndex.toString();
    }
    queryParam['api_key'] = apiKey!;

    queryParam.removeWhere((key, value) => value == null || value == 'null');

    late final path;
    switch (item.type) {
      case ItemType.TvChannel:
        final playbackPath = Uri.parse(playBackInfos.mediaSources[0].path!);
        path = playbackPath.path;
        break;
      default:
        final ext = p.extension(playBackInfos.mediaSources.first.path!);
        path = 'Videos/${item.id}/stream$ext';
    }
    return UriUtils.contructUrl(path, queryParam);
  }

  static Future<DeviceProfileParent?> isCodecSupported() async {
    final profiles = PlayersProfile();
    // TODO make IOS
    if (kIsWeb) {
      final playerProfile = profiles.webOs;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    } else if (Platform.isAndroid) {
      final streamingSoftwareDB = await AppDatabase().getDatabase.settingsDao.getSettingsById(userApp!.settingsId);
      final streamingSoftware = StreamingSoftware.fromString(streamingSoftwareDB.preferredPlayer);

      switch (streamingSoftware) {
        case StreamingSoftware.VLC:
          final playerProfile = profiles.vlcPhone;
          return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
        case StreamingSoftware.EXOPLAYER:
        case StreamingSoftware.AVPLAYER:
        default:
          final deviceProfile = await getExoplayerProfile();
          return DeviceProfileParent(deviceProfile: deviceProfile);
      }
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final playerProfile = profiles.vlcComputer;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    }
    return null;
  }

  static Future<String> getNewAudioSource(int audioIndex, {Duration? playbackTick}) async {
    var streamModel = StreamingProvider();
    var item = streamModel.item;
    var backInfos = streamModel.playBackInfos;
    var startTick = playbackTick != null ? playbackTick.inMicroseconds * 10 : 0;

    if (backInfos!.mediaSources.first.transcodingUrl != null) {
      var url = backInfos.mediaSources.first.transcodingUrl;
      var uri = Uri.parse(url!);
      var queryParams = Map<String, String>.from(uri.queryParameters);
      queryParams['AudioStreamIndex'] = audioIndex.toString();
      return UriUtils.contructUrl(url, queryParams);
    }
    return createURL(item!, backInfos, startTick: startTick, audioStreamIndex: audioIndex);
  }

  static Future<String> getNewSubtitleSource(int subtitleIndex, {Duration? playbackTick}) async {
    var streamModel = StreamingProvider();
    var item = streamModel.item;
    var backInfos = streamModel.playBackInfos;
    var startTick = playbackTick != null ? playbackTick.inMicroseconds * 10 : 0;

    if (backInfos!.mediaSources.first.transcodingUrl != null) {
      var url = backInfos.mediaSources.first.transcodingUrl;
      var uri = Uri.parse(url!);
      var queryParams = Map<String, String>.from(uri.queryParameters);
      queryParams['SubtitleStreamIndex'] = subtitleIndex.toString();
      UriUtils.contructUrl(url, queryParams);
    }
    return createURL(item!, backInfos, startTick: startTick, subtitleStreamIndex: subtitleIndex);
  }

  static String getSubtitleURL(String itemId, String codec, int subtitleId) {
    var mediaSourceId = _generateItemIdWithHyphen(itemId);

    final parsedCodec = codec.substring(codec.indexOf('.') + 1);
    final path = '/Videos/$mediaSourceId/$itemId/Subtitles/$subtitleId/0/Stream.$parsedCodec';

    final queryParams = <String, String>{};
    queryParams['api_key'] = apiKey!;

    return UriUtils.contructUrl(path, queryParams);
  }

  static String _generateItemIdWithHyphen(String id) {
    return '${id.substring(0, 8)}-${id.substring(8, 12)}-${id.substring(12, 16)}-${id.substring(16, 20)}-${id.substring(20, id.length)}';
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
