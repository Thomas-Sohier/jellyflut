import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:live_tv_api/live_tv_api.dart';
import 'package:live_tv_repository/src/models/channel.dart';
import 'package:live_tv_repository/src/models/parse_channel_from_jellyfin.dart';

/// {@template live_tv_repository}
/// A repository that handles liveTv related requests
/// {@endtemplate}
class LiveTvRepository {
  /// {@macro live_tv_repository}
  const LiveTvRepository({required LiveTvApi liveTvApi, required AuthenticationRepository authenticationRepository})
      : _liveTvApi = liveTvApi,
        _authenticationRepository = authenticationRepository;

  final LiveTvApi _liveTvApi;
  final AuthenticationRepository _authenticationRepository;

  String get currentServerUrl => _authenticationRepository.currentServer.url;
  String get currentUserId => _authenticationRepository.currentUser.id;

  /// Method to retrieve TV channels from jellyfin API
  ///
  /// Can throw [LiveTvChannelsRequestFailure] on API error
  Future<List<Item>> getChannels(
      {String? type,
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
      bool? addCurrentProgram}) async {
    final category = await _liveTvApi.getChannels(
      serverUrl: currentServerUrl,
      userId: currentUserId,
      type: type,
      startIndex: startIndex,
      isSeries: isSeries,
      isNews: isNews,
      isKids: isKids,
      isSports: isSports,
      limit: limit,
      isFavorite: isFavorite,
      isLiked: isLiked,
      isDisliked: isDisliked,
      enableImages: enableImages,
      imageTypeLimit: imageTypeLimit,
      enableImageTypes: enableImageTypes,
      fields: fields,
      enableUserData: enableUserData,
      sortBy: sortBy,
      sortOrder: sortOrder,
      enableFavoriteSorting: enableFavoriteSorting,
      addCurrentProgram: addCurrentProgram,
    );
    return category.items;
  }

  /// Method to retrieve TV programs from jellyfin API
  ///
  /// Can throw [LiveTvProgramsRequestFailure] on API error
  Future<List<Item>> getPrograms(
      {List<String>? channelIds,
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
    final category = await _liveTvApi.getPrograms(
        serverUrl: currentServerUrl,
        userId: currentUserId,
        channelIds: channelIds,
        minStartDate: minStartDate,
        hasAired: hasAired,
        isAiring: isAiring,
        maxStartDate: maxStartDate,
        minEndDate: minEndDate,
        maxEndDate: maxEndDate,
        isMovie: isMovie,
        isSeries: isSeries,
        isNews: isNews,
        isKids: isKids,
        isSports: isSports,
        startIndex: startIndex,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        genres: genres,
        genreIds: genreIds,
        enableImages: enableImages,
        enableTotalRecordCount: enableTotalRecordCount,
        imageTypeLimit: imageTypeLimit,
        enableImageTypes: enableImageTypes,
        enableUserData: enableUserData,
        seriesTimerId: seriesTimerId,
        librarySeriesId: librarySeriesId,
        fields: fields);
    return category.items;
  }

  /// Method to retrieve guide from jellyfin API
  ///
  /// Can throw [LiveTvGuideRequestFailure] on API error
  Future<List<Item>> getGuideInfo(
      {int startIndex = 0, String fields = 'PrimaryImageAspectRatio', int limit = 100}) async {
    final category = await _liveTvApi.getGuideInfo(
        serverUrl: currentServerUrl, startIndex: startIndex, fields: fields, limit: limit);
    return category.items;
  }

  Future<List<Channel>> getGuide({int startIndex = 0, int limit = 100}) async {
    final channels =
        (await _liveTvApi.getChannels(serverUrl: currentServerUrl, startIndex: startIndex, limit: limit)).items;
    final programs = (await _liveTvApi.getPrograms(
            serverUrl: currentServerUrl,
            startIndex: startIndex,
            limit: limit,
            channelIds: channels.map((i) => i.id).toList()))
        .items;

    return compute(Channel.parseChannels, ParseChannelFromJellyfin(channels: channels, programs: programs));
  }
}
