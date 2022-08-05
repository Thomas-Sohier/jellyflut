import 'package:bloc/bloc.dart';
import 'package:downloads_api/downloads_api.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:equatable/equatable.dart';

part 'downloads_event.dart';
part 'downloads_state.dart';

class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  DownloadsBloc({
    required DownloadsRepository downloadsRepository,
  })  : _downloadsRepository = downloadsRepository,
        super(const DownloadsState()) {
    final streamListner = _downloadsRepository.getDownloads().listen((downloads) {});
    streamListner.onData((downloads) => add(_AddDownloads(downloads)));
    on<DownloadsSubscriptionRequested>(_onSubscriptionRequested);
    on<_AddDownloads>(_addDownloads);
    on<DownloadsDeleted>(_onDownloadDeleted);
  }

  final DownloadsRepository _downloadsRepository;

  Future<void> _onSubscriptionRequested(
    DownloadsSubscriptionRequested event,
    Emitter<DownloadsState> emit,
  ) async {
    emit(state.copyWith(status: () => DownloadsStatus.success));
  }

  void _addDownloads(
    _AddDownloads event,
    Emitter<DownloadsState> emit,
  ) {
    emit(state.copyWith(downloads: event.downloads));
  }

  Future<void> _onDownloadDeleted(
    DownloadsDeleted event,
    Emitter<DownloadsState> emit,
  ) async {
    // emit(state.copyWith(lastDeletedDownload: () => event.download));
    // await _downloadsRepository.deleteDownload(event.download.id);
  }
}
