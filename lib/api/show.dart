import 'package:dio/dio.dart';
import 'package:jellyflut/models/category.dart';
import '../globals.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 60000,
  receiveTimeout: 60000,
  contentType: "JSON",
);

Dio dio = new Dio(options);

Future<Category> getShowSeasonEpisode(String parentId, String seasonId) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["seasonId"] = seasonId;
  queryParams["userId"] = user.id;
  queryParams["Fields"] =
      "ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview";

  String url = "${server.url}/Shows/${parentId}/Episodes";

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
