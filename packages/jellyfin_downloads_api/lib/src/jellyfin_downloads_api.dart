import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:remote_downloads_api/remote_downloads_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_io/io.dart';

/// {@template jellyfin_downloads_api}
/// A dart API client to download files from Jellyfin API
/// {@endtemplate}
class JellyfinDownloadsApi extends RemoteDownloadsApi {
  /// {@macro jellyfin_downloads_api}
  JellyfinDownloadsApi({required Dio? dioClient}) : _dioClient = dioClient ?? Dio();

  final Dio _dioClient;

  String _getDownloadFileUrl(final String serverUrl, final String itemId) {
    return '$serverUrl/Items/$itemId/Download';
  }

  /// Download an item from it's id
  /// Return the file as byte
  ///
  /// May throw [DownloadFailed]
  @override
  Future<Uint8List> downloadItem({
    required String serverUrl,
    required String itemId,
    BehaviorSubject<int>? stateOfDownload,
    CancelToken? cancelToken,
  }) async {
    final url = _getDownloadFileUrl(serverUrl, itemId);

    try {
      late final Response<Uint8List> response;
      if (stateOfDownload != null) {
        response = await _dioClient.get<Uint8List>(
          url,
          cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
            final percentage = ((received / total) * 100).floor();
            stateOfDownload.add(percentage);
          },
          options: Options(
            headers: {HttpHeaders.acceptEncodingHeader: '*'},
            responseType: ResponseType.bytes,
          ),
        );
      } else {
        response = await _dioClient.get<Uint8List>(
          url,
          cancelToken: cancelToken,
          options: Options(
            headers: {HttpHeaders.acceptEncodingHeader: '*'},
            responseType: ResponseType.bytes,
          ),
        );
      }

      if (response.statusCode != 200) {
        throw DownloadFailed('Download of item failed with status code ${response.statusCode}');
      }

      return response.data ?? Uint8List.fromList([]);
    } on DioError catch (e) {
      throw DownloadFailed(e.message);
    } catch (_) {
      throw DownloadFailed('Failed to download item');
    }
  }
}
