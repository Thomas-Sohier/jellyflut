import 'dart:developer';

import 'package:flutter/foundation.dart' as foundation;
import 'package:dio/dio.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/models/jellyfin/user.dart';
import 'package:jellyflut/services/dio/interceptor.dart';

class UserService {
  static Category parseCategory(Map<String, dynamic> data) {
    return Category.fromMap(data);
  }

  static Future<User> getUserById({required String userID}) async {
    var url = '${server.url}/Users/$userID';

    Response response;
    var currentUser;
    try {
      response = await dio.get(url);
      currentUser = User.fromMap(response.data);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
    return currentUser;
  }

  static Future<User> getCurrentUser() async {
    var url = '${server.url}/Users/${userJellyfin!.id}';

    Response response;
    var currentUser;
    try {
      response = await dio.get(url);
      currentUser = User.fromMap(response.data);
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
    return currentUser;
  }

  static Future<List<Item>> getLatestMedia({
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

    var url = '${server.url}/Users/${userJellyfin!.id}/Items/Latest';

    try {
      final response = await dio.get(url, queryParameters: queryParams);
      final List t = response.data;
      return t.map((item) => Item.fromMap(item)).toList();
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getLibraryCategory(
      {String? parentId, int limit = 10}) async {
    var queryParams = <String, dynamic>{};
    queryParams['Limit'] = limit;
    if (parentId != null) queryParams['ParentId'] = parentId;

    var url = '${server.url}/Users/${userJellyfin!.id}/Items';

    try {
      final response = await dio.get<Map<String, dynamic>>(url,
          queryParameters: queryParams);
      return foundation.compute(parseCategory, response.data!);
    } on DioError catch (dioError) {
      log(dioError.message);
      rethrow;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }

  static Future<Category> getLibraryViews() async {
    final url = '${server.url}/Users/${userJellyfin!.id}/Views';

    try {
      final response = await dio.get<Map<String, dynamic>>(url);
      return foundation.compute(parseCategory, response.data!);
    } on DioError catch (dioError) {
      log(dioError.message);
      rethrow;
    } catch (e, stacktrace) {
      log(e.toString(), stackTrace: stacktrace, level: 5);
      rethrow;
    }
  }
}
