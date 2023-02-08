import 'package:dio/dio.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_io/io.dart';

part 'details_download_state.dart';

class DetailsDownloadCubit extends Cubit<DetailsDownloadState> {
  DetailsDownloadCubit({required Item item, required DownloadsRepository downloadsRepository})
      : _downloadsRepository = downloadsRepository,
        super(DetailsDownloadState(
            status: DownloadStatus.initial,
            item: item,
            stateOfDownload: BehaviorSubject.seeded(0),
            cancelToken: CancelToken())) {
    _init();
  }

  final DownloadsRepository _downloadsRepository;

  void _init() async {
    emit(state.copyWith(status: DownloadStatus.initial));
    try {
      await _downloadsRepository.getFileFromStorage(itemId: state.item.id);
      emit(state.copyWith(status: DownloadStatus.downloaded));
    } on FileDoesNotExist catch (_) {
      emit(state.copyWith(status: DownloadStatus.notDownloaded));
    }
  }

  /// Download the current item
  /// Can throw errors if something goes wrong
  Future<File> downloadItem() async {
    emit(state.copyWith(status: DownloadStatus.downloading));
    try {
      final fileBytes = await _downloadsRepository.downloadItem(
          itemId: state.item.id, stateOfDownload: state.stateOfDownload, cancelToken: state.cancelToken);
      final file = _downloadsRepository.saveFile(bytes: fileBytes, item: state.item);
      state.stateOfDownload.add(0);
      try {
        emit(state.copyWith(status: DownloadStatus.downloaded));
      } on StateError catch (_) {}
      return file;
    } catch (_) {
      emit(state.copyWith(status: DownloadStatus.notDownloaded));
      rethrow;
    }
  }
}
