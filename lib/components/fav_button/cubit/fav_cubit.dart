import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fav_cubit.g.dart';
part 'fav_state.dart';

class FavCubit extends HydratedCubit<FavState> {
  FavCubit(this._itemsRepository, {required Item item})
      : _item = item,
        super(FavState()) {
    _initFromItem(_item);
  }

  final ItemsRepository _itemsRepository;
  final Item _item;

  Future<void> _initFromItem(Item item) async {
    emit(state.copyWith(status: FavStatus.loading));

    try {
      final isFavorite = item.userData?.isFavorite ?? false;
      emit(
        state.copyWith(
          status: FavStatus.success,
          isFav: isFavorite,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: FavStatus.failure));
    }
  }

  void toggleFavorite() async {
    emit(state.copyWith(status: FavStatus.loading));
    try {
      late final UserData userData;
      if (state.isFav) {
        userData = await _itemsRepository.unfavItem(_item.id);
      } else {
        userData = await _itemsRepository.favItem(_item.id);
      }
      emit(
        state.copyWith(
          status: FavStatus.success,
          isFav: userData.isFavorite,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: FavStatus.failure));
    }
  }

  @override
  FavState fromJson(Map<String, dynamic> json) => FavState.fromJson(json);

  @override
  Map<String, dynamic> toJson(FavState state) => state.toJson();
}
