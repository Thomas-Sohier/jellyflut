import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'dart:convert' as convert;

abstract class StreamingException implements Exception {
  final String message;

  const StreamingException(this.message);
}

class CannotGetDevicePlaybackCapabilities extends StreamingException {
  const CannotGetDevicePlaybackCapabilities(super.message);
}

class DevicePlaybackCapabilities extends StreamingException {
  const DevicePlaybackCapabilities(super.message);
}

class StreamCannotBeDeleted extends StreamingException {
  const StreamCannotBeDeleted(super.message);
}

class CannotSendProgress extends StreamingException {
  const CannotSendProgress(super.message);
}

/// {@template streaming_api}
/// A dart API client for the Jellyfin Streaming API
/// {@endtemplate}
class StreamingApi {
  /// {@macro streaming_api}
  StreamingApi({Dio? dioClient}) : _dioClient = dioClient ?? Dio();

  final Dio _dioClient;

  /// Ask jellyfin for playback infos. If current device profile is passed
  /// response may contains an URL which can be used to stream this item.
  /// If not can contains an error message.
  ///
  /// If response contains error message throw [DevicePlaybackCapabilities] with response error message
  /// On api call error, throw [CannotGetDevicePlaybackCapabilities] with api call error
  /// On any other error, throw [CannotGetDevicePlaybackCapabilities]
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
    if (subtitleStreamIndex != null) {
      queryParams['SubtitleStreamIndex'] = subtitleStreamIndex;
    }
    if (audioStreamIndex != null) {
      queryParams['AudioStreamIndex'] = audioStreamIndex;
    }
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams =
        queryParams.map((key, value) => MapEntry(key, value.toString()));

    profile ??= DeviceProfileParent();
    profile.deviceProfile ??= DeviceProfile();
    profile.userId ??= userId;
    profile.enableDirectPlay ??= true;
    profile.enableTranscoding ??= true;
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
      final response = await _dioClient.post(url,
          queryParameters: finalQueryParams, data: profile.toJson());
      final playbackInfos = PlayBackInfos.fromJson(response.data);

      // If there is an error response from API then we throw an error
      if (playbackInfos.hasError()) {
        throw DevicePlaybackCapabilities(playbackInfos.getErrorMessage());
      }

      return playbackInfos;
    } on DioError catch (e) {
      throw CannotGetDevicePlaybackCapabilities(e.message);
    } catch (_) {
      throw CannotGetDevicePlaybackCapabilities('Unknown Error');
    }
  }

  /// Send current streaming progress to Jellyfin
  ///
  /// On status code different than 204, throw [CannotSendProgress] with default message
  /// On api call error, throw [CannotSendProgress] with api call error
  /// On any other error, throw [CannotSendProgress]
  Future<int> deleteActiveEncoding(
      {required String serverUrl,
      required String userId,
      required String playSessionId}) async {
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParam = <String, String>{};
    queryParam['deviceId'] = info.id;
    queryParam['PlaySessionId'] = playSessionId;

    final url = '$serverUrl/Videos/ActiveEncodings';

    try {
      final response =
          await _dioClient.delete(url, queryParameters: queryParam);
      if (response.statusCode == 204) {
        print('Stream decoding successfully deleted');
        return response.statusCode!;
      } else {
        throw StreamCannotBeDeleted(
            'Stream encoding cannot be deleted, ${response.data}');
      }
    } on DioError catch (e) {
      throw StreamCannotBeDeleted(e.message);
    } catch (_) {
      throw StreamCannotBeDeleted('Unknown Error');
    }
  }

  /// Send current streaming progress to Jellyfin
  ///
  /// On status code different than 204, throw [CannotSendProgress] with default message
  /// On api call error, throw [CannotSendProgress] with api call error
  /// On any other error, throw [CannotSendProgress]
  void streamingProgress(
      {required String serverUrl,
      required String userId,
      required PlaybackProgress playbackProgress}) async {
    final url = '$serverUrl/Sessions/Playing/Progress';
    final playbackProgressJSON = playbackProgress.toMap();
    playbackProgressJSON.removeWhere((key, value) => value == null);

    final json = convert.json.encode(playbackProgressJSON);

    try {
      final response = await _dioClient.post(url,
          options: Options(contentType: ContentType.json.value), data: json);
      if (response.statusCode != 204) {
        throw CannotSendProgress('Error reporting streaming progress');
      }
    } on DioError catch (e) {
      throw CannotSendProgress(e.message);
    } catch (_) {
      throw CannotSendProgress('Unknown Error');
    }
  }
}
