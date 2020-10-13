import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jellyflut/models/MediaPlayedInfos.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/mediaSource.dart';
import 'package:video_player/video_player.dart';

import '../globals.dart';

BaseOptions options = new BaseOptions(
  connectTimeout: 60000,
  receiveTimeout: 60000,
  contentType: "JSON",
);

Dio dio = new Dio(options);

String getItemImageUrl(String itemId, ImageBlurHashes imageBlurHashes,
    {int maxHeight = 1920,
    int maxWidth = 1080,
    String type = "Primary",
    int quality = 90}) {
  String finalType = _fallBackImg(imageBlurHashes, type);
  if (type == "Logo") {
    return "${server.url}/Items/${itemId}/Images/${finalType}?quality=${quality}";
  } else {
    return "${server.url}/Items/${itemId}/Images/${finalType}?maxHeight=${maxHeight}&maxWidth=${maxWidth}&quality=${quality}";
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

void itemProgress(Item item, VideoPlayerController videoPlayerController,
    {int subtitlesIndex}) {
  var queryParams = new Map<String, dynamic>();
  queryParams["api_key"] = apiKey;

  MediaPlayedInfos mediaPlayedInfos = new MediaPlayedInfos();
  mediaPlayedInfos.isMuted =
      videoPlayerController.value.volume > 0 ? true : false;
  mediaPlayedInfos.isPaused = videoPlayerController.value.isPlaying;
  mediaPlayedInfos.canSeek = true;
  mediaPlayedInfos.itemId = item.id;
  mediaPlayedInfos.mediaSourceId = item.id;
  mediaPlayedInfos.positionTicks =
      videoPlayerController.value.position.inMicroseconds * 10;
  mediaPlayedInfos.volumeLevel = videoPlayerController.value.volume.toInt();
  mediaPlayedInfos.subtitleStreamIndex =
      subtitlesIndex != null ? subtitlesIndex : -1;

  String url = "${server.url}/Sessions/Playing/Progress";

  Map<String, dynamic> _mediaPlayedInfos = mediaPlayedInfos.toJson();
  _mediaPlayedInfos.removeWhere((key, value) => key == null || value == null);

  String _json = json.encode(_mediaPlayedInfos);

  dio
      .post(url, data: _json, queryParameters: queryParams)
      .then((_) => print("progress ok"))
      .catchError((onError) => print(onError));
}
