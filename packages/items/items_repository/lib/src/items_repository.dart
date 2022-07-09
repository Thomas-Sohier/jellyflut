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
  Future<Category> getCategory({
    String? parentId,
    String? albumArtistIds,
    String? personIds,
    String filter = 'IsNotFolder, IsUnplayed',
    bool recursive = true,
    String sortBy = 'PremiereDate',
    String sortOrder = 'Ascending',
    String mediaType = 'Audio%2CVideo',
    String enableImageTypes = 'Primary,Backdrop,Banner,Thumb,Logo',
    String? includeItemTypes,
    int limit = 300,
    int startIndex = 0,
    int imageTypeLimit = 1,
    String fields = 'Chapters,People,Height,Width,PrimaryImageAspectRatio',
    String excludeLocationTypes = 'Virtual',
    bool enableTotalRecordCount = false,
    bool collapseBoxSetItems = false,
  }) =>
      _itemsApi.getCategory(
        parentId: parentId,
        albumArtistIds: albumArtistIds,
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
}
