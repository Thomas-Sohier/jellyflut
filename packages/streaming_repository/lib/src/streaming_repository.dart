import 'dart:io';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:items_api/items_api.dart';
import 'package:jellyflut_models/jellyflut_models.dart' hide User;
import 'package:sqlite_database/sqlite_database.dart' hide Server;
import 'package:streaming_api/streaming_api.dart';
import 'package:path/path.dart' as p;

import 'helper/profiles.dart';

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

  Future<String> getItemURL({required Item item, bool directPlay = false}) async {
    // if (directPlay == false && offlineMode == false) {
    //   await StreamingService.bitrateTest(size: 500000);
    //   await StreamingService.bitrateTest(size: 1000000);
    //   await StreamingService.bitrateTest(size: 3000000);
    // }
    final user = await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final directPlaySettingsOverride = settings.directPlay;
    // If direct play if forced by parameters or settings we direct play
    directPlay = directPlaySettingsOverride || directPlay;
    if (item.type == ItemType.Episode ||
        item.type == ItemType.Movie ||
        item.type == ItemType.TvChannel ||
        item.type == ItemType.Video ||
        item.type == ItemType.MusicVideo ||
        item.type == ItemType.Audio) {
      return getStreamURL(item, directPlay);
    } else if (item.type == ItemType.Season || item.type == ItemType.Series) {
      final itemToPlay = await _getPlayableItemOrLastUnplayed(item: item);
      return getStreamURL(itemToPlay, directPlay);
    } else if (item.type == ItemType.Audio) {
      return createMusicURL(item.id);
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
        return bIndex.compareTo(aIndex);
      } else if (aIndex != null && bIndex == null) {
        return -1;
      }
      if (aIndex == null && bIndex == null) {
        return 1;
      }
      return 0;
    }

    final category = await _itemsApi.getCategory(
        parentId: itemId, filter: 'IsNotFolder', fields: 'MediaStreams', serverUrl: '', userId: '');
    // remove all item without an index to avoid sort error
    category.items.removeWhere((item) => item.indexNumber == null || item.userData == null);
    category.items.sort(sortItem);
    return category.items.firstWhere((item) => !item.userData!.played, orElse: () => category.items.first);
  }

  Future<String> getStreamURL(Item item, bool directPlay) async {
    // First we try to fetch item locally to play it
    //  final itemExist = await _database.downloadsDao.doesExist(item.id);
    //  if (itemExist) return await FileService.getStoragePathItem(item);
    // If item do not exist locally the we fetch it from remote server
    final user = await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final data = await _isCodecSupported();
    final backInfos = await _streamingApi.getPlaybackInfos(
        profile: data,
        startTimeTick: item.userData!.playbackPositionTicks,
        maxVideoBitrate: settings.maxVideoBitrate,
        maxAudioBitrate: settings.maxAudioBitrate,
        maxStreamingBitrate: settings.maxVideoBitrate,
        itemId: item.id,
        serverUrl: currentServer.id,
        userId: currentUser.id);

    // Check if we have a transcide url or we create it
    if (backInfos.isTranscoding() && !directPlay) {
      return '${currentServer.url}${backInfos.mediaSources.first.transcodingUrl}';
    }
    return createURL(item, backInfos, startTick: item.userData!.playbackPositionTicks);
  }

  Future<DeviceProfileParent?> _isCodecSupported() async {
    final profiles = PlayersProfile();
    // TODO make IOS
    if (kIsWeb) {
      final playerProfile = profiles.webOs;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    } else if (Platform.isAndroid) {
      final user = await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
      final streamingSoftwareDB = await _database.settingsDao.getSettingsById(user.settingsId);
      final streamingSoftware = StreamingSoftware.fromString(streamingSoftwareDB.preferredPlayer);
      switch (streamingSoftware) {
        case StreamingSoftware.VLC:
          final playerProfile = profiles.vlcPhone;
          return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
        case StreamingSoftware.EXOPLAYER:
        case StreamingSoftware.AVPLAYER:
        default:
          final deviceProfile = await Profiles(database: _database, userId: currentServer.id).getExoplayerProfile();
          return DeviceProfileParent(deviceProfile: deviceProfile);
      }
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final playerProfile = profiles.vlcComputer;
      return DeviceProfileParent(deviceProfile: playerProfile.deviceProfile);
    }
    return null;
  }

  Future<String> createURL(Item item, PlayBackInfos playBackInfos,
      {int startTick = 0, int? audioStreamIndex, int? subtitleStreamIndex}) async {
    final user = await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final info = await DeviceInfo.getCurrentDeviceInfo();
    final queryParams = <String, dynamic>{};
    queryParams['startTimeTicks'] = startTick;
    queryParams['static'] = true;
    queryParams['mediaSourceId'] = item.id;
    queryParams['deviceId'] = info.id;
    queryParams['videoBitrate'] = settings.maxVideoBitrate;
    queryParams['audioBitrate'] = settings.maxAudioBitrate;
    if (playBackInfos.mediaSources.isNotEmpty) queryParams['tag'] = playBackInfos.mediaSources.first.eTag;
    queryParams['subtitleStreamIndex'] = subtitleStreamIndex;
    queryParams['audioStreamIndex'] = audioStreamIndex;
    queryParams['api_key'] = user.apiKey;
    queryParams.removeWhere((_, value) => value == null);
    final finalQueryParams = queryParams.map((key, value) => MapEntry(key, value.toString()));
    late final path;
    switch (item.type) {
      case ItemType.TvChannel:
        final playbackPath = Uri.parse(playBackInfos.mediaSources.first.path!);
        path = playbackPath.path;
        break;
      default:
        final ext = p.extension(playBackInfos.mediaSources.first.path!);
        path = 'Videos/${item.id}/stream$ext';
    }
    final uri = Uri.parse('${currentServer.url}/$path');
    return uri.replace(queryParameters: finalQueryParams).toString();
  }

  Future<String> createMusicURL(String itemId) async {
    final user = await _database.userAppDao.getUserByJellyfinUserId(currentUser.id);
    final settings = await _database.settingsDao.getSettingsById(user.id);
    final streamingSoftware = TranscodeAudioCodec.fromString(settings.preferredTranscodeAudioCodec);
    // First we try to fetch item locally to play it
    //  final itemExist = await _database.downloadsDao.doesExist(itemId);
    //  if (itemExist) return await FileService.getStoragePathItem(this);
    return '${currentServer.url}/Audio/$itemId/stream.${streamingSoftware.codecName}';
  }
}
