import 'dart:typed_data';

import 'package:items_api/items_api.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

/// {@template items_repository}
/// A repository that handles items related requests
/// {@endtemplate}
class ItemsRepository {
  /// {@macro items_repository}
  const ItemsRepository({required ItemsApi itemsApi}) : _itemsApi = itemsApi;

  final ItemsApi _itemsApi;

  /// Update API properties
  /// UseFul when endpoint Server or user change
  void updateProperties({String? serverUrl, String? userId}) =>
      _itemsApi.updateProperties(serverUrl: serverUrl, userId: userId);

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

  Future<String> getItemURL({required Item item, bool directPlay = false}) =>
      _itemsApi.getItemURL(item: item, directPlay: directPlay);

  Future<Item> getPlayableItemOrLastUnplayed({required Item item}) =>
      _itemsApi.getPlayableItemOrLastUnplayed(item: item);

  Future<Item> getFirstUnplayedItem({required String itemId}) => _itemsApi.getFirstUnplayedItem(itemId: itemId);

  Future<String> getStreamURL(Item item, bool directPlay) => _itemsApi.getStreamURL(item, directPlay);

  Future<String> createURL(Item item, PlayBackInfos playBackInfos,
          {int startTick = 0, int? audioStreamIndex, int? subtitleStreamIndex}) =>
      _itemsApi.createURL(item, playBackInfos,
          startTick: startTick, audioStreamIndex: audioStreamIndex, subtitleStreamIndex: subtitleStreamIndex);

  Future<String> createMusicURL(String itemId) => _itemsApi.createMusicURL(itemId);
}
