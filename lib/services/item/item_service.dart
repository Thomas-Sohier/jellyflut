import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart' as foundation;
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/dio/interceptor.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/shared/json_serializer.dart';

import 'parser.dart';

class ItemService {
  static Future<int> deleteItem(String itemId) async {
    final url = '${server.url}/Items/$itemId';

    try {
      final response = await dio.delete(url);
      return response.statusCode!;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Item> getItem(String itemId,
      {String filter = 'IsNotFolder, IsUnplayed',
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

    final url = '${server.url}/Users/${userJellyfin!.id}/Items/$itemId';

    try {
      final response = await dio.get<Map<String, dynamic>>(url,
          queryParameters: queryParams);
      return parseItem(response.data!);
      // return foundation.compute(parseItem, response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getResumeItems(
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
      String fields =
          'PrimaryImageAspectRatio,BasicSyncInfo,ImageBlurHashes,Height,Width',
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

    final url = '${server.url}/Users/${userJellyfin!.id}/Items/Resume';

    try {
      final response = await dio.get<Map<String, dynamic>>(url,
          queryParameters: queryParams);
      return foundation.compute(parseCategory, response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getItems(
      {String? parentId,
      String? filter,
      bool recursive = true,
      String sortBy = 'PremiereDate',
      String sortOrder = 'Ascending',
      String? mediaType,
      String enableImageTypes = 'Primary,Backdrop,Banner,Thumb,Logo',
      String? includeItemTypes,
      String? albumArtistIds,
      String? personIds,
      int limit = 300,
      int startIndex = 0,
      int imageTypeLimit = 1,
      String fields =
          'Chapters,DateCreated,ImageBlurHashes,Height,Width,Overview',
      String excludeLocationTypes = 'Virtual',
      bool enableTotalRecordCount = false,
      bool collapseBoxSetItems = false}) async {
    final queryParams = <String, dynamic>{};
    albumArtistIds != null
        ? queryParams['AlbumArtistIds'] = albumArtistIds
        : null;
    includeItemTypes != null
        ? queryParams['IncludeItemTypes'] = includeItemTypes
        : null;
    personIds != null ? queryParams['PersonIds'] = personIds : null;
    parentId != null ? queryParams['ParentId'] = parentId : null;
    filter != null ? queryParams['Filters'] = filter : null;
    mediaType != null ? queryParams['MediaTypes'] = mediaType : null;
    queryParams['SortBy'] = sortBy;
    queryParams['SortOrder'] = sortOrder;
    queryParams['ImageTypeLimit'] = imageTypeLimit;
    queryParams['EnableImageTypes'] = enableImageTypes;
    queryParams['StartIndex'] = startIndex;
    queryParams['Recursive'] = recursive;
    queryParams['Limit'] = limit;
    queryParams['Fields'] = fields;
    queryParams['ExcludeLocationTypes'] = excludeLocationTypes;
    queryParams['EnableTotalRecordCount'] = enableTotalRecordCount;
    queryParams['CollapseBoxSetItems'] = collapseBoxSetItems;

    final url = '${server.url}/Users/${userJellyfin!.id}/Items';

    try {
      final response = await dio.get<Map<String, dynamic>>(url,
          queryParameters: queryParams);
      if (response.data == null) throw ('Missing data');
      return foundation.compute(parseCategory, response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> updateItemFromObject({required Item item}) async {
    final url = '${server.url}/Items/${item.id}';

    try {
      final response = await dio.post<Map<String, dynamic>>(url, data: item);
      return foundation.compute(parseCategory, response.data!);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<void> updateItemFromForm(
      {required String id, required Map<String, Object?> form}) async {
    final url = '${server.url}/Items/$id';

    try {
      final payload =
          json.encode(form, toEncodable: JsonSerializer.jellyfinSerializer);
      await dio.post(url, data: payload);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> searchItems(
      {required String searchTerm,
      bool includePeople = false,
      bool includeMedia = true,
      bool includeGenres = false,
      bool includeStudios = false,
      bool includeArtists = false,
      String includeItemTypes = '',
      String excludeItemTypes = '',
      int limit = 24,
      String fields =
          'PrimaryImageAspectRatio,CanDelete,BasicSyncInfo,MediaSourceCount,Height,Width',
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

    final url = '${server.url}/Users/${userJellyfin!.id}/Items';

    try {
      final response = await dio.get(
        url,
        queryParameters: queryParams,
      );
      return Category.fromMap(response.data);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getEpsiode(String parentId, String seasonId) async {
    var queryParams = <String, dynamic>{};
    queryParams['seasonId'] = seasonId;
    queryParams['userId'] = userJellyfin!.id;
    queryParams['Fields'] =
        'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview,DateCreated,MediaStreams,Height,Width';

    var url = '${server.url}/Shows/$parentId/Episodes';

    try {
      var response = await dio.get(url, queryParameters: queryParams);
      return Category.fromMap(response.data);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> viewItem(String itemId) async {
    var url = '${server.url}/Users/${userJellyfin!.id}/PlayedItems/$itemId';

    try {
      var response = await dio.post(url);
      return response.data;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> unviewItem(String itemId) async {
    var url = '${server.url}/Users/${userJellyfin!.id}/PlayedItems/$itemId';

    try {
      var response = await dio.delete(url);
      return response.data;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> favItem(String itemId) async {
    var url = '${server.url}/Users/${userJellyfin!.id}/FavoriteItems/$itemId';

    try {
      var response = await dio.post(url);
      return response.data;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> unfavItem(String itemId) async {
    var url = '${server.url}/Users/${userJellyfin!.id}/FavoriteItems/$itemId';

    try {
      var response = await dio.delete(url);
      return response.data;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }
}
