import 'dart:io';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:downloads_api/downloads_api.dart' hide Download;
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:remote_downloads_api/remote_downloads_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlite_database/sqlite_database.dart';

/// Error thrown when a [Download] with a given id is not found.
class NotAllowedToSaveToFileSystem implements Exception {}

/// {@template downloads_repository}
/// A repository that handles download related requests.
/// {@endtemplate}
class DownloadsRepository {
  /// {@macro downloads_repository}
  const DownloadsRepository(
      {required DownloadsApi downloadsApi,
      required RemoteDownloadsApi remoteDownloadsApi,
      required AuthenticationRepository authenticationRepository,
      required Database database})
      : _downloadsApi = downloadsApi,
        _remoteDownloadsApi = remoteDownloadsApi,
        _authenticationRepository = authenticationRepository,
        _database = database;

  final DownloadsApi _downloadsApi;
  final RemoteDownloadsApi _remoteDownloadsApi;
  final AuthenticationRepository _authenticationRepository;
  final Database _database;

  // /// Provides a [Stream] of all downloads.
  // Stream<List<Download>> getDownloads() => _downloadsApi.getDownloads();

  // /// Saves a [download].
  // ///
  // /// If a [download] with the same id already exists, it will be replaced.
  // Future<void> saveDownload(Download download) => _downloadsApi.saveDownload(download);

  // /// Deletes the download with the given id.
  // ///
  // /// If no download with the given id exists, a [DownloadNotFoundException] error is
  // /// thrown.
  // Future<void> deleteDownload(String id) => _downloadsApi.deleteDownload(id);

  /// Download an item from it's ID and save it to filesystem
  Future<Uint8List> downloadItem({
    required String itemId,
    BehaviorSubject<int>? stateOfDownload,
    CancelToken? cancelToken,
  }) =>
      _remoteDownloadsApi.downloadItem(
          serverUrl: _authenticationRepository.currentServer.url,
          itemId: itemId,
          stateOfDownload: stateOfDownload,
          cancelToken: cancelToken);

  /// Return the rowId of the download inserted
  /// If [downloadName] is null then use item name as download name. No real use case
  /// right now, but can help identify row.
  Future<int> saveFile({required Uint8List bytes, String? downloadName, required Item item}) async {
    final hasAccess = await _requestStorage();
    if (!hasAccess) throw NotAllowedToSaveToFileSystem();

    await _saveInStorage(bytes: bytes, itemId: item.id);

    // const primaryUrl = '';
    // const backdropUrl = '';
    // final primaryImage = await .get<String>(primaryUrl);
    // final primaryImageByte = Uint8List.fromList(utf8.encode(primaryImage.data!));
    // final backdropImage = await Dio().get<String>(backdropUrl);
    // final backdropImageByte = Uint8List.fromList(utf8.encode(backdropImage.data!));
    final newDownload = DownloadDto.toInsert(
      path: await getUserStoragePath(),
      name: downloadName,
      item: item,
      primary: null,
      backdrop: null,
    );
    return _database.downloadsDao.createDownload(newDownload);
  }

  /// Save file to storage
  Future<File> _saveInStorage({required Uint8List bytes, required String itemId}) async {
    final storagePath = await _getStoragePathItem(itemId);
    final file = await File(storagePath).create(recursive: true);
    return file.writeAsBytes(bytes);
  }

  /// Return user's download path
  /// If not set then return default one
  Future<String> getUserStoragePath() async {
    final user = await _database.userAppDao.getUserByJellyfinUserId(_authenticationRepository.currentUser.id);
    final settings = await _database.settingsDao.getSettingsByUserId(user.id);
    if (settings.downloadPath.isNotEmpty) {
      return settings.downloadPath;
    }
    return _getStoragePath();
  }

  /// Get storage path. Can depends from current platform.
  /// Basically :
  ///   -> Linux & Windows & MacOS uses downloads directory
  ///   -> Android & IOS uses app directory
  static Future<String> _getStoragePath() async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final directory = await p.getDownloadsDirectory();
      return directory!.path;
    } else {
      final directory = await p.getTemporaryDirectory();
      return directory.path;
    }
  }

  /// Check if given item id is already downloaded
  Future<bool> isItemDownloaded(String id) async {
    return _database.downloadsDao.doesExist(id);
  }

  /// Get storage path item from a given ID
  Future<String> _getStoragePathItem(String id) async {
    var storageDirPath = await getUserStoragePath();
    return '$storageDirPath/$id';
  }

  /// Method to request storage permission
  /// Only useful on Android and IOS as other filesystem
  /// do not need such permissiosn (or atleast are not handled here...)
  Future<bool> _requestStorage() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final storage = await Permission.storage.request().isGranted;
      if (storage) {
        return true;
      } else {
        final permissionStatus = await Permission.storage.request();
        if (permissionStatus.isDenied) {
          return false;
        }
      }
      return true;
    }
    return true;
  }
}
