import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:rxdart/subjects.dart';

class DownloadService {
  final Set<ItemDownload> downloads = <ItemDownload>{};

  Future<List<Future<int>>> downloadItem(final Item item, BehaviorSubject<int> percentDownload,
      Future<bool?> Function() ifFileExistShouldOverwrite) async {
    final canDownload = await FileService.requestStorage();
    if (canDownload) {
      final files = await _itemsToDownload(item);
      final isFilesAlreadyDownloadedFuture = files.map((e) => FileService.isItemDownloaded(item.id));
      final isFilesAlreadyDownloaded = await Future.wait(isFilesAlreadyDownloadedFuture);
      final atleastOneFileExist = isFilesAlreadyDownloaded.any((element) => element == true);

      // If file seems to already exist we show a dialog to warn user about possible overwriting of current file
      if (atleastOneFileExist) {
        final shouldOverwrite = await ifFileExistShouldOverwrite.call();
        if (shouldOverwrite != null && shouldOverwrite == false) {
          return Future.value([]);
        }
      }

      return addDownloads(items: files);
    } else {
      throw 'Do not have enough permission to download file';
    }
  }

  /// Method which fetch items to download from one parent [item]
  /// If [item] have child then we fetch every child and so on until we have the
  /// deepest level
  /// If there is no child then we return current [item]
  Future<List<Item>> _itemsToDownload(Item item) async {
    // Future<List<Item>> getChildrens(String itemId) async {
    //   final category = await ItemService.getItems(parentId: item.id);
    //   return category.items;
    // }

    // final childrens = await getChildrens(item.id);
    return [item];
    // return childrens.where((e) => e.isPlayable()).toList();
  }

  Future<String> getDownloadPath(Item item) async {
    return FileService.getStoragePathItem(item);
  }

  Future<List<Future<int>>> addDownloads({required final List<Item> items, BuildContext? context}) async {
    final downloads = <Future<int>>[];
    for (final item in items) {
      final downloadUrl = FileService.getDownloadFileUrl(item.id);
      final downloadPath = await FileService.getStoragePathItem(item);

      final download = addDownload(item: item, context: context, downloadPath: downloadPath, downloadUrl: downloadUrl);
      downloads.add(download);
    }
    return downloads;
  }

  Future<int> addDownload(
      {required final Item item,
      required BuildContext? context,
      required String downloadUrl,
      required String downloadPath}) {
    // Add download to provider to keep track of it
    final cancelToken = CancelToken();
    final percentDownload = BehaviorSubject<int>();
    final itemDownload = ItemDownload(item: item, downloadValueWatcher: percentDownload, cancel: cancelToken.cancel);
    downloads.add(itemDownload);

    // Download the file and store it to the given path
    // When complete show make the button selectable again
    return FileService.downloadFileAndSaveToPath(downloadUrl, downloadPath,
            cancelToken: cancelToken, stateOfDownload: percentDownload)
        .then((_) => SnackbarUtil.message(
              'File saved at $downloadPath',
              Icons.file_download_done,
              Colors.green,
            ))
        .catchError((error, stackTrace) => SnackbarUtil.message(
              error.toString(),
              Icons.file_download_off,
              Colors.red,
            ))
        .then((_) => FileService.saveDownloadToDatabase(downloadPath, item));
  }
}
