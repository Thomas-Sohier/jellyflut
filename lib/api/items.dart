import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/MediaPlayedInfos.dart';
import 'package:jellyflut/models/category.dart';
import 'package:jellyflut/models/device.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/models/playbackInfos.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:uuid/uuid.dart';
import '../globals.dart';
import 'dio.dart';

String getItemImageUrl(String itemId, String imageTag,
    {ImageBlurHashes imageBlurHashes,
    int maxHeight = 1920,
    int maxWidth = 1080,
    String type = 'Primary',
    int quality = 60}) {
  var finalType = type;
  if (imageBlurHashes != null) {
    finalType = _fallBackImg(imageBlurHashes, type);
  }
  if (type == 'Logo') {
    return '${server.url}/Items/$itemId/Images/$finalType?quality=$quality&tag=$imageTag';
  } else if (type == 'Backdrop') {
    return '${server.url}/Items/$itemId/Images/$finalType?maxWidth=800&tag=$imageTag&quality=$quality';
  } else {
    return '${server.url}/Items/$itemId/Images/$finalType?maxHeight=$maxHeight&maxWidth=$maxWidth&tag=$imageTag&quality=$quality';
  }
}

String _fallBackImg(ImageBlurHashes imageBlurHashes, String tag) {
  String hash;
  if (tag == 'Primary') {
    hash = _fallBackPrimary(imageBlurHashes);
  } else if (tag == 'Backdrop') {
    hash = _fallBackBackdrop(imageBlurHashes);
  } else if (tag == 'Logo') {
    hash = tag;
  }
  return hash;
}

String _fallBackPrimary(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.primary != null) {
    return 'Primary';
  } else if (imageBlurHashes.thumb != null) {
    return 'Thumb';
  } else if (imageBlurHashes.backdrop != null) {
    return 'Backdrop';
  } else if (imageBlurHashes.art != null) {
    return 'Art';
  } else {
    return 'Primary';
  }
}

String _fallBackBackdrop(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.backdrop != null)
    // ignore: curly_braces_in_flow_control_structures
    return 'Backdrop';
  else if (imageBlurHashes.thumb != null) {
    return 'Thumb';
  } else if (imageBlurHashes.art != null) {
    return 'Art';
  } else if (imageBlurHashes.primary != null) {
    return 'Primary';
  } else {
    return 'Primary';
  }
}

Future<int> deleteItem(String itemId) async {
  var url = '${server.url}/Items/$itemId';

  var response = Response();
  try {
    response = await dio.delete(url);
  } catch (e) {
    print(e);
  }
  return response.statusCode;
}

Future<Item> getItem(String itemId,
    {String filter = 'IsNotFolder, IsUnplayed',
    bool recursive = true,
    String sortBy = 'PremiereDate',
    String sortOrder = 'Ascending',
    String mediaType = 'Audio%2CVideo',
    String enableImageTypes = 'Primary,Backdrop,Banner,Thumb,Logo',
    String includeItemTypes,
    int limit = 300,
    int startIndex = 0,
    int imageTypeLimit = 1,
    String fields = 'Chapters, People',
    String excludeLocationTypes = 'Virtual',
    bool enableTotalRecordCount = false,
    bool collapseBoxSetItems = false}) async {
  var queryParams = <String, dynamic>{};
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

  var url = '${server.url}/Users/${userJellyfin.id}/Items/$itemId';

  Response response;
  var item = Item();
  try {
    response = await dio.get(url, queryParameters: queryParams);
    item = Item.fromMap(response.data);
  } catch (e) {
    print(e);
  }
  return item;
}

Future<Category> getResumeItems(
    {String filter = 'IsNotFolder, IsUnplayed',
    bool recursive = true,
    String sortBy = '',
    String sortOrder = '',
    String mediaType = 'Video',
    String enableImageTypes = 'Primary,Backdrop,Thumb,Logo',
    String includeItemTypes,
    int limit = 12,
    int startIndex = 0,
    int imageTypeLimit = 1,
    String fields = 'PrimaryImageAspectRatio,BasicSyncInfo,ImageBlurHashes',
    String excludeLocationTypes = '',
    bool enableTotalRecordCount = false,
    bool collapseBoxSetItems = false}) async {
  var queryParams = <String, dynamic>{};
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

  var url = '${server.url}/Users/${userJellyfin.id}/Items/Resume';

  try {
    var response = await dio.get(url, queryParameters: queryParams);
    return parseCategory(response.data);
  } catch (e) {
    print(e);
  }
  return null;
}

Category parseCategory(Map<String, dynamic> data) {
  return Category.fromMap(data);
}

Future<Category> getItems(
    {String parentId,
    String filter,
    bool recursive = true,
    String sortBy = 'PremiereDate',
    String sortOrder = 'Ascending',
    String mediaType,
    String enableImageTypes = 'Primary,Backdrop,Banner,Thumb,Logo',
    String includeItemTypes,
    String albumArtistIds,
    String personIds,
    int limit = 300,
    int startIndex = 0,
    int imageTypeLimit = 1,
    String fields = 'Chapters, DateCreated, ImageBlurHashes',
    String excludeLocationTypes = 'Virtual',
    bool enableTotalRecordCount = false,
    bool collapseBoxSetItems = false}) async {
  var queryParams = <String, dynamic>{};
  parentId != null ? queryParams['ParentId'] = parentId : null;
  filter != null ? queryParams['Filters'] = filter : null;
  recursive != null ? queryParams['Recursive'] = recursive : null;
  sortBy != null ? queryParams['SortBy'] = sortBy : null;
  sortOrder != null ? queryParams['SortOrder'] = sortOrder : null;
  includeItemTypes != null
      ? queryParams['IncludeItemTypes'] = includeItemTypes
      : null;
  imageTypeLimit != null
      ? queryParams['ImageTypeLimit'] = imageTypeLimit
      : null;
  enableImageTypes != null
      ? queryParams['EnableImageTypes'] = enableImageTypes
      : null;
  startIndex != null ? queryParams['StartIndex'] = startIndex : null;
  mediaType != null ? queryParams['MediaTypes'] = mediaType : null;
  limit != null ? queryParams['Limit'] = limit : null;
  fields != null ? queryParams['Fields'] = fields : null;
  excludeLocationTypes != null
      ? queryParams['ExcludeLocationTypes'] = excludeLocationTypes
      : null;
  albumArtistIds != null
      ? queryParams['AlbumArtistIds'] = albumArtistIds
      : null;
  personIds != null ? queryParams['PersonIds'] = personIds : null;
  enableTotalRecordCount != null
      ? queryParams['EnableTotalRecordCount'] = enableTotalRecordCount
      : null;
  collapseBoxSetItems != null
      ? queryParams['CollapseBoxSetItems'] = collapseBoxSetItems
      : null;

  var url = '${server.url}/Users/${userJellyfin.id}/Items';

  try {
    var response =
        await dio.get<Map<String, dynamic>>(url, queryParameters: queryParams);
    return foundation.compute(parseCategory, response.data);
  } catch (e) {
    print(e);
  }
  return null;
}

void itemProgress(Item item,
    {bool isMuted = false,
    bool isPaused = false,
    bool canSeek = true,
    int positionTicks = 0,
    int volumeLevel = 100,
    int subtitlesIndex}) {
  var mediaPlayedInfos = MediaPlayedInfos();
  mediaPlayedInfos.isMuted = isMuted;
  mediaPlayedInfos.isPaused = isPaused;
  mediaPlayedInfos.canSeek = true;
  mediaPlayedInfos.itemId = item.id;
  mediaPlayedInfos.mediaSourceId = item.id;
  mediaPlayedInfos.positionTicks = positionTicks * 10;
  mediaPlayedInfos.volumeLevel = volumeLevel;
  mediaPlayedInfos.subtitleStreamIndex = subtitlesIndex ?? -1;

  var url = '${server.url}/Sessions/Playing/Progress';

  var _mediaPlayedInfos = mediaPlayedInfos.toJson();
  _mediaPlayedInfos.removeWhere((key, value) => key == null || value == null);

  var _json = json.encode(_mediaPlayedInfos);

  dio.options.contentType = 'application/json';
  dio
      .post(url, data: _json)
      .then((_) => print('progress ok'))
      .catchError((onError) => print(onError));
}

Future<PlayBackInfos> playbackInfos(String json, String itemId,
    {startTimeTick = 0,
    int subtitleStreamIndex,
    int audioStreamIndex,
    int maxStreamingBitrate}) async {
  var streamModel = StreamModel();
  var streamingSoftwareDB = await AppDatabase()
      .getDatabase
      .settingsDao
      .getSettingsById(userApp.settingsId);
  var queryParams = <String, dynamic>{};
  queryParams['UserId'] = userJellyfin.id;
  queryParams['StartTimeTicks'] = startTimeTick;
  queryParams['IsPlayback'] = true;
  queryParams['AutoOpenLiveStream'] = true;
  queryParams['MaxStreamingBitrate'] =
      maxStreamingBitrate ?? streamingSoftwareDB.maxVideoBitrate;
  queryParams['MediaSourceId'] = itemId;
  if (subtitleStreamIndex != null) {
    queryParams['SubtitleStreamIndex'] = subtitleStreamIndex;
  } else if (streamModel.subtitleStreamIndex != null) {
    queryParams['SubtitleStreamIndex'] = streamModel.subtitleStreamIndex;
  }
  if (audioStreamIndex != null) {
    queryParams['AudioStreamIndex'] = audioStreamIndex;
  } else if (streamModel.audioStreamIndex != null) {
    queryParams['AudioStreamIndex'] = streamModel.audioStreamIndex;
  }

  var url = '${server.url}/Items/$itemId/PlaybackInfo';

  Response response;
  var playBackInfos = PlayBackInfos();
  try {
    response = await dio.post(
      url,
      queryParameters: queryParams,
      data: json,
    );
    playBackInfos = PlayBackInfos.fromMap(response.data);
  } catch (e) {
    print(e);
  }
  return playBackInfos;
}

Future<Category> searchItems(
    {@required String searchTerm,
    bool includePeople = false,
    bool includeMedia = true,
    bool includeGenres = false,
    bool includeStudios = false,
    bool includeArtists = false,
    String includeItemTypes = 'Movie',
    int limit = 24,
    String fields =
        'PrimaryImageAspectRatio,CanDelete,BasicSyncInfo,MediaSourceCount',
    bool recursive = true,
    bool enableTotalRecordCount = false,
    int imageTypeLimit = 1,
    String mediaTypes}) async {
  var queryParams = <String, dynamic>{};
  queryParams['searchTerm'] = searchTerm;
  queryParams['IncludePeople'] = includePeople;
  queryParams['IncludeMedia'] = includeMedia;
  queryParams['IncludeGenres'] = includeGenres;
  queryParams['IncludeStudios'] = includeStudios;
  queryParams['IncludeArtists'] = includeArtists;
  queryParams['IncludeItemTypes'] = includeItemTypes;
  queryParams['MediaTypes'] = mediaTypes;
  queryParams['Limit'] = limit;
  queryParams['Fields'] = fields;
  queryParams['Recursive'] = recursive;
  queryParams['EnableTotalRecordCount'] = enableTotalRecordCount;
  queryParams['ImageTypeLimit'] = imageTypeLimit;

  var url = '${server.url}/Users/${userJellyfin.id}/Items';

  Response response;
  var category = Category();
  try {
    response = await dio.get(
      url,
      queryParameters: queryParams,
    );
    category = Category.fromMap(response.data);
  } catch (e) {
    print(e);
  }
  return category;
}

Future<String> contructAudioURL(
    {@required String itemId,
    int maxStreamingBitrate,
    String container = 'opus,mp3|mp3,aac,m4a,m4b|aac,flac,webma,webm,wav,ogg',
    String transcodingContainer = 'ts',
    String transcodingProtocol = 'hls',
    String audioCodec = 'aac',
    int startTimeTicks = 0,
    bool enableRedirection = true,
    bool enableRemoteMedia = false}) async {
  // Get users settings
  var settings = await AppDatabase()
      .getDatabase
      .settingsDao
      .getSettingsById(userApp.settingsId);

  maxStreamingBitrate ??= settings.maxVideoBitrate;
  var audioCodecDB = settings.preferredTranscodeAudioCodec;
  var dInfo = await DeviceInfo().getCurrentDeviceInfo();
  var queryParams = <String, String>{};
  queryParams['UserId'] = userJellyfin.id;
  queryParams['DeviceId'] = dInfo.id;
  queryParams['MaxStreamingBitrate'] = maxStreamingBitrate != null
      ? maxStreamingBitrate.toString()
      : settings.maxAudioBitrate;
  queryParams['Container'] = container;
  queryParams['TranscodingContainer'] = transcodingContainer;
  queryParams['TranscodingProtocol'] = transcodingProtocol;
  queryParams['AudioCodec'] =
      audioCodecDB != 'auto' ? audioCodecDB : audioCodec;
  queryParams['PlaySessionId'] = Uuid().v1();
  queryParams['StartTimeTicks'] = startTimeTicks.toString();
  queryParams['EnableRedirection'] = enableRedirection.toString();
  queryParams['EnableRemoteMedia'] = enableRemoteMedia.toString();
  queryParams['api_key'] = apiKey;

  var url = 'Audio/$itemId/universal';

  var uri = Uri.https(
      server.url.replaceAll(RegExp('https?://'), ''), url, queryParams);
  return uri.toString();
}
