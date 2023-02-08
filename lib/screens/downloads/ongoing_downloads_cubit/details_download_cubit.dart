// ignore_for_file: unused_field, null_argument_to_non_null_type
// TODO finish thisn beta state

import 'package:downloads_repository/downloads_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:universal_io/io.dart';

part 'details_download_state.dart';

class OngoingDownloadsCubit extends Cubit<OnGoingDownloadsState> {
  OngoingDownloadsCubit({required DownloadsRepository downloadsRepository})
      : _downloadsRepository = downloadsRepository,
        super(OnGoingDownloadsState());

  final DownloadsRepository _downloadsRepository;

  /// Download the current item
  /// Can throw errors if something goes wrong
  Future<File> downloadItem() async {
    //   emit(state.copyWith(status: OnGoingDownloadStatus.downloading));
    //   try {
    //     final fileBytes = await _downloadsRepository.downloadItem(
    //         itemId: state.item.id, stateOfDownload: state.stateOfDownload, cancelToken: state.cancelToken);
    //     final file = _downloadsRepository.saveFile(bytes: fileBytes, item: state.item);
    //     state.stateOfDownload.add(0);
    //     try {
    //       emit(state.copyWith(status: OnGoingDownloadStatus.downloaded));
    //     } on StateError catch (_) {}
    //     return file;
    //   } catch (_) {
    //     emit(state.copyWith(status: OnGoingDownloadStatus.notDownloaded));
    //     rethrow;
    //   }
    return Future.value();
  }
}
