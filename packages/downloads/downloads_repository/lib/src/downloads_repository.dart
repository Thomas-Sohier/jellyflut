import 'package:downloads_api/downloads_api.dart';

/// {@template downloads_repository}
/// A repository that handles download related requests.
/// {@endtemplate}
class DownloadsRepository {
  /// {@macro downloads_repository}
  const DownloadsRepository({
    required DownloadsApi downloadsApi,
  }) : _downloadsApi = downloadsApi;

  final DownloadsApi _downloadsApi;

  /// Provides a [Stream] of all downloads.
  Stream<List<Download>> getDownloads() => _downloadsApi.getDownloads();

  /// Saves a [download].
  ///
  /// If a [download] with the same id already exists, it will be replaced.
  Future<void> saveDownload(Download download) =>
      _downloadsApi.saveDownload(download);

  /// Deletes the download with the given id.
  ///
  /// If no download with the given id exists, a [DownloadNotFoundException] error is
  /// thrown.
  Future<void> deleteDownload(String id) => _downloadsApi.deleteDownload(id);
}
