import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:jellyflut_models/jellyflut_models.dart';

/// Exception thrown when live tv request fails.
class LiveTvRequestFailure implements Exception {
  final dynamic message;

  const LiveTvRequestFailure([this.message]);
}

/// Exception thrown when live tv channels request fails.
class LiveTvChannelsRequestFailure implements Exception {
  final dynamic message;

  const LiveTvChannelsRequestFailure([this.message]);
}

/// Exception thrown when live tv programs request fails.
class LiveTvProgramsRequestFailure implements Exception {
  final dynamic message;

  const LiveTvProgramsRequestFailure([this.message]);
}

/// Exception thrown when live tv guide request fails.
class LiveTvGuideRequestFailure implements Exception {
  final dynamic message;

  const LiveTvGuideRequestFailure([this.message]);
}

/// {@template live_tv_api}
/// A dart API client for the Jellyfin Live TV API
/// {@endtemplate}
class LiveTvApi {
  /// {@macro live_tv_api}
  LiveTvApi({required Dio? dioClient}) : _dioClient = dioClient ?? Dio();

  final Dio _dioClient;

  /// Method to retrieve TV channels from jellyfin API
  ///
  /// Can throw [LiveTvChannelsRequestFailure] on API error
  Future<Category> getChannels({
    required String serverUrl,
    String? type,
    String? userId,
    int? startIndex,
    bool? isSeries,
    bool? isNews,
    bool? isKids,
    bool? isSports,
    int? limit,
    bool? isFavorite,
    bool? isLiked,
    bool? isDisliked,
    bool? enableImages,
    int? imageTypeLimit,
    List<String>? enableImageTypes,
    List<String>? fields,
    bool? enableUserData,
    List<String>? sortBy,
    String? sortOrder,
    bool? enableFavoriteSorting,
    bool? addCurrentProgram,
  }) async {
    final queryParams = <String, dynamic>{};
    queryParams.putIfAbsent('type', () => type);
    queryParams.putIfAbsent('userId', () => userId);
    queryParams.putIfAbsent('startIndex', () => startIndex);
    queryParams.putIfAbsent('isSeries', () => isSeries);
    queryParams.putIfAbsent('isNews', () => isNews);
    queryParams.putIfAbsent('isKids', () => isKids);
    queryParams.putIfAbsent('isSports', () => isSports);
    queryParams.putIfAbsent('limit', () => limit);
    queryParams.putIfAbsent('isFavorite', () => isFavorite);
    queryParams.putIfAbsent('isLiked', () => isLiked);
    queryParams.putIfAbsent('isDisliked', () => isDisliked);
    queryParams.putIfAbsent('enableImages', () => enableImages);
    queryParams.putIfAbsent('imageTypeLimit', () => imageTypeLimit);
    queryParams.putIfAbsent('enableImageTypes', () => enableImageTypes);
    queryParams.putIfAbsent('fields', () => fields);
    queryParams.putIfAbsent('enableUserData', () => enableUserData);
    queryParams.putIfAbsent('sortBy', () => sortBy);
    queryParams.putIfAbsent('sortOrder', () => sortOrder);
    queryParams.putIfAbsent('enableFavoriteSorting', () => enableFavoriteSorting);
    queryParams.putIfAbsent('addCurrentProgram', () => addCurrentProgram);
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$serverUrl/LiveTv/Channels',
        queryParameters: finalQueryParams,
      );

      if (response.statusCode != 200) {
        throw LiveTvChannelsRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (e) {
      throw LiveTvChannelsRequestFailure(e);
    }
  }

  /// Method to retrieve TV programs from jellyfin API
  ///
  /// Can throw [LiveTvProgramsRequestFailure] on API error
  Future<Category> getPrograms(
      {required String serverUrl,
      List<String>? channelIds,
      String? userId,
      DateTime? minStartDate,
      bool? hasAired,
      bool? isAiring,
      DateTime? maxStartDate,
      DateTime? minEndDate,
      DateTime? maxEndDate,
      bool? isMovie,
      bool? isSeries,
      bool? isNews,
      bool? isKids,
      bool? isSports,
      int? startIndex,
      int? limit,
      List<String>? sortBy,
      List<String>? sortOrder,
      List<String>? genres,
      List<String>? genreIds,
      bool? enableImages,
      bool? enableTotalRecordCount,
      int? imageTypeLimit,
      List<String>? enableImageTypes,
      bool? enableUserData,
      String? seriesTimerId,
      String? librarySeriesId,
      List<String>? fields}) async {
    final queryParams = <String, dynamic>{};
    queryParams.putIfAbsent('channelIds', () => channelIds);
    queryParams.putIfAbsent('userId', () => userId);
    queryParams.putIfAbsent('minStartDate', () => minStartDate);
    queryParams.putIfAbsent('hasAired', () => hasAired);
    queryParams.putIfAbsent('isAiring', () => isAiring);
    queryParams.putIfAbsent('maxStartDate', () => maxStartDate);
    queryParams.putIfAbsent('minEndDate', () => minEndDate);
    queryParams.putIfAbsent('maxEndDate', () => maxEndDate);
    queryParams.putIfAbsent('isMovie', () => isMovie);
    queryParams.putIfAbsent('isSeries', () => isSeries);
    queryParams.putIfAbsent('isNews', () => isNews);
    queryParams.putIfAbsent('isKids', () => isKids);
    queryParams.putIfAbsent('isSports', () => isSports);
    queryParams.putIfAbsent('startIndex', () => startIndex);
    queryParams.putIfAbsent('limit', () => limit);
    queryParams.putIfAbsent('sortBy', () => sortBy);
    queryParams.putIfAbsent('sortOrder', () => sortOrder);
    queryParams.putIfAbsent('genres', () => genres);
    queryParams.putIfAbsent('genreIds', () => genreIds);
    queryParams.putIfAbsent('enableImages', () => enableImages);
    queryParams.putIfAbsent('enableTotalRecordCount', () => enableTotalRecordCount);
    queryParams.putIfAbsent('imageTypeLimit', () => imageTypeLimit);
    queryParams.putIfAbsent('enableImageTypes', () => enableImageTypes);
    queryParams.putIfAbsent('enableUserData', () => enableUserData);
    queryParams.putIfAbsent('seriesTimerId', () => seriesTimerId);
    queryParams.putIfAbsent('librarySeriesId', () => librarySeriesId);
    queryParams.putIfAbsent('fields', () => fields);
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    try {
      final response =
          await _dioClient.get<Map<String, dynamic>>('$serverUrl/LiveTv/Programs', queryParameters: finalQueryParams);

      if (response.statusCode != 200) {
        throw LiveTvProgramsRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (e) {
      throw LiveTvProgramsRequestFailure(e);
    }
  }

  /// Method to retrieve guide from jellyfin API
  ///
  /// Can throw [LiveTvGuideRequestFailure] on API error
  Future<Category> getGuideInfo(
      {required String serverUrl,
      int startIndex = 0,
      String fields = 'PrimaryImageAspectRatio',
      int limit = 100}) async {
    final queryParams = <String, dynamic>{};
    queryParams.putIfAbsent('serverUrl', () => serverUrl);
    queryParams.putIfAbsent('startIndex', () => startIndex);
    queryParams.putIfAbsent('fields', () => fields);
    queryParams.putIfAbsent('limit', () => limit);
    queryParams.putIfAbsent('fields', () => fields);
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    try {
      final response =
          await _dioClient.post<Map<String, dynamic>>('$serverUrl/LiveTv/GuideInfo', queryParameters: finalQueryParams);

      if (response.statusCode != 200) {
        throw LiveTvGuideRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (e) {
      throw LiveTvGuideRequestFailure(e);
    }
  }
}
