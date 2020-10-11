import 'package:dio/dio.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';
import 'package:jellyflut/models/item.dart';

import '../globals.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 60000,
  receiveTimeout: 60000,
  contentType: "JSON",
);

Dio dio = new Dio(options);

String getItemImageUrl(Item item,
    {int maxHeight = 1920,
    int maxWidth = 1080,
    String type = "Primary",
    int quality = 90}) {
  String finalType = _fallBackImg(item.imageBlurHashes, type);
  if (type == "Logo") {
    return "${server.url}/Items/${item.id}/Images/${finalType}?quality=${quality}";
  } else {
    return "${server.url}/Items/${item.id}/Images/${finalType}?maxHeight=${maxHeight}&maxWidth=${maxWidth}&quality=${quality}";
  }
}

String _fallBackImg(ImageBlurHashes imageBlurHashes, String tag) {
  String hash;
  if (tag == "Primary") {
    hash = _fallBackPrimary(imageBlurHashes);
  } else if (tag == "Backdrop") {
    hash = _fallBackBackdrop(imageBlurHashes);
  } else if (tag == "Logo") {
    hash = _fallBackLogo(imageBlurHashes);
  }
  return hash;
}

String _fallBackPrimary(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.primary != null)
    return "Primary";
  else if (imageBlurHashes.thumb != null)
    return "Thumb";
  else if (imageBlurHashes.backdrop != null)
    return "Backdrop";
  else if (imageBlurHashes.art != null)
    return "Art";
  else
    return "Primary";
}

String _fallBackBackdrop(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.backdrop != null)
    return "Backdrop";
  else if (imageBlurHashes.thumb != null)
    return "Thumb";
  else if (imageBlurHashes.art != null)
    return "Art";
  else if (imageBlurHashes.primary != null)
    return "Primary";
  else
    return "Primary";
}

String _fallBackLogo(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.logo != null) {
    return "Logo";
  }
  return "";
}

Future<Item> getItem(String itemId) async {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

  String url = "${server.url}/Users/${user.id}/Items/${itemId}";

  Response response;
  Item item = new Item();
  try {
    response = await dio.get(url, queryParameters: queryParams);
    item = Item.fromMap(response.data);
  } catch (e) {
    print(e);
  }
  return item;
}

Future<Category> getItemsRecursive(String parentId,
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
  queryParams["Limit"] = limit;
  queryParams["Fields"] = fields;
  queryParams["ExcludeLocationTypes"] = excludeLocationTypes;
  queryParams["EnableTotalRecordCount"] = enableTotalRecordCount;
  queryParams["CollapseBoxSetItems"] = collapseBoxSetItems;
  queryParams["api_key"] = apiKey;
  queryParams["Content-Type"] = "application/json";

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
