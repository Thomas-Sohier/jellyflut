part of 'details_download_cubit.dart';

enum OnGoingDownloadStatus {
  initial,
  downloading,
  downloaded,
  notDownloaded;

  bool get isDownloading => this == downloading;
}

class OnGoingDownloadsState extends Equatable {
  OnGoingDownloadsState({
    this.status = OnGoingDownloadStatus.initial,
  });

  final OnGoingDownloadStatus status;

  OnGoingDownloadsState copyWith({OnGoingDownloadStatus? status}) {
    return OnGoingDownloadsState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
