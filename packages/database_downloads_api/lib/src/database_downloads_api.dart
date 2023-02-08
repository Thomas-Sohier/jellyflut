import 'dart:async';

import 'package:database_downloads_api/src/parse_database_downloads.dart';
import 'package:downloads_api/downloads_api.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqlite_database/sqlite_database.dart' hide Download;

/// {@template database_downloads_api}
/// A Flutter implementation of the [DownloadsApi] that uses database.
/// {@endtemplate}
class DatabaseDownloadsApi extends DownloadsApi {
  /// {@macro database_downloads_api}
  DatabaseDownloadsApi({required Database database}) {
    _databaseController = database;
    _init();
  }

  late final Database _databaseController;
  final _downloadStreamController = BehaviorSubject<List<Download>>.seeded(const []);

  void _init() {
    // Add downloads from database to the current stream
    _databaseController.downloadsDao.watchAllDownloads.listen((datas) async {
      final downloads = await compute(parseDatabaseDownloads, datas);
      _downloadStreamController.add(downloads);
    });
    _downloadStreamController.add([]);
  }

  @override
  Stream<List<Download>> getDownloads() => _downloadStreamController.asBroadcastStream();

  @override
  Future<void> saveDownload(Download download) {
    final downloads = [..._downloadStreamController.value];
    final todoIndex = downloads.indexWhere((t) => t.id == download.id);
    if (todoIndex >= 0) {
      downloads[todoIndex] = download;
    } else {
      downloads.add(download);
    }

    _downloadStreamController.add(downloads);
    return Future.value();
  }

  @override
  Future<void> deleteDownload(String id) async {
    final downloads = [..._downloadStreamController.value];
    final downloadIndex = downloads.indexWhere((t) => t.id == id);
    if (downloadIndex == -1) {
      throw DownloadNotFoundException();
    } else {
      downloads.removeAt(downloadIndex);
      return _downloadStreamController.add(downloads);
    }
  }
}
