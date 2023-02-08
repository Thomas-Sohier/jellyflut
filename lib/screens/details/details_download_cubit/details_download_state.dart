part of 'details_download_cubit.dart';

enum DownloadStatus {
  initial,
  downloading,
  downloaded,
  notDownloaded;

  bool get isDownloading => this == downloading;
}

class DetailsDownloadState extends Equatable {
  DetailsDownloadState(
      {this.status = DownloadStatus.initial,
      required this.item,
      required this.stateOfDownload,
      required this.cancelToken});

  final DownloadStatus status;
  final Item item;
  final BehaviorSubject<int> stateOfDownload;
  final CancelToken cancelToken;

  DetailsDownloadState copyWith(
      {DownloadStatus? status, Item? item, BehaviorSubject<int>? stateOfDownload, CancelToken? cancelToken}) {
    return DetailsDownloadState(
      status: status ?? this.status,
      item: item ?? this.item,
      stateOfDownload: stateOfDownload ?? this.stateOfDownload,
      cancelToken: cancelToken ?? this.cancelToken,
    );
  }

  @override
  List<Object?> get props => [status, item, stateOfDownload, cancelToken];
}
