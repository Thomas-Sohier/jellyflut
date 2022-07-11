import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:items_api/src/helper/profiles.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:path/path.dart' as p;

/// Exception thrown when item request fails.
class ItemViewRequestFailure implements Exception {}

/// Exception thrown when item request fails.
class ItemFavoriteRequestFailure implements Exception {}

/// Exception thrown when item request fails.
class ItemRequestFailure implements Exception {}

/// Exception thrown when item for provided ID is not found.
class ItemNotFoundFailure implements Exception {}

/// Exception thrown when item update has failed.
class ItemUpdateFailure implements Exception {}

/// Exception thrown when item search has failed.
class ItemSearchFailure implements Exception {}

/// Exception thrown when views request has failed.
class ViewRequestFailure implements Exception {}

/// Exception thrown when images request has failed.
class IamgeRequestFailure implements Exception {}

/// {@template items_api}
/// A dart API client for the Jellyfin Item API
/// {@endtemplate}
class ItemsApi {
  /// {@macro items_api}
  ItemsApi({required String serverUrl, required Database database, String? userId, Dio? dioClient})
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

  /// Get an item from jellyfin API from it's id
  ///
  /// Can throw [ItemNotFoundFailure]
  Future<Item> getItem(String itemId) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$_serverUrl/Users/$_userId/Items/$itemId');

      if (response.statusCode != 200) {
        throw ItemNotFoundFailure();
      }

      return compute(Item.fromJson, response.data!);
    } on DioError catch (e) {
      log(e.error.message);
      throw ItemNotFoundFailure();
    }
  }

  /// Get a category from jellyfin API with a parentId
  /// Can add other parameter (already good defaults for most queries)
  ///
  /// Can throw [ItemRequestFailure]
  Future<Category> getCategory(
      {String? parentId,
      String? albumArtistIds,
      String? personIds,
      String? filter = 'IsNotFolder',
      bool? recursive = true,
      List<HttpRequestSortBy>? sortBy = const [HttpRequestSortBy.DateCreated],
      String? sortOrder = 'Descending',
      String? mediaTypes,
      String? enableImageTypes = 'Primary,Backdrop,Banner,Thumb,Logo',
      String? includeItemTypes,
      int? limit = 300,
      int? startIndex = 0,
      int? imageTypeLimit = 1,
      String? fields = 'Chapters,People,Height,Width,PrimaryImageAspectRatio',
      String? excludeLocationTypes = 'Virtual',
      bool? enableTotalRecordCount = false,
      bool? collapseBoxSetItems = false}) async {
    final queryParams = <String, dynamic>{};
    queryParams.putIfAbsent('parentId', () => parentId);
    queryParams.putIfAbsent('albumArtistIds', () => albumArtistIds);
    queryParams.putIfAbsent('personIds', () => personIds);
    queryParams.putIfAbsent('filters', () => filter);
    queryParams.putIfAbsent('recursive', () => recursive);
    queryParams.putIfAbsent('sortBy', () => sortBy?.map((e) => e.name).join(','));
    queryParams.putIfAbsent('sortOrder', () => sortOrder);
    queryParams.putIfAbsent('includeItemTypes', () => includeItemTypes);
    queryParams.putIfAbsent('imageTypeLimit', () => imageTypeLimit);
    queryParams.putIfAbsent('enableImageTypes', () => enableImageTypes);
    queryParams.putIfAbsent('startIndex', () => startIndex);
    queryParams.putIfAbsent('mediaTypes', () => mediaTypes);
    queryParams.putIfAbsent('limit', () => limit);
    queryParams.putIfAbsent('fields', () => fields);
    queryParams.putIfAbsent('excludeLocationTypes', () => excludeLocationTypes);
    queryParams.putIfAbsent('enableTotalRecordCount', () => enableTotalRecordCount);
    queryParams.putIfAbsent('collapseBoxSetItems', () => collapseBoxSetItems);
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/Items',
        queryParameters: finalQueryParams,
      );

      if (response.statusCode != 200) {
        throw ItemRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (_) {
      throw ItemRequestFailure();
    }
  }

  /// Delete an item from his ID
  ///
  /// Can throw [ItemNotFoundFailure]
  Future<int> deleteItem(String itemId) async {
    final url = '$_serverUrl/Items/$itemId';

    try {
      final response = await _dioClient.delete<void>(url);
      return response.statusCode!;
    } catch (_) {
      throw ItemNotFoundFailure();
    }
  }

  /// Get items that can be resumed for a user
  /// Can add other parameter (already good defaults for most queries)
  ///
  /// Can throw [ItemRequestFailure]
  Future<Category> getResumeItems(
      {String filter = 'IsNotFolder, IsUnplayed',
      bool recursive = true,
      String sortBy = '',
      String sortOrder = '',
      String mediaType = 'Video',
      String enableImageTypes = 'Primary,Backdrop,Thumb,Logo',
      String? includeItemTypes,
      int limit = 12,
      int startIndex = 0,
      int imageTypeLimit = 1,
      String fields = 'PrimaryImageAspectRatio,BasicSyncInfo,ImageBlurHashes,Height,Width',
      String excludeLocationTypes = '',
      bool enableTotalRecordCount = false,
      bool collapseBoxSetItems = false}) async {
    final queryParams = <String, dynamic>{};
    queryParams['Filters'] = filter;
    queryParams['Recursive'] = recursive;
    queryParams['SortBy'] = sortBy;
    queryParams['SortOrder'] = sortOrder;
    if (includeItemTypes != null) {
      queryParams['IncludeItemTypes'] = includeItemTypes;
    }
    queryParams['ImageTypeLimit'] = imageTypeLimit;
    queryParams['EnableImageTypes'] = enableImageTypes;
    queryParams['StartIndex'] = startIndex;
    queryParams['MediaTypes'] = mediaType;
    queryParams['Limit'] = limit;
    queryParams['Fields'] = fields;
    queryParams['ExcludeLocationTypes'] = excludeLocationTypes;
    queryParams['EnableTotalRecordCount'] = enableTotalRecordCount;
    queryParams['CollapseBoxSetItems'] = collapseBoxSetItems;

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/Items/Resume',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) {
        throw ItemRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (_) {
      throw ItemRequestFailure();
    }
  }

  /// Get epsiodes from series ID, can filter by season id if needed
  ///
  /// Can throw [ItemRequestFailure]
  Future<Category> getEpsiodes(String seriesId, {String? seasonId}) async {
    final queryParams = <String, dynamic>{};
    if (seasonId != null) queryParams['seasonId'] = seasonId;
    queryParams['userId'] = _userId;
    queryParams['Fields'] =
        'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview,DateCreated,MediaStreams,Height,Width';

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_serverUrl/Shows/$seriesId/Episodes',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) {
        throw ItemRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (_) {
      throw ItemRequestFailure();
    }
  }

  /// Get seasons from series ID
  ///
  /// Can throw [ItemRequestFailure]
  Future<Category> getSeasons(String seriesId, {bool? isSpecialSeason}) async {
    final queryParams = <String, dynamic>{};
    if (isSpecialSeason != null) queryParams['isSpecialSeason'] = isSpecialSeason;
    queryParams['userId'] = _userId;
    queryParams['fields'] =
        'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview,DateCreated,MediaStreams,Height,Width';

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_serverUrl/Shows/$seriesId/Seasons',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) {
        throw ItemRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (_) {
      throw ItemRequestFailure();
    }
  }

  /// Search an item based on search terms
  /// Can add other parameter (already good defaults for most queries)
  ///
  /// Can throw [ItemSearchFailure]
  Future<Category> searchItems(
      {required String searchTerm,
      bool includePeople = false,
      bool includeMedia = true,
      bool includeGenres = false,
      bool includeStudios = false,
      bool includeArtists = false,
      String includeItemTypes = '',
      String excludeItemTypes = '',
      int limit = 24,
      String fields = 'PrimaryImageAspectRatio,CanDelete,BasicSyncInfo,MediaSourceCount,Height,Width',
      bool recursive = true,
      bool enableTotalRecordCount = false,
      int imageTypeLimit = 1,
      String? mediaTypes}) async {
    final queryParams = <String, dynamic>{};
    queryParams['searchTerm'] = searchTerm;
    queryParams['IncludePeople'] = includePeople;
    queryParams['IncludeMedia'] = includeMedia;
    queryParams['IncludeGenres'] = includeGenres;
    queryParams['IncludeStudios'] = includeStudios;
    queryParams['IncludeArtists'] = includeArtists;
    queryParams['IncludeItemTypes'] = includeItemTypes;
    queryParams['ExcludeItemTypes'] = excludeItemTypes;
    queryParams['MediaTypes'] = mediaTypes;
    queryParams['Limit'] = limit;
    queryParams['Fields'] = fields;
    queryParams['Recursive'] = recursive;
    queryParams['EnableTotalRecordCount'] = enableTotalRecordCount;
    queryParams['ImageTypeLimit'] = imageTypeLimit;

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/Items',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) {
        throw ItemSearchFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (_) {
      throw ItemSearchFailure();
    }
  }

  /// Update item an return updated object
  ///
  /// Can throw [ItemUpdateFailure]
  Future<void> updateItem({required Item item}) async {
    try {
      // final payload = item.toJson();
      final response = await _dioClient.post<void>(
        '$_serverUrl/Items/${item.id}',
        data: item,
      );

      if (response.statusCode != 204) {
        throw ItemUpdateFailure();
      }
    } catch (_) {
      throw ItemUpdateFailure();
    }
  }

  /// Mark item as viewed
  ///
  /// Can throw [ItemViewRequestFailure]
  Future<UserData> viewItem(String itemId) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/PlayedItems/$itemId',
      );

      if (response.statusCode != 200) {
        throw ItemViewRequestFailure();
      }

      return compute(UserData.fromJson, response.data!);
    } catch (_) {
      throw ItemViewRequestFailure();
    }
  }

  /// Mark item as not viewed
  ///
  /// Can throw [ItemViewRequestFailure]
  Future<UserData> unviewItem(String itemId) async {
    try {
      final response = await _dioClient.delete<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/PlayedItems/$itemId',
      );

      if (response.statusCode != 200) {
        throw ItemViewRequestFailure();
      }

      return compute(UserData.fromJson, response.data!);
    } catch (_) {
      throw ItemViewRequestFailure();
    }
  }

  /// Mark item as favorite
  ///
  /// Can throw [ItemFavoriteRequestFailure]
  Future<UserData> favItem(String itemId) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/FavoriteItems/$itemId',
      );

      if (response.statusCode != 200) {
        throw ItemFavoriteRequestFailure();
      }

      return compute(UserData.fromJson, response.data!);
    } catch (_) {
      throw ItemFavoriteRequestFailure();
    }
  }

  /// Mark item as not favorite
  ///
  /// Can throw [ItemFavoriteRequestFailure]
  Future<UserData> unfavItem(String itemId) async {
    try {
      final response = await _dioClient.delete<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/FavoriteItems/$itemId',
      );

      if (response.statusCode != 200) {
        throw ItemFavoriteRequestFailure();
      }

      return compute(UserData.fromJson, response.data!);
    } catch (_) {
      throw ItemFavoriteRequestFailure();
    }
  }

  /// Get latest medias added from Jellyfin
  /// Can add other parameter (already good defaults for most queries)
  ///
  /// can throw [ItemRequestFailure]
  Future<List<Item>> getLatestMedia({
    String? parentId,
    int limit = 16,
    String fields = 'PrimaryImageAspectRatio,BasicSyncInfo,Path',
    String enableImageTypes = 'Primary,Backdrop,Thumb,Logo',
    int imageTypeLimit = 1,
  }) async {
    var queryParams = <String, dynamic>{};
    parentId != null ? queryParams['ParentId'] = parentId : null;
    queryParams['Limit'] = limit;
    queryParams['Fields'] = fields;
    queryParams['ImageTypeLimit'] = imageTypeLimit;
    queryParams['EnableImageTypes'] = enableImageTypes;

    try {
      final response = await _dioClient.get<List<dynamic>>(
        '$_serverUrl/Users/$_userId/Items/Latest',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) {
        throw ItemRequestFailure();
      }

      List<Item> parseItems(List<dynamic> list) => list.map((item) => Item.fromJson(item)).toList();

      return compute(parseItems, response.data!);
    } catch (_) {
      throw ItemRequestFailure();
    }
  }

  /// Return a Category with all Views
  ///
  /// Can throw [ViewRequestFailure]
  Future<Category> getLibraryViews() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('$_serverUrl/Users/$_userId/Views');

      if (response.statusCode != 200) {
        throw ViewRequestFailure();
      }

      return compute(Category.fromMap, response.data!);
    } catch (_) {
      throw ViewRequestFailure();
    }
  }

  /// Helper method to generate an URL to get Item image
  ///
  /// * [maxWidth]            => The maximum image width to return.
  /// * [maxHeight]           => The maximum image height to return.
  /// * [width]               => The fixed image width to return.
  /// * [height]              => The fixed image height to return.
  /// * [quality]             => Quality setting, from 0-100. Defaults to 90 and should suffice in most cases.
  /// * [fillWidth]           => Width of box to fill.
  /// * [fillHeight]          => Height of box to fill.
  /// * [tag]                 => Supply the cache tag from the item object to receive strong caching headers.
  /// * [format]              => The MediaBrowser.Model.Drawing.ImageFormat of the returned image.
  /// * [addPlayedIndicator]  => Add a played indicator.
  /// * [percentPlayed]       =>  Percent to render for the percent played overlay.
  /// * [unplayedCount]       => Unplayed count overlay to render.
  /// * [blur]                => Blur image.
  /// * [backgroundColor]     => Apply a background color for transparent images.
  /// * [foregroundLayer]     =>  Apply a foreground layer on top of the image.
  /// * [imageIndex]          => Image index.
  String getItemImageUrl({
    required String itemId,
    required ImageType type,
    int? maxWidth,
    int? maxHeight,
    int? width,
    int? height,
    int quality = 60,
    int? fillWidth,
    int? fillHeight,
    String? tag,
    String? format,
    bool? addPlayedIndicator,
    double? percentPlayed,
    int? unplayedCount,
    int? blur,
    String? backgroundColor,
    String? foregroundLayer,
    int? imageIndex,
  }) {
    final uri = Uri.parse('$_serverUrl/Items/$itemId/Images/${type.name}');
    final queryParams = <String, dynamic>{};
    queryParams.putIfAbsent('maxWidth', () => maxWidth);
    queryParams.putIfAbsent('maxHeight', () => maxHeight);
    queryParams.putIfAbsent('width', () => width);
    queryParams.putIfAbsent('height', () => height);
    queryParams.putIfAbsent('quality', () => quality);
    queryParams.putIfAbsent('fillWidth', () => fillWidth);
    queryParams.putIfAbsent('fillHeight', () => fillHeight);
    queryParams.putIfAbsent('tag', () => tag);
    queryParams.putIfAbsent('format', () => format);
    queryParams.putIfAbsent('addPlayedIndicator', () => addPlayedIndicator);
    queryParams.putIfAbsent('percentPlayed', () => percentPlayed);
    queryParams.putIfAbsent('unplayedCount', () => unplayedCount);
    queryParams.putIfAbsent('blur', () => blur);
    queryParams.putIfAbsent('backgroundColor', () => backgroundColor);
    queryParams.putIfAbsent('foregroundLayer', () => foregroundLayer);
    queryParams.putIfAbsent('foregroundLayer', () => foregroundLayer);
    queryParams.putIfAbsent('imageIndex', () => imageIndex);
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    return uri.replace(queryParameters: finalQueryParams).toString();
  }

  /// Get all availables images for an item
  Future<RemoteImage> getRemoteImages(
    String itemId, {
    String? type,
    int? startIndex,
    int? limit,
    String? providerName,
    bool? includeAllLanguages = false,
  }) async {
    final queryParams = <String, dynamic>{};
    queryParams.putIfAbsent('type', () => type);
    queryParams.putIfAbsent('startIndex', () => startIndex);
    queryParams.putIfAbsent('limit', () => limit);
    queryParams.putIfAbsent('providerName', () => providerName);
    queryParams.putIfAbsent('includeAllLanguages', () => includeAllLanguages);

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_serverUrl/Items/$itemId/RemoteImages',
        queryParameters: queryParams,
      );

      if (response.statusCode != 200) {
        throw IamgeRequestFailure();
      }

      return compute(RemoteImage.fromJson, response.data!);
    } catch (_) {
      throw IamgeRequestFailure();
    }
  }

  /// Download an image for a given itemId
  Future<Uint8List> downloadRemoteImage(String itemId, {ImageType type = ImageType.Primary}) async {
    try {
      final response = await _dioClient.get<Uint8List>(getItemImageUrl(itemId: itemId, type: type, quality: 100),
          options: Options(responseType: ResponseType.bytes));
      if (response.statusCode != 200) {
        throw IamgeRequestFailure();
      }
      return response.data!;
    } catch (_) {
      throw IamgeRequestFailure();
    }
  }

  Future<String> getItemURL({required Item item, bool directPlay = false}) async {
    // if (directPlay == false && offlineMode == false) {
    //   await StreamingService.bitrateTest(size: 500000);
    //   await StreamingService.bitrateTest(size: 1000000);
    //   await StreamingService.bitrateTest(size: 3000000);
    // }
    final user = await _database.userAppDao.getUserByJellyfinUserId(_userId);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final directPlaySettingsOverride = settings.directPlay;

    // If direct play if forced by parameters or settings we direct play
    directPlay = directPlaySettingsOverride || directPlay;
    if (item.type == ItemType.Episode ||
        item.type == ItemType.Movie ||
        item.type == ItemType.TvChannel ||
        item.type == ItemType.Video ||
        item.type == ItemType.MusicVideo ||
        item.type == ItemType.Audio) {
      return getStreamURL(item, directPlay);
    } else if (item.type == ItemType.Season || item.type == ItemType.Series) {
      return getStreamURL(await getPlayableItemOrLastUnplayed(item: item), directPlay);
    } else if (item.type == ItemType.Audio) {
      return createMusicURL(item.id);
    } else {
      throw UnimplementedError('File cannot be played');
    }
  }

  Future<Item> getPlayableItemOrLastUnplayed({required Item item}) async {
    if (item.type == ItemType.Episode ||
        item.type == ItemType.Movie ||
        item.type == ItemType.TvChannel ||
        item.type == ItemType.Video ||
        item.type == ItemType.MusicVideo ||
        item.type == ItemType.Audio) {
      return item;
    } else if (item.type == ItemType.Season || item.type == ItemType.Series) {
      item = await getFirstUnplayedItem(itemId: item.id);
    }
    throw UnimplementedError('File cannot be played');
  }

  Future<Item> getFirstUnplayedItem({required String itemId}) async {
    int sortItem(Item? a, Item? b) {
      final aIndex = a?.indexNumber;
      final bIndex = b?.indexNumber;
      if (aIndex != null && bIndex != null) {
        return bIndex.compareTo(aIndex);
      } else if (aIndex != null && bIndex == null) {
        return -1;
      }
      if (aIndex == null && bIndex == null) {
        return 1;
      }
      return 0;
    }

    final category = await getCategory(parentId: itemId, filter: 'IsNotFolder', fields: 'MediaStreams');
    // remove all item without an index to avoid sort error
    category.items.removeWhere((item) => item.indexNumber == null || item.userData == null);
    category.items.sort(sortItem);
    return category.items.firstWhere((item) => !item.userData!.played, orElse: () => category.items.first);
  }

  Future<String> getStreamURL(Item item, bool directPlay) async {
    // First we try to fetch item locally to play it
    //  final itemExist = await _database.downloadsDao.doesExist(item.id);
    //  if (itemExist) return await FileService.getStoragePathItem(item);

    // If item do not exist locally the we fetch it from remote server
    final data = await isCodecSupported();
    final backInfos = await playbackInfos(data, item.id, startTimeTick: item.userData!.playbackPositionTicks);
    var completeTranscodeUrl;
    // Check if we have a transcide url or we create it
    if (backInfos.isTranscoding() && !directPlay) {
      completeTranscodeUrl = '$_serverUrl${backInfos.mediaSources.first.transcodingUrl}';
    }
    final finalUrl =
        completeTranscodeUrl ?? await createURL(item, backInfos, startTick: item.userData!.playbackPositionTicks);
    // Current item, playbackinfos, stream url and direct play bool
    // streamingProvider.setIsDirectPlay(completeTranscodeUrl != null ? false : true);
    // streamingProvider.setPlaybackInfos(backInfos);
    // streamingProvider.setURL(finalUrl);
    return finalUrl;
  }

  Future<DeviceProfileParent?> isCodecSupported() async {
    final profiles = PlayersProfile();
    // TODO make IOS
    if (kIsWeb) {
      final playerProfile = profiles.webOs;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    } else if (Platform.isAndroid) {
      final user = await _database.userAppDao.getUserByJellyfinUserId(_userId);
      final streamingSoftwareDB = await _database.settingsDao.getSettingsById(user.settingsId);
      final streamingSoftware = StreamingSoftware.fromString(streamingSoftwareDB.preferredPlayer);

      switch (streamingSoftware) {
        case StreamingSoftware.VLC:
          final playerProfile = profiles.vlcPhone;
          return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
        case StreamingSoftware.EXOPLAYER:
        case StreamingSoftware.AVPLAYER:
        default:
          final deviceProfile = await Profiles(database: _database, userId: _userId).getExoplayerProfile();
          return DeviceProfileParent(deviceProfile: deviceProfile);
      }
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final playerProfile = profiles.vlcComputer;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    }
    return null;
  }

  Future<PlayBackInfos> playbackInfos(DeviceProfileParent? profile, String itemId,
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

  Future<String> createURL(Item item, PlayBackInfos playBackInfos,
      {int startTick = 0, int? audioStreamIndex, int? subtitleStreamIndex}) async {
    final user = await _database.userAppDao.getUserByJellyfinUserId(_userId);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParams = <String, dynamic>{};
    queryParams['startTimeTicks'] = startTick;
    queryParams['static'] = true;
    queryParams['mediaSourceId'] = item.id;
    queryParams['deviceId'] = info.id;
    queryParams['videoBitrate'] = settings.maxVideoBitrate;
    queryParams['audioBitrate'] = settings.maxAudioBitrate;
    if (playBackInfos.mediaSources.isNotEmpty) queryParams['tag'] = playBackInfos.mediaSources.first.eTag;
    queryParams['subtitleStreamIndex'] = subtitleStreamIndex;
    queryParams['audioStreamIndex'] = audioStreamIndex;
    queryParams['api_key'] = user.apiKey;
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));

    late final path;
    switch (item.type) {
      case ItemType.TvChannel:
        final playbackPath = Uri.parse(playBackInfos.mediaSources.first.path!);
        path = playbackPath.path;
        break;
      default:
        final ext = p.extension(playBackInfos.mediaSources.first.path!);
        path = 'Videos/${item.id}/stream$ext';
    }
    final uri = Uri.parse('$_serverUrl/$path');
    return uri.replace(queryParameters: finalQueryParams).toString();
  }

  Future<String> createMusicURL(String itemId) async {
    final streamingSoftwareDB = await _database.settingsDao.getSettingsById(0);
    final streamingSoftware = TranscodeAudioCodec.fromString(streamingSoftwareDB.preferredTranscodeAudioCodec);
    // First we try to fetch item locally to play it
    //  final itemExist = await _database.downloadsDao.doesExist(itemId);
    //  if (itemExist) return await FileService.getStoragePathItem(this);
    return '$_serverUrl/Audio/$itemId/stream.${streamingSoftware.codecName}';
  }
}
