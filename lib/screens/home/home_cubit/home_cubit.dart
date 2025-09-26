import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_api/items_api.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/routes/router.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required ItemsRepository itemsRepository}) : _itemsRepository = itemsRepository, super(HomeState());

  final ItemsRepository _itemsRepository;

  Future<void> init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final libraryCategory = await _itemsRepository.getLibraryViews();
      final routes = generateRouteFromItems(libraryCategory.items);
      emit(state.copyWith(items: libraryCategory.items, routes: routes, status: HomeStatus.success));
    } on UnauthorizedException {
      emit(state.copyWith(status: HomeStatus.unauthorized));
      return;
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
      return;
    }
  }

  List<PageRouteInfo<dynamic>> generateRouteFromItems(final List<Item>? items) {
    final routes = <PageRouteInfo<dynamic>>[];
    final i = items ?? <Item>[];

    //initial route
    routes.add(HomeRoute());
    for (var item in i) {
      switch (item.collectionType) {
        case CollectionType.livetv:
          routes.add(LiveTvRoute(key: UniqueKey()));
          break;
        default:
          routes.add(CollectionRoute(key: UniqueKey(), item: item));
      }
    }
    return routes;
  }
}
