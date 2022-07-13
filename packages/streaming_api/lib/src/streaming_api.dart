import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart';

/// {@template streaming_api}
/// A dart API client for the Jellyfin Streaming API
/// {@endtemplate}
class StreamingApi {
  /// {@macro streaming_api}
  StreamingApi({required String serverUrl, required Database database, String? userId, Dio? dioClient})
      : _dioClient = dioClient ?? Dio(),
        _serverUrl = serverUrl,
        _database = database,
        _userId = userId ?? _notLoggedUserId;

  static const _notLoggedUserId = '-1';
  final Dio _dioClient;
  final Database _database;
  String _userId;
  String _serverUrl;

  /// Update API properties
  /// UseFul when endpoint Server or user change
  void updateProperties({String? serverUrl, String? userId}) {
    _serverUrl = serverUrl ?? _serverUrl;
    _userId = userId ?? _userId;
  }

  Future<PlayBackInfos> getPlaybackInfos(DeviceProfileParent? profile, String itemId,
      {startTimeTick = 0, int? subtitleStreamIndex, int? audioStreamIndex, int? maxStreamingBitrate}) async {
    final user = await _database.userAppDao.getUserByJellyfinUserId(_userId);
    final settings = await _database.settingsDao.getSettingsById(user.settingsId);
    // Query params are deprecated but still used for older version of jellyfin server
    final queryParams = <String, dynamic>{};
    queryParams['UserId'] = _userId;
    queryParams['StartTimeTicks'] = startTimeTick;
    queryParams['IsPlayback'] = true;
    queryParams['AutoOpenLiveStream'] = true;
    queryParams['MaxStreamingBitrate'] = maxStreamingBitrate ?? settings.maxVideoBitrate;
    queryParams['VideoBitrate'] = settings.maxVideoBitrate.toString();
    queryParams['AudioBitrate'] = settings.maxAudioBitrate.toString();
    if (subtitleStreamIndex != null) queryParams['SubtitleStreamIndex'] = subtitleStreamIndex;
    if (audioStreamIndex != null) queryParams['AudioStreamIndex'] = audioStreamIndex;
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    profile ??= DeviceProfileParent();
    profile.userId ??= _userId;
    profile.enableDirectPlay ??= true;
    profile.allowAudioStreamCopy ??= true;
    profile.allowVideoStreamCopy ??= true;
    profile.enableTranscoding ??= true;
    profile.enableDirectStream ??= true;
    profile.autoOpenLiveStream ??= true;
    profile.deviceProfile ??= DeviceProfile();
    profile.audioStreamIndex ??= audioStreamIndex;
    profile.subtitleStreamIndex ??= subtitleStreamIndex;
    profile.startTimeTicks ??= startTimeTick;
    profile.maxStreamingBitrate ??= settings.maxVideoBitrate;

    final url = '$_serverUrl/Items/$itemId/PlaybackInfo';

    try {
      final response = await _dioClient.post(url, queryParameters: finalQueryParams, data: profile.toJson());
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
}
