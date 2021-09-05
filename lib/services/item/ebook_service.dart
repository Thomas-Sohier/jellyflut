import 'dart:io';

import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/file/file_service.dart';

class EbookService {
  static Future<String> getEbook(Item item) async {
    // Check if we have rights
    // If not we cancel
    var hasStorage = await FileService.requestStorage();
    if (!hasStorage) {
      throw ('Cannot acces storage');
    }

    // Check if ebook is already present
    if (await isEbookDownloaded(item)) {
      return FileService.getStoragePathItem(item);
    }

    var queryParams = <String, dynamic>{};
    queryParams['api_key'] = apiKey;

    var url = '${server.url}/Items/${item.id}/Download?api_key=$apiKey';

    var dowloadPath = await FileService.getStoragePathItem(item);
    await FileService.downloadFile(url, dowloadPath);
    return dowloadPath;
  }

  static Future<bool> isEbookDownloaded(Item item) async {
    var path = await FileService.getStoragePathItem(item);
    return File(path).exists();
  }
}
