import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/downloads/item_download.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:rxdart/rxdart.dart';

class DownloadProvider extends ChangeNotifier {
  final Set<ItemDownload> _downloads = <ItemDownload>{};

  Set<ItemDownload> get getDownloads => _downloads;

  // Getter
  BehaviorSubject<int> getItemDownloadProgress(final String itemId) =>
      _downloads
          .firstWhere((element) => element.item.id == itemId)
          .downloadValueWatcher;

  bool isItemDownloadPresent(final String itemId) =>
      _downloads.where((element) => element.item.id == itemId).isNotEmpty;

  // Setter
  Future<int> addDownload(
      {required final ItemDownload download,
      required BuildContext? context,
      required String downloadUrl,
      required String downloadPath,
      required BehaviorSubject<int>? percentDownload,
      void Function()? callback}) {
    _downloads.add(download);
    // Download the file and store it to the given path
    // When complete show make the button selectable again
    final cancelToken = CancelToken();
    return FileService.downloadFileAndSaveToPath(downloadUrl, downloadPath,
            cancelToken: cancelToken, stateOfDownload: percentDownload)
        .then((_) => SnackbarUtil.message(
              context,
              'File saved at $downloadPath',
              Icons.file_download_done,
              Colors.green,
            ))
        .catchError((error, stackTrace) => SnackbarUtil.message(
              context,
              error.toString(),
              Icons.file_download_off,
              Colors.red,
            ))
        .then((_) =>
            FileService.saveDownloadToDatabase(downloadPath, download.item))
        .whenComplete(() {
      callback?.call();
      removeDownload(download);
      notifyListeners();
    });
  }

  void removeDownload(final ItemDownload download) {
    download.cancelToken.cancel();
    _downloads.remove(download);
    notifyListeners();
  }

  // Singleton
  static final DownloadProvider _DownloadProvider =
      DownloadProvider._internal();

  factory DownloadProvider() {
    return _DownloadProvider;
  }

  DownloadProvider._internal();
}
