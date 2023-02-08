import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit({required Item item, required ItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository,
        super(AlbumState(parentItem: item)) {
    _initFromItem();
  }

  final ItemsRepository _itemsRepository;

  /// First method to be called
  /// Init album and songs from given item
  Future<void> _initFromItem() async {
    emit(state.copyWith(status: Status.loading));

    try {
      final songs = (await _itemsRepository.getCategory(parentId: state.parentItem.id)).items;
      emit(state.copyWith(songs: songs, status: Status.success));
    } on Exception catch (_) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  /// Try to reload item seasons and episodes
  /// Useful on failure to allow user to reload data or when pull to refresh
  Future<void> retry() async {
    return _initFromItem();
  }
}
