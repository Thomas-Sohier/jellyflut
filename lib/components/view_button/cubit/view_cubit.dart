import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'view_cubit.g.dart';
part 'view_state.dart';

class ViewCubit extends HydratedCubit<ViewState> {
  ViewCubit(this._itemsRepository, {required Item item})
      : _item = item,
        super(ViewState()) {
    _initFromItem(_item);
  }

  final ItemsRepository _itemsRepository;
  final Item _item;

  Future<void> _initFromItem(Item item) async {
    emit(state.copyWith(status: ViewStatus.loading));

    try {
      final isViewed = item.userData?.isFavorite ?? false;
      emit(
        state.copyWith(
          status: ViewStatus.success,
          isViewed: isViewed,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: ViewStatus.failure));
    }
  }

  void toggleFavorite() async {
    emit(state.copyWith(status: ViewStatus.loading));
    try {
      late final UserData userData;
      if (state.isViewed) {
        userData = await _itemsRepository.unviewItem(_item.id);
      } else {
        userData = await _itemsRepository.viewItem(_item.id);
      }
      emit(
        state.copyWith(
          status: ViewStatus.success,
          isViewed: userData.isFavorite,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: ViewStatus.failure));
    }
  }

  @override
  ViewState fromJson(Map<String, dynamic> json) => ViewState.fromJson(json);

  @override
  Map<String, dynamic> toJson(ViewState state) => state.toJson();
}
