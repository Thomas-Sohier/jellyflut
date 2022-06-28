import '../downloads_api.dart';

/// {@template downloads_api}
/// The interface for an API that provides access to a list of downloads.
/// {@endtemplate}
abstract class DownloadsApi {
  /// {@macro downloads_api}
  const DownloadsApi();

  /// Provides a [Stream] of all downloads.
  Stream<List<Download>> getDownloads();

  /// Saves a [download].
  ///
  /// If a [download] with the same id already exists, it will be replaced.
  Future<void> saveDownload(Download download);

  /// Delete the download with the given id.
  ///
  /// If no download with the given id exists, a [DownloadNotFoundException] error is
  /// thrown.
  Future<void> deleteDownload(String id);
}

/// Error thrown when a [Download] with a given id is not found.
class DownloadNotFoundException implements Exception {}
