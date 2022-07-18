import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'dart:convert' as convert;

/// {@template streaming_api}
/// A dart API client for the Jellyfin Streaming API
/// {@endtemplate}
class StreamingApi {
  /// {@macro streaming_api}
  StreamingApi({Dio? dioClient}) : _dioClient = dioClient ?? Dio();

  final Dio _dioClient;

  Future<PlayBackInfos> getPlaybackInfos(
      {required String serverUrl,
      required String userId,
      required String itemId,
      DeviceProfileParent? profile,
      int? startTimeTick,
      int? maxVideoBitrate,
      int? subtitleStreamIndex,
      int? maxAudioBitrate,
      int? audioStreamIndex,
      int? maxStreamingBitrate}) async {
    // Query params are deprecated but still used for older version of jellyfin server
    final queryParams = <String, dynamic>{};
    queryParams['UserId'] = userId;
    queryParams['StartTimeTicks'] = startTimeTick;
    queryParams['IsPlayback'] = true;
    queryParams['AutoOpenLiveStream'] = true;
    queryParams['MaxStreamingBitrate'] = maxStreamingBitrate;
    queryParams['VideoBitrate'] = maxVideoBitrate;
    queryParams['AudioBitrate'] = maxAudioBitrate;
    if (subtitleStreamIndex != null) queryParams['SubtitleStreamIndex'] = subtitleStreamIndex;
    if (audioStreamIndex != null) queryParams['AudioStreamIndex'] = audioStreamIndex;
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    profile ??= DeviceProfileParent();
    profile.deviceProfile ??= DeviceProfile();
    profile.userId ??= userId;
    profile.enableDirectPlay ??= true;
    profile.allowAudioStreamCopy ??= true;
    profile.allowVideoStreamCopy ??= true;
    profile.enableTranscoding ??= true;
    profile.enableDirectStream ??= true;
    profile.autoOpenLiveStream ??= true;
    profile.audioStreamIndex ??= audioStreamIndex;
    profile.subtitleStreamIndex ??= subtitleStreamIndex;
    profile.startTimeTicks ??= startTimeTick;
    profile.maxStreamingBitrate ??= maxStreamingBitrate;

    final url = '$serverUrl/Items/$itemId/PlaybackInfo';

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

  Future<int> deleteActiveEncoding(
      {required String serverUrl, required String userId, required String playSessionId}) async {
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParam = <String, String>{};
    queryParam['deviceId'] = info.id;
    queryParam['PlaySessionId'] = playSessionId;

    final url = '$serverUrl/Videos/ActiveEncodings';

    final response = await _dioClient.delete(url, queryParameters: queryParam);
    if (response.statusCode == 204) {
      print('Stream decoding successfully deleted');
      return response.statusCode!;
    } else {
      throw ('Stream encoding cannot be deleted, ${response.data}');
    }
  }

  void streamingProgress(
      {required String serverUrl, required String userId, required PlaybackProgress playbackProgress}) async {
    final url = '$serverUrl/Sessions/Playing/Progress';
    final playbackProgressJSON = playbackProgress.toMap();
    playbackProgressJSON.removeWhere((key, value) => value == null);

    final json = convert.json.encode(playbackProgressJSON);

    _dioClient.options.contentType = 'application/json';
    await _dioClient.post(url, data: json);
  }
}
