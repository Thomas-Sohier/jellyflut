import 'dart:async';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:universal_io/io.dart' as io;

import 'package:archive/archive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyflut/services/file/file_service.dart';

class BookUtils {
  static Future<Archive> unarchive(FutureOr<List<int>> bytes) async {
    List<int> loadedBytes;
    if (bytes is Future) {
      loadedBytes = await bytes;
    } else {
      loadedBytes = bytes;
    }
    return await compute(parseComic, loadedBytes);
  }

  static Future<Uint8List> loadItemBook(Item item) async {
    try {
      final path = await _downloadItemOnStorage(item);
      return io.File(path).readAsBytes();
    } catch (e) {
      final response = await FileService.donwloadFile(item.id);
      if (response != null) {
        return compute(parseEbook, response);
      } else {
        throw ('cannot_download_item'.tr());
      }
    }
  }

  static Future<String> _downloadItemOnStorage(Item item) async {
    throw UnimplementedError('download of ebook not yet impelmented'); // if (Platform.isAndroid || Platform.isIOS) {
    //   // Check if we have rights
    //   // If we do not store epub
    //   var hasStorage = await FileService.requestStorage();
    //   if (!hasStorage) {
    //     throw ('cannot_access_storage'.tr());
    //   }
    // }

    // // Check if ebook is already present
    // if (await EbookService.isEbookDownloaded(item)) {
    //   return FileService.getStoragePathItem(item);
    // }

    // final queryParams = <String, dynamic>{};
    // queryParams['api_key'] = apiKey;
    // final url = '${server.url}/Items/${item.id}/Download?api_key=$apiKey';
    // final dowloadPath = await FileService.getStoragePathItem(item);
    // await FileService.downloadFileAndSaveToPath(url, dowloadPath);
    // return dowloadPath;
  }
}

Uint8List parseEbook(List<int> bytes) {
  return Uint8List.fromList(bytes);
}

Archive parseComic(List<int> bytes) {
  final zipDecoder = ZipDecoder();
  return zipDecoder.decodeBytes(bytes, verify: true);
}
