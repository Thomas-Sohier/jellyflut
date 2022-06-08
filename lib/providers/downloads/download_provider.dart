import 'dart:async';
import 'dart:developer';
import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:jellyflut/database/database.dart';
import 'package:jellyflut/models/downloads/item_download.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/providers/downloads/download_event.dart';
import 'package:jellyflut/providers/downloads/download_event_type.dart';
import 'package:jellyflut/providers/downloads/download_service.dart';
import 'package:jellyflut/shared/utils/snackbar_util.dart';
import 'package:rxdart/rxdart.dart';

class DownloadProvider extends ChangeNotifier {
  final DownloadService _downloadService = DownloadService();
  final BehaviorSubject<DownloadEvent> addedDownloadsStream =
      BehaviorSubject<DownloadEvent>();

  Set<ItemDownload> get getDownloads => _downloadService.downloads;

  // Getter
  BehaviorSubject<int> getItemDownloadProgress(final String itemId) =>
      getDownloads
          .firstWhere((element) => element.item.id == itemId)
          .downloadValueWatcher;

  bool isItemDownloadPresent(final String itemId) =>
      getDownloads.where((element) => element.item.id == itemId).isNotEmpty;

  Future<Future<List<Future<int>>>> downloadItem(
      final Item item,
      BehaviorSubject<int> percentDownload,
      Future<bool?> Function() ifFileExistShouldOverwrite) async {
    return _downloadService.downloadItem(
        item, percentDownload, ifFileExistShouldOverwrite);
  }

  void removeDownload(final ItemDownload download) {
    download.cancelToken.cancel();
    getDownloads.remove(download);
    addedDownloadsStream
        .add(DownloadEvent(DownloadEventType.DELETED, download));
    notifyListeners();
  }

  void deleteDownloadedFile(Download download) async {
    try {
      final db = AppDatabase().getDatabase;
      await File(download.path).delete();

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
