import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/media.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: "JSON",
);

Dio dio = new Dio(options);

/// Retourne une list de categorie
Future<Category> getCategory() async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

  String url = "${basePath}/Users/${user.id}/Items";

  Response response;
  try {
    response = await dio.get(url, queryParameters: queryParams);
  } on DioError catch (e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // ...
    }
    if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      // ...
    }
  } catch (e) {
    print(e);
  }
  return Category.fromMap(response.data);
}

List<String> _mapCategory(Category category) {
  return category.items.map((e) => e.name).toList();
}

Future<List<Media>> getLatestMedia() async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

  String url = "${basePath}/Users/${user.id}/Items/Latest";

  Response response;
  try {
    response = await dio.get(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  return mediaFromMap(json.encode(response.data));
}

Future<List<Media>> getMediaResume() async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

  String url = "${basePath}/Users/${user.id}/Items/Resume";

  Response response;
  try {
    response = await dio.get(url, queryParameters: queryParams);
  } catch (e) {
    print(e);
  }
  return mediaFromMap(json.encode(response.data["Items"]));
}

Future<Category> getItems([String parentId, int limit = 10]) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Limit"] = limit;
  queryParams["ParentId"] = parentId;

  String url = "${basePath}/Users/${user.id}/Items";

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
