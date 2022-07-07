import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:jellyflut_models/jellyflut_models.dart';

import 'json_serializer.dart';

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

/// {@template items_api}
/// A dart API client for the Jellyfin Item API
/// {@endtemplate}
class ItemsApi {
  /// {@macro items_api}S
  ItemsApi({required String serverUrl, required String userId, Dio? dioClient})
      : _dioClient = dioClient ?? Dio(),
        _serverUrl = serverUrl,
        _userId = userId;

  final Dio _dioClient;
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
      bool collapseBoxSetItems = false}) async {
    final queryParams = <String, String>{};
    parentId != null ? queryParams['ParentId'] = parentId : null;
    albumArtistIds != null ? queryParams['AlbumArtistIds'] = albumArtistIds : null;
    personIds != null ? queryParams['PersonIds'] = personIds : null;
    queryParams['Filters'] = filter;
    queryParams['Recursive'] = recursive.toString();
    queryParams['SortBy'] = sortBy;
    queryParams['SortOrder'] = sortOrder;
    if (includeItemTypes != null) {
      queryParams['IncludeItemTypes'] = includeItemTypes;
    }
    queryParams['ImageTypeLimit'] = imageTypeLimit.toString();
    queryParams['EnableImageTypes'] = enableImageTypes;
    queryParams['StartIndex'] = startIndex.toString();
    queryParams['MediaTypes'] = mediaType;
    queryParams['Limit'] = limit.toString();
    queryParams['Fields'] = fields;
    queryParams['ExcludeLocationTypes'] = excludeLocationTypes;
    queryParams['EnableTotalRecordCount'] = enableTotalRecordCount.toString();
    queryParams['CollapseBoxSetItems'] = collapseBoxSetItems.toString();

    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '$_serverUrl/Users/$_userId/Items',
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
  Future<void> updateItem({required Item itemDTO}) async {
    try {
      final payload = itemDTO.toJson();
      final response = await _dioClient.post<void>(
        '$_serverUrl/Items/${itemDTO.id}',
        data: payload,
      );

      if (response.statusCode != 204) {
        throw ItemUpdateFailure();
      }
    } catch (_) {
      throw ItemUpdateFailure();
    }
  }

  /// Update item an return updated object
  ///
  /// Can throw [ItemUpdateFailure]
  Future<void> updateItemFromForm({required String itemId, required Map<String, Object?> form}) async {
    try {
      final payload = json.encode(form, toEncodable: JsonSerializer.jellyfinSerializer);
      final response = await _dioClient.post<void>(
        '$_serverUrl/Items/$itemId',
        data: payload,
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
}
