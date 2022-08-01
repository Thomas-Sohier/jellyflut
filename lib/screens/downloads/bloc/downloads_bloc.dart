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
    on<DownloadsSubscriptionRequested>(_onSubscriptionRequested);
    on<DownloadsDeleted>(_onDownloadDeleted);
  }

  final DownloadsRepository _downloadsRepository;

  Future<void> _onSubscriptionRequested(
    DownloadsSubscriptionRequested event,
    Emitter<DownloadsState> emit,
  ) async {
    emit(state.copyWith(status: () => DownloadsStatus.loading));

    // TODO later
    // await emit.forEach<List<Download>>(
    //   _downloadsRepository.getDownloads(),
    //   onData: (downloads) => state.copyWith(
    //     status: () => DownloadsStatus.success,
    //     downloads: () => downloads,
    //   ),
    //   onError: (_, __) => state.copyWith(
    //     status: () => DownloadsStatus.failure,
    //   ),
    // );
  }

  Future<void> _onDownloadDeleted(
    DownloadsDeleted event,
    Emitter<DownloadsState> emit,
  ) async {
    // emit(state.copyWith(lastDeletedDownload: () => event.download));
    // await _downloadsRepository.deleteDownload(event.download.id);
  }
}
