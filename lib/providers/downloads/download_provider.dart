import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/downloads/item_download.dart';
import 'package:jellyflut/models/enum/enum_values.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:rxdart/rxdart.dart';

class DownloadProvider extends ChangeNotifier {
  final Set<ItemDownload> _downloads = <ItemDownload>{};
  final BehaviorSubject<DownloadEvent> addedDownloadsStream =
      BehaviorSubject<DownloadEvent>();

  Set<ItemDownload> get getDownloads => _downloads;

  // Getter
  BehaviorSubject<int> getItemDownloadProgress(final String itemId) =>
      _downloads
          .firstWhere((element) => element.item.id == itemId)
          .downloadValueWatcher;

  bool isItemDownloadPresent(final String itemId) =>
      _downloads.where((element) => element.item.id == itemId).isNotEmpty;

  Future<void> downloadItem(
      final Item item,
      BehaviorSubject<int> percentDownload,
      Future<bool?> Function() ifFileExistShouldOverwrite) async {
    try {
      final downloadUrl = FileService.getDownloadFileUrl(item.id);
      final canDownload = await FileService.requestStorage();
      final downloadPath = await FileService.getStoragePathItem(item);

      if (canDownload) {
        final fileExist = await FileService.isItemDownloaded(item.id);

        // If file seems to already exist we show a dialog to warn user about possible overwriting of current file
        if (fileExist) {
          final shouldOverwrite = await ifFileExistShouldOverwrite.call();
          if (shouldOverwrite != null && shouldOverwrite == false) {
            return;
          }
        }

        // Add download to provider to keep track of it
        final cancelToken = CancelToken();
        final itemDownload = ItemDownload(
            item: item,
            downloadValueWatcher: percentDownload,
            cancelToken: cancelToken);

        await addDownload(
            context: customRouter.navigatorKey.currentContext,
            download: itemDownload,
            downloadPath: downloadPath,
            downloadUrl: downloadUrl,
            percentDownload: percentDownload);
      } else {
        SnackbarUtil.message('Do not have enough permission to download file',
            Icons.file_download_off, Colors.red);
      }
    } catch (e) {
      SnackbarUtil.message(e.toString(), Icons.file_download_off, Colors.red);
    }
  }

  // Setter
  Future<int> addDownload(
      {required final ItemDownload download,
      required BuildContext? context,
      required String downloadUrl,
      required String downloadPath,
      required BehaviorSubject<int>? percentDownload,
      void Function()? callback}) {
    _downloads.add(download);
    addedDownloadsStream.add(DownloadEvent(DownloadEventType.ADDED, download));
    // Download the file and store it to the given path
    // When complete show make the button selectable again
    final cancelToken = CancelToken();
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
    addedDownloadsStream
        .add(DownloadEvent(DownloadEventType.DELETED, download));
    notifyListeners();
  }

  void deleteDownloadedFile(Download download) async {
    try {
      final db = AppDatabase().getDatabase;
      final item = Item.fromMap(download.item!);
      final path = await FileService.getStoragePathItem(item);
      await File(path).delete();

      final downloadCompanion = download.toCompanion(true);
      await db.downloadsDao.deleteDownload(downloadCompanion);
      SnackbarUtil.message('Download removed', Icons.remove_done, Colors.green);
      return;
    } catch (e) {
      log(e.toString());
      SnackbarUtil.message('Error while removing download. ${e.toString()}',
          Icons.error, Colors.red);
    }
  }

  // Singleton
  static final DownloadProvider _DownloadProvider =
      DownloadProvider._internal();

  factory DownloadProvider() {
    return _DownloadProvider;
  }

  DownloadProvider._internal();
}

class DownloadEvent {
  final DownloadEventType eventType;
  final ItemDownload download;

  DownloadEvent(this.eventType, this.download);
}

enum DownloadEventType { ADDED, DELETED }

final bookExtensionsValues = EnumValues(
    {'added': DownloadEventType.ADDED, 'deleted': DownloadEventType.DELETED});
