import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'home_category_state.dart';

class HomeCategoryCubit extends Cubit<HomeCategoryState> {
  HomeCategoryCubit({required ItemsRepository itemsRepository, HomeCategoryType? type, required Item? parentItem})
      : _itemsRepository = itemsRepository,
        assert((type != null || parentItem != null) ||
            (type == HomeCategoryType.item && parentItem != null) ||
            (type == null && parentItem != null)),
        super(type != null ? HomeCategoryState(type: type) : HomeCategoryState(parentItem: parentItem)) {
    _init();
  }

  final ItemsRepository _itemsRepository;

  Future<void> _init() async {
    emit(state.copyWith(status: HomeCategoryStatus.loading));
    final items = await _getItems();
    emit(state.copyWith(items: items, status: HomeCategoryStatus.success));
  }

  Future<List<Item>> _getItems() async {
    switch (state.type) {
      case HomeCategoryType.item:
        return _itemsRepository.getLatestMedia(
            parentId: state.parentItem!.id, fields: 'DateCreated, DateAdded, ImageTags');
      case HomeCategoryType.resume:
        final category = await _itemsRepository.getResumeItems();
        return category.items;
      case HomeCategoryType.latest:
        return _itemsRepository.getLatestMedia();
      default:
        return _itemsRepository.getLatestMedia(fields: 'DateCreated, DateAdded, ImageTags');
    }
  }
}
