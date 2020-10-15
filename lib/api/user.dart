import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jellyflut/api/epub.dart';
import 'package:jellyflut/shared/shared.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/item.dart';
import 'package:path_provider/path_provider.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 60000,
  receiveTimeout: 60000,
  contentType: "JSON",
);

Dio dio = new Dio(options);

List<String> _mapCategory(Category category) {
  return category.items.map((e) => e.name).toList();
}

Future<List<Item>> getLatestMedia() async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

  String url = "${server.url}/Users/${user.id}/Items/Latest";

  Response response;
  try {
    response = await dio.get(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  List<Item> items = new List<Item>();
  return items;
  // return Item.fromMap(json.encode(response.data));
}

Future<Category> getCategory({String parentId, int limit = 10}) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Limit"] = limit;
  if (parentId != null) queryParams["ParentId"] = parentId;

  String url = "${server.url}/Users/${user.id}/Items";

  Response response;
  Category category = new Category();
  try {
    response = await dio.get(url, queryParameters: queryParams);
    category = Category.fromMap(response.data);
  } catch (e) {
    print(e);
  }
  return category;
}

Future<String> getEbook(Item item) async {
  bool hasStorage = await requestStorage();
  if (!hasStorage) {
    return null;
  }
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;

  String url = "${server.url}/Items/${item.id}/Download?api_key=${apiKey}";
  // Directory storageDir = await getTemporaryDirectory();
  Directory storageDir = await getApplicationDocumentsDirectory();
  String storageDirPath = storageDir.path;
  if (Platform.isAndroid) {
    storageDirPath = "/storage/emulated/0/Download";
  }

  String dowloadPath = "${storageDirPath}/${item.name}.epub";
  await downloadFile(url, dowloadPath);
  return dowloadPath;
}

Future<bool> requestStorage() async {
  // bool storage = await Permission.storage.request().isGranted;
  // if (storage) {
  //   return true;
  // } else {
  //   PermissionStatus permissionStatus = await Permission.storage.request();
  //   if (permissionStatus.isDenied) {
  //     return false;
  //   }
  // }
  return true;
}

Future<Map<String, dynamic>> viewItem(String itemId) async {
  var queryParams = new Map<String, dynamic>();
  // queryParams["DatePlayed"] = datePlayedFromDate(new DateTime.now());
  queryParams["api_key"] = apiKey;

  String url = "${server.url}/Users/${user.id}/PlayedItems/${itemId}";

  Response response;
  try {
    response = await dio.post(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  return response.data;
}

Future<Map<String, dynamic>> unviewItem(String itemId) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;

  String url = "${server.url}/Users/${user.id}/PlayedItems/${itemId}";

  Response response;
  try {
    response = await dio.delete(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  return response.data;
}

Future<Map<String, dynamic>> favItem(String itemId) async {
  var queryParams = new Map<String, dynamic>();
  // queryParams["DatePlayed"] = datePlayedFromDate(new DateTime.now());
  queryParams["api_key"] = apiKey;

  String url = "${server.url}/Users/${user.id}/FavoriteItems/${itemId}";

  Response response;
  try {
    response = await dio.post(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  return response.data;
}

Future<Map<String, dynamic>> unfavItem(String itemId) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;

  String url = "${server.url}/Users/${user.id}/FavoriteItems/${itemId}";

  Response response;
  try {
    response = await dio.delete(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  return response.data;
}

String datePlayedFromDate(DateTime dateTime) {
  return dateTime.year.toString() +
      dateTime.month.toString() +
      dateTime.day.toString() +
      dateTime.hour.toString() +
      dateTime.minute.toString() +
      dateTime.second.toString();
}
