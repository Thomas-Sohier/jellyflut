import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  static Future<String> getStoragePathItem(Item item) async {
    var storageDir = await getTemporaryDirectory();
    var storageDirPath = storageDir.path;
    return '$storageDirPath/${item.name}.epub';
  }

  static Future<bool> requestStorage() async {
    var storage = await Permission.storage.request().isGranted;
    if (storage) {
      return true;
    } else {
      var permissionStatus = await Permission.storage.request();
      if (permissionStatus.isDenied) {
        return false;
      }
    }
    return true;
  }

  static Future<Response<dynamic>> downloadFile(String url, String path) async {
    return Dio().download(url, path,
        options: Options(headers: {HttpHeaders.acceptEncodingHeader: '*'}));
  }
}
