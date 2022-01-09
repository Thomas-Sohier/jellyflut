import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class FileService {
  static String getDownloadFileUrl(final String itemId) {
    return '${server.url}/Items/$itemId/Download?api_key=$apiKey';
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
    return '${item.id}${item.getFileExtension()}';
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
      {BehaviorSubject<int>? stateOfDownload}) async {
    if (stateOfDownload != null) {
      return Dio().download(
        url,
        path,
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
