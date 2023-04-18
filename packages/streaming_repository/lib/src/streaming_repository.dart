import 'dart:io';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:items_api/items_api.dart';
import 'package:jellyflut_models/jellyflut_models.dart'
    hide User, StreamingSoftware;
import 'package:path/path.dart' as p;
import 'package:sqlite_database/sqlite_database.dart' hide Server;
import 'package:streaming_api/streaming_api.dart';
import 'package:streaming_repository/src/models/common_stream_media_kit.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'helper/profiles.dart';
import 'models/index.dart';

/// {@template streaming_repository}
/// A repository that handles streaming related requests
/// {@endtemplate}
class StreamingRepository {
  /// {@macro streaming_repository}
  const StreamingRepository(
      {required StreamingApi streamingApi,
      required AuthenticationRepository authenticationRepository,
      required ItemsApi itemsApi,
      required Database database})
      : _streamingApi = streamingApi,
        _itemsApi = itemsApi,
        _authenticationRepository = authenticationRepository,
        _database = database;
  final StreamingApi _streamingApi;
  final AuthenticationRepository _authenticationRepository;
  final ItemsApi _itemsApi;
  final Database _database;

  User get currentUser => _authenticationRepository.currentUser;
  Server get currentServer => _authenticationRepository.currentServer;

  Future<CommonStream> createController(
      {required Uri uri, Duration? startAtPosition}) async {
    final user =
        await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    switch (StreamingSoftware.fromString(settings.preferredPlayer)) {
      case StreamingSoftware.MPV:
        print(uri);
        return CommonStreamMediaKit.fromUri(
            uri: uri, startAtPosition: startAtPosition);
      case StreamingSoftware.VLC:
        if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
          return CommonStreamVLCComputer.fromUri(
              uri: uri, startAtPosition: startAtPosition);
        }
        return CommonStreamVLC.fromUri(
            uri: uri, startAtPosition: startAtPosition);
      case StreamingSoftware.AVPLAYER:
      case StreamingSoftware.EXOPLAYER:
        return CommonStreamBP.fromUri(
            uri: uri, startAtPosition: startAtPosition);
      case StreamingSoftware.HTMLPlayer:
        return CommonStreamVideoPlayer.fromUri(
            uri: uri, startAtPosition: startAtPosition);
      default:
        throw UnsupportedError('Platform video streaming is unsuportted');
    }
  }

  Future<Uri> getYoutubeTrailerUrl(MediaUrl trailer) async {
    if (trailer.url == null) throw Exception('Not a valid Url');
    final itemURi = Uri.parse(trailer.url!);
    final videoId = itemURi.queryParameters['v'];
    final yt = YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final streamInfo = manifest.muxed.withHighestBitrate();
    yt.close();
    return streamInfo.url;
  }

  Future<void> deleteActiveEncoding({required String playSessionId}) =>
      _streamingApi.deleteActiveEncoding(
        serverUrl: currentServer.url,
        userId: currentUser.id,
        playSessionId: playSessionId,
      );

  Future<PlayBackInfos> getPlaybackInfos(
      {required Uri uri,
      required int startTimeTick,
      required String itemId}) async {
    final user =
        await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final data = await _isCodecSupported();

    return _streamingApi.getPlaybackInfos(
        profile: data,
        startTimeTick: startTimeTick,
        maxVideoBitrate: settings.maxVideoBitrate,
        maxAudioBitrate: settings.maxAudioBitrate,
        maxStreamingBitrate: settings.maxVideoBitrate,
        itemId: itemId,
        serverUrl: currentServer.url,
        userId: currentUser.id);
  }

  /// Method that create a [StreamItem]. StreamItem contains every infos needed
  /// about streaming.
  /// It can be used latr to create a video controller for example
  Future<StreamItem> getStreamItem(
      {required Item item,
      StreamParameters streamParameters = StreamParameters.empty,
      bool directPlay = false}) async {
    // if (directPlay == false && offlineMode == false) {
    //   await StreamingService.bitrateTest(size: 500000);
    //   await StreamingService.bitrateTest(size: 1000000);
    //   await StreamingService.bitrateTest(size: 3000000);
    // }
    // First we try to fetch from databae
    try {
      final databaseItem =
          await _database.downloadsDao.getDownloadById(item.id);
      return StreamItem(
          url: databaseItem.path,
          item: databaseItem.item!,
          playbackInfos: null);
    } on StateError catch (_) {}
    final user =
        await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final directPlaySettingsOverride = settings.directPlay;
    // If direct play if forced by parameters or settings we direct play
    directPlay = directPlaySettingsOverride || directPlay;
    if (item.type == ItemType.Episode ||
        item.type == ItemType.Movie ||
        item.type == ItemType.TvChannel ||
        item.type == ItemType.LiveTvChannel ||
        item.type == ItemType.Video ||
        item.type == ItemType.MusicVideo ||
        item.type == ItemType.Audio) {
      return getStreamURL(item, directPlay, streamParameters);
    } else if (item.type == ItemType.Season || item.type == ItemType.Series) {
      final itemToPlay = await _getPlayableItemOrLastUnplayed(item: item);
      return getStreamURL(itemToPlay, directPlay, streamParameters);
    } else if (item.type == ItemType.Audio) {
      return createMusicURL(item);
    } else {
      throw UnimplementedError('File cannot be played');
    }
  }

  Future<Item> _getPlayableItemOrLastUnplayed({required Item item}) async {
    if (item.type == ItemType.Episode ||
        item.type == ItemType.Movie ||
        item.type == ItemType.TvChannel ||
        item.type == ItemType.Video ||
        item.type == ItemType.MusicVideo ||
        item.type == ItemType.Audio) {
      return item;
    } else if (item.type == ItemType.Season || item.type == ItemType.Series) {
      return _getFirstUnplayedItem(itemId: item.id);
    }
    throw UnimplementedError('File cannot be played');
  }

  Future<Item> _getFirstUnplayedItem({required String itemId}) async {
    int sortItem(Item? a, Item? b) {
      final aIndex = a?.indexNumber;
      final bIndex = b?.indexNumber;
      if (aIndex != null && bIndex != null) {
        return aIndex.compareTo(bIndex);
      } else if (aIndex != null && bIndex == null) {
        return -1;
      }
      if (aIndex == null && bIndex == null) {
        return 1;
      }
      return 0;
    }

    final category = await _itemsApi.getCategory(
        parentId: itemId,
        filter: 'IsNotFolder',
        fields: 'MediaStreams',
        serverUrl: currentServer.url,
        userId: currentUser.id);
    // remove all item without an index to avoid sort error
    category.items.removeWhere(
        (item) => item.indexNumber == null || item.userData == null);
    category.items.sort(sortItem);
    return category.items.firstWhere((item) => !item.userData!.played,
        orElse: () => category.items.first);
  }

  Future<StreamItem> getStreamURL(Item item, bool directPlay,
      [StreamParameters streamParameters = StreamParameters.empty]) async {
    // First we try to fetch item locally to play it
    //  final itemExist = await _database.downloadsDao.doesExist(item.id);
    //  if (itemExist) return await FileService.getStoragePathItem(item);
    // If item do not exist locally the we fetch it from remote server

    final user =
        await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final data = await _isCodecSupported();
    final playbackInfos = await _streamingApi.getPlaybackInfos(
        profile: data,
        startTimeTick: streamParameters.startAt?.inMilliseconds ??
            item.userData?.playbackPositionTicks,
        subtitleStreamIndex: streamParameters.subtitleStreamIndex,
        audioStreamIndex: streamParameters.audioStreamIndex,
        maxVideoBitrate: settings.maxVideoBitrate,
        maxAudioBitrate: settings.maxAudioBitrate,
        maxStreamingBitrate: settings.maxVideoBitrate,
        itemId: item.id,
        serverUrl: currentServer.url,
        userId: currentUser.id);

    // Check if we have a transcide url or we create it
    late final String url;
    if (playbackInfos.isTranscoding() && !directPlay) {
      url =
          '${currentServer.url}${playbackInfos.mediaSources.first.transcodingUrl}';
    } else {
      url = await createURL(item, playbackInfos,
          startTick: item.userData!.playbackPositionTicks);
    }
    return StreamItem(url: url, item: item, playbackInfos: playbackInfos);
  }

  Future<DeviceProfileParent?> _isCodecSupported() async {
    final profiles = PlayersProfile();
    // TODO make IOS
    if (kIsWeb) {
      final playerProfile = profiles.webOs;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    } else if (Platform.isAndroid) {
      final user =
          await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
      final streamingSoftwareDB =
          await _database.settingsDao.getSettingsById(user.settingsId);
      final streamingSoftware =
          StreamingSoftware.fromString(streamingSoftwareDB.preferredPlayer);
      switch (streamingSoftware) {
        case StreamingSoftware.VLC:
          final playerProfile = profiles.vlcPhone;
          return DeviceProfileParent(
              deviceProfile: playerProfile.deviceProfile);
        case StreamingSoftware.EXOPLAYER:
        case StreamingSoftware.AVPLAYER:
        default:
          final deviceProfile =
              await Profiles(database: _database, userId: currentUser.id)
                  .getExoplayerProfile();
          return DeviceProfileParent(deviceProfile: deviceProfile);
      }
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final playerProfile = profiles.vlcComputer;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    }
    return null;
  }

  Future<String> createURL(Item item, PlayBackInfos playBackInfos,
      {int startTick = 0,
      int? audioStreamIndex,
      int? subtitleStreamIndex}) async {
    final user =
        await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParams = <String, dynamic>{};
    queryParams['startTimeTicks'] = startTick;
    queryParams['static'] = true;
    queryParams['mediaSourceId'] = item.id;
    queryParams['deviceId'] = info.id;
    queryParams['videoBitrate'] = settings.maxVideoBitrate;
    queryParams['audioBitrate'] = settings.maxAudioBitrate;
    if (playBackInfos.mediaSources.isNotEmpty) {
      queryParams['tag'] = playBackInfos.mediaSources.first.eTag;
    }
    queryParams['subtitleStreamIndex'] = subtitleStreamIndex;
    queryParams['audioStreamIndex'] = audioStreamIndex;
    queryParams['api_key'] = user.apiKey;
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams =
        queryParams.map((key, value) => MapEntry(key, value.toString()));
    late final path;
    switch (item.type) {
      case ItemType.TvChannel:
        final playbackPath = Uri.parse(playBackInfos.mediaSources.first.path!);
        path = playbackPath.path;
        break;
      default:
        final ext = p.extension(playBackInfos.mediaSources.first.path!);
        path = '/Videos/${item.id}/stream$ext';
    }
    final uri = Uri.parse('${currentServer.url}$path');
    return uri.replace(queryParameters: finalQueryParams).toString();
  }

  Future<StreamItem> createMusicURL(Item item) async {
    final user =
        await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final streamingSoftware =
        TranscodeAudioCodec.fromString(settings.preferredTranscodeAudioCodec);
    // First we try to fetch item locally to play it
    //  final itemExist = await _database.downloadsDao.doesExist(itemId);
    //  if (itemExist) return await FileService.getStoragePathItem(this);
    final url =
        '${currentServer.url}/Audio/${item.id}/stream.${streamingSoftware.codecName}';
    return StreamItem(url: url, item: item);
  }
}
