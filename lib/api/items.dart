import 'package:dio/dio.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/itemDetails.dart';

import '../globals.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: "JSON",
);

Dio dio = new Dio(options);

String getItemImageUrl(String itemId,
    {int maxHeight = 1920,
    int maxWidth = 1080,
    String type = "primary",
    int quality = 90}) {
  return "${basePath}/Items/${itemId}/Images/${type}?maxHeight=${maxHeight}&maxWidth=${maxWidth}&quality=${quality}";
}

Future<ItemDetail> getItemDetails(Item item) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

  String url = "${basePath}/Users/${user.id}/Items/${item.id}";

  Response response;
  ItemDetail itemDetail = new ItemDetail();
  try {
    response = await dio.get(url, queryParameters: queryParams);
    itemDetail = ItemDetail.fromMap(response.data);
  } catch (e) {
    print(e);
  }
  return itemDetail;
}

Future<ItemDetail> getItemsRecursive(String parentId,
    {String filter = "IsNotFolder, IsUnplayed",
    bool recursive = true,
    String sortBy = "PremiereDate",
    String mediaType = "Audio%2CVideo",
    int limit = 300,
    String fields = "Chapters",
    String excludeLocationTypes = "Virtual",
    bool enableTotalRecordCount = false,
    bool collapseBoxSetItems = false}) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["ParentId"] = parentId;
  queryParams["Filters"] = filter;
  queryParams["Recursive"] = recursive;
  queryParams["SortBy"] = sortBy;
  queryParams["MediaTypes"] = mediaType;
  queryParams["Limit"] = 300;
  queryParams["Fields"] = fields;
  queryParams["ExcludeLocationTypes"] = 300;
  queryParams["EnableTotalRecordCount"] = 300;
  queryParams["CollapseBoxSetItems"] = false;
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

  String url = "${basePath}/Users/${user.id}/Items/${parentId}";

  Response response;
  ItemDetail itemDetail = new ItemDetail();
  try {
    response = await dio.get(url, queryParameters: queryParams);
    itemDetail = mediaFromMap(response.data);
  } catch (e) {
    print(e);
  }
  return itemDetail;
}
