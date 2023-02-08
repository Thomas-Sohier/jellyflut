import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

/// Exception thrown when [download] fail
class DownloadFailed implements Exception {
  const DownloadFailed(this.message);
  final String message;
}

/// {@template remote_downloads_api}
/// The interface and models for remote downloads API
/// {@endtemplate}
abstract class RemoteDownloadsApi {
  /// {@macro remote_downloads_api}
  const RemoteDownloadsApi();

  /// Download an item from it's id
  /// Return the file as byte
  ///
  /// May throw [DownloadFailed]
  Future<Uint8List> downloadItem({
    required String serverUrl,
    required String itemId,
    BehaviorSubject<int>? stateOfDownload,
    CancelToken? cancelToken,
  });
}
