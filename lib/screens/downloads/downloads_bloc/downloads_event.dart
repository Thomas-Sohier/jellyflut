part of 'downloads_bloc.dart';

abstract class DownloadsEvent extends Equatable {
  const DownloadsEvent();

  @override
  List<Object> get props => [];
}

class DownloadsSubscriptionRequested extends DownloadsEvent {
  const DownloadsSubscriptionRequested();
}

class DownloadsDeleted extends DownloadsEvent {
  const DownloadsDeleted(this.download);

  final Download download;

  @override
  List<Object> get props => [download];
}

class _AddDownloads extends DownloadsEvent {
  const _AddDownloads(this.downloads);

  final List<Download> downloads;

  @override
  List<Object> get props => [downloads];
}
