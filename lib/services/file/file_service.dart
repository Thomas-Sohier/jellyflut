import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class FileService {
  static String getDownloadFileUrl(final String itemId) {
    return '${server.url}/Items/$itemId/Download?api_key=$apiKey';
  }

  /// Return the rowId of the download inserted
  static Future<int> saveDownloadToDatabase(
      final String path, final Item item) async {
    final i = item;

    final primaryUrl = ItemImageService.getItemImageUrl(
        item.id, item.correctImageTags(searchType: ImageType.PRIMARY),
        type: item.correctImageType(searchType: ImageType.PRIMARY));

    final backdropUrl = ItemImageService.getItemImageUrl(
        item.id, item.correctImageTags(searchType: ImageType.PRIMARY),
        type: item.correctImageType(searchType: ImageType.PRIMARY));

    final primaryImage = await Dio().get<String>(primaryUrl);
    final primaryImageByte =
        Uint8List.fromList(utf8.encode(primaryImage.data!));
    final backdropImage = await Dio().get<String>(backdropUrl);
    final backdropImageByte =
        Uint8List.fromList(utf8.encode(backdropImage.data!));

    final db = AppDatabase().getDatabase;
    final dc = DownloadsCompanion(
        id: Value(i.id),
        primary: Value(primaryImageByte),
        backdrop: Value(backdropImageByte),
        name: Value.ofNullable(i.name),
        item: Value.ofNullable(i.toMap()),
        path: Value.ofNullable(path));
    return db.downloadsDao.createDownload(dc);
  }

  static Future<String> getUserStoragePath() async {
    final db = AppDatabase().getDatabase;
    final settings = await db.settingsDao.getSettingsById(userApp!.settingsId);
    if (settings.downloadPath != null && settings.downloadPath!.isNotEmpty) {
      return settings.downloadPath!;
    }
    return getStoragePath();
  }

  static Future<String> getStoragePath() async {
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      final directory = await getDownloadsDirectory();
      return directory!.path;
    } else {
      final directory = await getTemporaryDirectory();
      return directory.path;
    }
  }

  static Future<bool> isItemDownloaded(String id) async {
    final db = AppDatabase().getDatabase;
    return db.downloadsDao.doesExist(id);
  }

  static Future<String> getStoragePathItem(Item item) async {
    var storageDirPath = await getUserStoragePath();
    return '$storageDirPath/${getItemStorageName(item)}';
  }

  static String getItemStorageName(Item item) {
    return item.id;
  }

  static Future<bool> requestStorage() async {
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

  /// Download a file and save it to filesystem
  static Future<Response<dynamic>> downloadFileAndSaveToPath(
      String url, String? path,
      {BehaviorSubject<int>? stateOfDownload, CancelToken? cancelToken}) async {
    if (stateOfDownload != null) {
      return Dio().download(
        url,
        path,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          final percentage = ((received / total) * 100).floor();
          stateOfDownload.add(percentage);
        },
        options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
      );
    }
    return Dio().download(
      url,
      path,
      cancelToken: cancelToken,
      options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}),
    );
  }

  /// Download a file but do not save it, it only returns bytes
  static Future<List<int>?> donwloadFile(String url) async {
    Response<List<int>> rs;
    rs = await Dio().get<List<int>>(
      url,
      options: Options(
          responseType: ResponseType.bytes), // set responseType to `bytes`
    );
    return rs.data;
  }
}
