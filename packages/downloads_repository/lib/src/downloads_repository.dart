import 'dart:io';
import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:downloads_api/downloads_api.dart';
import 'package:downloads_repository/src/models/ongoing_download.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:remote_downloads_api/remote_downloads_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqlite_database/sqlite_database.dart' as database;

/// Error thrown when a [Download] with a given id is not found.
class NotAllowedToSaveToFileSystem implements Exception {}

/// Error thrown when a [Download] file path does not exist.
class FileDoesNotExist implements Exception {}

/// {@template downloads_repository}
/// A repository that handles download related requests.
/// {@endtemplate}
class DownloadsRepository {
  /// {@macro downloads_repository}
  DownloadsRepository(
      {required DownloadsApi downloadsApi,
      required RemoteDownloadsApi remoteDownloadsApi,
      required AuthenticationRepository authenticationRepository,
      required database.Database database})
      : _downloadsApi = downloadsApi,
        _remoteDownloadsApi = remoteDownloadsApi,
        _authenticationRepository = authenticationRepository,
        _database = database;

  // ignore: unused_field
  final DownloadsApi _downloadsApi;
  final RemoteDownloadsApi _remoteDownloadsApi;
  final AuthenticationRepository _authenticationRepository;
  final database.Database _database;
  final List<OngoingDownload> _onGoingDownloads = <OngoingDownload>[];
  final BehaviorSubject<List<OngoingDownload>> _onGoingDownloadsStream = BehaviorSubject.seeded(const []);

  /// Provides a [Stream] of all ongoing downloads.
  Stream<List<OngoingDownload>> getOnGoingsDownloads() => _onGoingDownloadsStream.shareValue();

  int addOngoingDownload(OngoingDownload download) {
    _onGoingDownloads.add(download);
    _onGoingDownloadsStream.add(_onGoingDownloads);
    return _onGoingDownloads.indexOf(download);
  }

  int removeOngoingDownload(OngoingDownload download) {
    final index = _onGoingDownloads.indexOf(download);
    _onGoingDownloads.remove(download);
    _onGoingDownloadsStream.add(_onGoingDownloads);
    return index;
  }

  /// Provides a [Stream] of all downloads.
  Stream<List<Download>> getDownloads() {
    final BehaviorSubject<List<Download>> downloadsStream = BehaviorSubject.seeded(const []);
    final streamListener = _database.downloadsDao.watchAllDownloads.listen((event) {});
    streamListener.onData((dbDownloads) {
      final downloads = dbDownloads.map(_parseDatabaseDownloads).toList();
      downloadsStream.add(downloads);
    });
    return downloadsStream.shareValue();
  }

  Download _parseDatabaseDownloads(database.Download download) {
    return Download(
        id: download.id,
        item: download.item ?? Item.empty,
        path: download.path,
        name: download.name,
        primary: download.primary,
        backdrop: download.backdrop);
  }

  // /// Deletes the download with the given id.
  // ///
  // /// If no download with the given id exists, a [DownloadNotFoundException] error is
  // /// thrown.
  Future<void> deleteDownload(String id) => _database.downloadsDao.deleteDownloadFromId(id);

  /// Download an item from it's Id
  /// If item is already downloaded then return the one from filesystem instead
  ///
  /// - [forceRemoteFetch] parameter allow to bypass filesystem check to directly
  /// download from API
  Future<Uint8List> downloadItem(
      {required String itemId,
      BehaviorSubject<int>? stateOfDownload,
      CancelToken? cancelToken,
      bool forceRemoteFetch = false}) async {
    if (!forceRemoteFetch) {
      // Id item is already downloaded then return it instead
      final isDownloaded = await isItemDownloaded(itemId);
      if (isDownloaded) {
        final file = await getFileFromStorage(itemId: itemId);
        final isPresent = await file.exists();
        if (isPresent) return file.readAsBytes();
      }
    }

    final ongoingDownload = OngoingDownload(
        cancelToken: cancelToken!, id: itemId, item: Item.empty, path: '', stateOfDownload: stateOfDownload!);
    addOngoingDownload(ongoingDownload);

    return _remoteDownloadsApi.downloadItem(
        serverUrl: _authenticationRepository.currentServer.url,
        itemId: itemId,
        stateOfDownload: stateOfDownload,
        cancelToken: cancelToken);
  }

  /// Return the rowId of the download inserted
  /// If [downloadName] is null then use item name as download name. No real use case
  /// right now, but can help identify row.
  Future<File> saveFile({required Uint8List bytes, String? downloadName, required Item item}) async {
    final hasAccess = await _requestStorage();
    if (!hasAccess) throw NotAllowedToSaveToFileSystem();

    final file = await _saveInStorage(bytes: bytes, itemId: item.id);

    // const primaryUrl = '';
    // const backdropUrl = '';
    // final primaryImage = await .get<String>(primaryUrl);
    // final primaryImageByte = Uint8List.fromList(utf8.encode(primaryImage.data!));
    // final backdropImage = await Dio().get<String>(backdropUrl);
    // final backdropImageByte = Uint8List.fromList(utf8.encode(backdropImage.data!));
    final newDownload = database.DownloadDto.toInsert(
      id: item.id,
      path: file.path,
      name: downloadName,
      item: item,
      primary: null,
      backdrop: null,
    );
    await _database.downloadsDao.createDownload(newDownload);
    return file;
  }

  /// Save file to storage
  Future<File> _saveInStorage({required Uint8List bytes, required String itemId}) async {
    // If file is already downloaded and present at the specified path then return it
    final isDownloaded = await isItemDownloaded(itemId);
    if (isDownloaded) {
      return getFileFromStorage(itemId: itemId);
    }

    final storagePath = await _getStoragePathItem(itemId);
    final file = await File(storagePath).create(recursive: true);
    return file.writeAsBytes(bytes);
  }

  /// Get file from storage
  ///
  /// Check if file exist. If it does nt then throw [FileDoesNotExist] and delete
  /// download entry
  Future<File> getFileFromStorage({required String itemId}) async {
    try {
      final downloadDatabase = await _database.downloadsDao.getDownloadById(itemId);
      final file = File(downloadDatabase.path);
      if (await file.exists()) {
        return file;
      } else {
        _database.downloadsDao.deleteDownloadFromId(itemId);
        throw FileDoesNotExist();
      }
    } on StateError {
      throw FileDoesNotExist();
    }
  }

  /// Get file from storage
  ///
  /// Check if file exist. If it doesn'then delete download entry and return
  /// an empy Item
  ///
  /// Don't throw any error and return Item.empty if no item found
  Future<Item> getItemFromStorage({required String itemId}) async {
    try {
      final downloadDatabase = await _database.downloadsDao.getDownloadById(itemId);
      final file = File(downloadDatabase.path);
      if (await file.exists()) {
        return downloadDatabase.item ?? Item.empty;
      } else {
        _database.downloadsDao.deleteDownloadFromId(itemId);
        return Item.empty;
      }
    } on StateError {
      return Item.empty;
    }
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
