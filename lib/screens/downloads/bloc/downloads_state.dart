part of 'downloads_bloc.dart';

enum DownloadsStatus { initial, loading, success, failure }

class DownloadsState extends Equatable {
  const DownloadsState({
    this.status = DownloadsStatus.initial,
    this.downloads = const [],
    this.lastDeletedDownload,
  });

  final DownloadsStatus status;
  final List<Download> downloads;
  final Download? lastDeletedDownload;

  DownloadsState copyWith({
    DownloadsStatus Function()? status,
    List<Download>? downloads,
    Download? lastDeletedDownload,
  }) {
    return DownloadsState(
        status: status != null ? status() : this.status,
        downloads: downloads ?? this.downloads,
        lastDeletedDownload: lastDeletedDownload ?? this.lastDeletedDownload);
  }

  @override
  List<Object?> get props => [
        status,
        downloads,
        lastDeletedDownload,
      ];
}
