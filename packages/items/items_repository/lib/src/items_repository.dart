import 'dart:io';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:items_api/items_api.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/sqlite_database.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:path/path.dart' as p;

import 'helper/profiles.dart';

/// {@template items_repository}
/// A repository that handles items related requests
/// {@endtemplate}
class ItemsRepository {
  /// {@macro items_repository}
  const ItemsRepository(
      {required ItemsApi itemsApi,
      required AuthenticationRepository authenticationrepository,
      required Database database})
      : _itemsApi = itemsApi,
        _authenticationrepository = authenticationrepository,
        _database = database;

  final ItemsApi _itemsApi;
  final Database _database;
  final AuthenticationRepository _authenticationrepository;

  /// Get an item from jellyfin API with an ID
  /// Can add other parameter (already good defaults for most queries)
  ///
  /// Can throw [ItemRequestFailure]
  Future<Item> getItem(String itemId) => _itemsApi.getItem(itemId);

  /// Get an item from jellyfin API with an ID
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
          bool? collapseBoxSetItems = false}) =>
      _itemsApi.getCategory(
        parentId: parentId,
        albumArtistIds: albumArtistIds,
        filter: filter,
        recursive: recursive,
        sortBy: sortBy,
        sortOrder: sortOrder,
        mediaTypes: mediaTypes,
        enableImageTypes: enableImageTypes,
        includeItemTypes: includeItemTypes,
        limit: limit,
        startIndex: startIndex,
        imageTypeLimit: imageTypeLimit,
        fields: fields,
        excludeLocationTypes: excludeLocationTypes,
        enableTotalRecordCount: enableTotalRecordCount,
        collapseBoxSetItems: collapseBoxSetItems,
      );

  /// Delete an item from his ID
  ///
  /// Can throw [ItemNotFoundFailure]
  Future<int> deleteItem(String itemId) => _itemsApi.deleteItem(itemId);

  /// Get items that can be resumed for a user
  /// Can add other parameter (already good defaults for most queries)
  ///
  /// Can throw [ItemRequestFailure]
  Future<Category> getResumeItems({
    String filter = 'IsNotFolder, IsUnplayed',
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
    bool collapseBoxSetItems = false,
  }) =>
      _itemsApi.getResumeItems(
        filter: filter,
        recursive: recursive,
        sortBy: sortBy,
        sortOrder: sortOrder,
        mediaType: mediaType,
        enableImageTypes: enableImageTypes,
        includeItemTypes: includeItemTypes,
        limit: limit,
        startIndex: startIndex,
        imageTypeLimit: imageTypeLimit,
        fields: fields,
        excludeLocationTypes: excludeLocationTypes,
        enableTotalRecordCount: enableTotalRecordCount,
        collapseBoxSetItems: collapseBoxSetItems,
      );

  /// Get epsiodes from series ID, can filter by season id if needed
  ///
  /// Can throw [ItemRequestFailure]
  Future<Category> getEpsiodes(String seriesId, {String? seasonId}) =>
      _itemsApi.getEpsiodes(seriesId, seasonId: seasonId);

  /// Get seasons from series ID
  ///
  /// Can throw [ItemRequestFailure]
  Future<Category> getSeasons(String seriesId, {bool? isSpecialSeason}) =>
      _itemsApi.getSeasons(seriesId, isSpecialSeason: isSpecialSeason);

  /// Search an item based on search terms
  /// Can add other parameter (already good defaults for most queries)
  ///
  /// Can throw [ItemSearchFailure]
  Future<Category> searchItems({
    required String searchTerm,
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
    String? mediaTypes,
  }) =>
      _itemsApi.searchItems(
        searchTerm: searchTerm,
        includePeople: includePeople,
        includeMedia: includeMedia,
        includeGenres: includeGenres,
        includeStudios: includeStudios,
        includeArtists: includeArtists,
        includeItemTypes: includeItemTypes,
        excludeItemTypes: excludeItemTypes,
        limit: limit,
        fields: fields,
        recursive: recursive,
        enableTotalRecordCount: enableTotalRecordCount,
        imageTypeLimit: imageTypeLimit,
        mediaTypes: mediaTypes,
      );

  /// Update item from Item object
  ///
  /// Can throw [ItemUpdateFailure]
  Future<void> updateItem({required Item item}) => _itemsApi.updateItem(item: item);

  /// Mark item as viewed
  ///
  /// Can throw [ItemViewRequestFailure]
  Future<UserData> viewItem(String itemId) => _itemsApi.viewItem(itemId);

  /// Mark item as not viewed
  ///
  /// Can throw [ItemViewRequestFailure]
  Future<UserData> unviewItem(String itemId) => _itemsApi.unviewItem(itemId);

  /// Mark item as favorite
  ///
  /// Can throw [ItemFavoriteRequestFailure]
  Future<UserData> favItem(String itemId) => _itemsApi.favItem(itemId);

  /// Mark item as not favorite
  ///
  /// Can throw [ItemFavoriteRequestFailure]
  Future<UserData> unfavItem(String itemId) => _itemsApi.unfavItem(itemId);

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
  }) =>
      _itemsApi.getLatestMedia(
        parentId: parentId,
        limit: limit,
        fields: fields,
        enableImageTypes: enableImageTypes,
        imageTypeLimit: imageTypeLimit,
      );

  /// Return a Category with all Views
  ///
  /// Can throw [ViewRequestFailure]
  Future<Category> getLibraryViews() => _itemsApi.getLibraryViews();

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
  }) =>
      _itemsApi.getItemImageUrl(
          itemId: itemId,
          type: type,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          width: width,
          height: height,
          quality: quality,
          fillWidth: fillWidth,
          fillHeight: fillHeight,
          tag: tag,
          format: format,
          addPlayedIndicator: addPlayedIndicator,
          percentPlayed: percentPlayed,
          unplayedCount: unplayedCount,
          blur: blur,
          backgroundColor: backgroundColor,
          foregroundLayer: foregroundLayer,
          imageIndex: imageIndex);

  /// Get all availables images for an item
  Future<RemoteImage> getRemoteImages(
    String itemId, {
    String? type,
    int? startIndex,
    int? limit,
    String? providerName,
    bool? includeAllLanguages = false,
  }) =>
      _itemsApi.getRemoteImages(itemId,
          type: type,
          startIndex: startIndex,
          limit: limit,
          providerName: providerName,
          includeAllLanguages: includeAllLanguages);

  /// Get all availables images for an item
  Future<Uint8List> downloadRemoteImage(String itemId, {ImageType type = ImageType.Primary}) =>
      _itemsApi.downloadRemoteImage(itemId, type: type);

  Future<String> getItemURL({required Item item, bool directPlay = false}) async {
    // if (directPlay == false && offlineMode == false) {
    //   await StreamingService.bitrateTest(size: 500000);
    //   await StreamingService.bitrateTest(size: 1000000);
    //   await StreamingService.bitrateTest(size: 3000000);
    // }
    final user = await _database.userAppDao.getUserByJellyfinUserId(_authenticationrepository.currentUser.id);
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
    final user = await _database.userAppDao.getUserByJellyfinUserId(_authenticationrepository.currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);

    // If item do not exist locally the we fetch it from remote server
    final data = await isCodecSupported();
    final backInfos = await _itemsApi.playbackInfos(data, item.id,
        startTimeTick: item.userData!.playbackPositionTicks,
        maxVideoBitrate: settings.maxVideoBitrate,
        maxAudioBitrate: settings.maxAudioBitrate);
    var completeTranscodeUrl;
    // Check if we have a transcide url or we create it
    if (backInfos.isTranscoding() && !directPlay) {
      completeTranscodeUrl =
          '${_authenticationrepository.currentServer.url}${backInfos.mediaSources.first.transcodingUrl}';
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
      final user = await _database.userAppDao.getUserByJellyfinUserId(_authenticationrepository.currentUser.id);
      final streamingSoftwareDB = await _database.settingsDao.getSettingsById(user.settingsId);
      final streamingSoftware = StreamingSoftware.fromString(streamingSoftwareDB.preferredPlayer);

      switch (streamingSoftware) {
        case StreamingSoftware.VLC:
          final playerProfile = profiles.vlcPhone;
          return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
        case StreamingSoftware.EXOPLAYER:
        case StreamingSoftware.AVPLAYER:
        default:
          final deviceProfile = await Profiles(database: _database, userId: _authenticationrepository.currentUser.id)
              .getExoplayerProfile();
          return DeviceProfileParent(deviceProfile: deviceProfile);
      }
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final playerProfile = profiles.vlcComputer;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    }
    return null;
  }

  Future<String> createURL(Item item, PlayBackInfos playBackInfos,
      {int startTick = 0, int? audioStreamIndex, int? subtitleStreamIndex}) async {
    final user = await _database.userAppDao.getUserByJellyfinUserId(_authenticationrepository.currentUser.id);
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
    final uri = Uri.parse('${_authenticationrepository.currentServer.url}/$path');
    return uri.replace(queryParameters: finalQueryParams).toString();
  }

  Future<String> createMusicURL(String itemId) async {
    final streamingSoftwareDB = await _database.settingsDao.getSettingsById(0);
    final streamingSoftware = TranscodeAudioCodec.fromString(streamingSoftwareDB.preferredTranscodeAudioCodec);
    // First we try to fetch item locally to play it
    //  final itemExist = await _database.downloadsDao.doesExist(itemId);
    //  if (itemExist) return await FileService.getStoragePathItem(this);
    return '${_authenticationrepository.currentServer.url}/Audio/$itemId/stream.${streamingSoftware.codecName}';
  }
}
