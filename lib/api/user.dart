import 'dart:developer';
import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:jellyflut/api/epub.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dio.dart';

Future<User> getUserById({required String userID}) async {
  var url = '${server.url}/Users/$userID';

  Response response;
  var currentUser;
  try {
    response = await dio.get(url);
    currentUser = User.fromMap(response.data);
  } catch (e) {
    log(e.toString());
    rethrow;
  }
  return currentUser;
}

Future<User> getCurrentUser() async {
  var url = '${server.url}/Users/${userJellyfin!.id}';

  Response response;
  var currentUser;
  try {
    response = await dio.get(url);
    currentUser = User.fromMap(response.data);
  } catch (e) {
    log(e.toString());
    rethrow;
  }
  return currentUser;
}

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

  var url = '${server.url}/Users/${userJellyfin!.id}/Items/Latest';

  Response response;
  var items = <Item>[];
  try {
    response = await dio.get(url, queryParameters: queryParams);
    final List t = response.data;
    items = t.map((item) => Item.fromMap(item)).toList();
  } catch (e) {
    log(e.toString());
    rethrow;
  }
  return items;
}

Future<Category> getCategory({String? parentId, int limit = 10}) async {
  var queryParams = <String, dynamic>{};
  queryParams['Limit'] = limit;
  if (parentId != null) queryParams['ParentId'] = parentId;

  var url = '${server.url}/Users/${userJellyfin!.id}/Items';

  try {
    var response = await dio.get(url, queryParameters: queryParams);
    return Category.fromMap(response.data);
  } on DioError catch (dioError, _) {
    log(dioError.message);
    rethrow;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

Future<String> getEbook(Item item) async {
  // Check if we have rights
  // If not we cancel
  var hasStorage = await requestStorage();
  if (!hasStorage) {
    throw ('Cannot acces storage');
  }

  // Check if ebook is already present
  if (await isEbookDownloaded(item)) {
    return getStoragePathItem(item);
  }

  var queryParams = <String, dynamic>{};
  queryParams['api_key'] = apiKey;

  var url = '${server.url}/Items/${item.id}/Download?api_key=$apiKey';

  var dowloadPath = await getStoragePathItem(item);
  await downloadFile(url, dowloadPath);
  return dowloadPath;
}

Future<bool> isEbookDownloaded(Item item) async {
  var path = await getStoragePathItem(item);
  return io.File(path).exists();
}

Future<String> getStoragePathItem(Item item) async {
  var storageDir = await getTemporaryDirectory();
  var storageDirPath = storageDir.path;
  return '$storageDirPath/${item.name}.epub';
}

Future<bool> requestStorage() async {
  var storage = await Permission.storage.request().isGranted;
  if (storage) {
    return true;
  } else {
    var permissionStatus = await Permission.storage.request();
    if (permissionStatus.isDenied) {
      return false;
    }
  }
  return true;
}

Future<Map<String, dynamic>> viewItem(String itemId) async {
  var url = '${server.url}/Users/${userJellyfin!.id}/PlayedItems/$itemId';

  try {
    var response = await dio.post(url);
    return response.data;
  } catch (e) {
    print(e);
    throw ('Cannot get item, ' + e.toString());
  }
}

Future<Map<String, dynamic>> unviewItem(String itemId) async {
  var url = '${server.url}/Users/${userJellyfin!.id}/PlayedItems/$itemId';

  try {
    var response = await dio.delete(url);
    return response.data;
  } catch (e) {
    print(e);
    throw ('Cannot get item, ' + e.toString());
  }
}

Future<Map<String, dynamic>> favItem(String itemId) async {
  var url = '${server.url}/Users/${userJellyfin!.id}/FavoriteItems/$itemId';

  try {
    var response = await dio.post(url);
    return response.data;
  } catch (e) {
    print(e);
    throw ('Cannot get item, ' + e.toString());
  }
}

Future<Map<String, dynamic>> unfavItem(String itemId) async {
  var url = '${server.url}/Users/${userJellyfin!.id}/FavoriteItems/$itemId';

  try {
    var response = await dio.delete(url);
    return response.data;
  } catch (e) {
    print(e);
    throw ('Cannot get item, ' + e.toString());
  }
}

String datePlayedFromDate(DateTime dateTime) {
  return dateTime.year.toString() +
      dateTime.month.toString() +
      dateTime.day.toString() +
      dateTime.hour.toString() +
      dateTime.minute.toString() +
      dateTime.second.toString();
}
