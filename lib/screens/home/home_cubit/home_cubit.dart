import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/routes/router.gr.dart' as r;
import 'package:jellyflut_models/jellyflut_models.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required ItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository,
        super(HomeState()) {
    _init();
  }

  final ItemsRepository _itemsRepository;

  Future<void> _init() async {
    emit(state.copyWith(status: HomeStatus.loading));
    final libraryCategory = await _itemsRepository.getLibraryViews();
    final routes = generateRouteFromItems(libraryCategory.items);
    emit(state.copyWith(items: libraryCategory.items, routes: routes, status: HomeStatus.success));
  }

  List<PageRouteInfo<dynamic>> generateRouteFromItems(final List<Item>? items) {
    final routes = <PageRouteInfo<dynamic>>[];
    final i = items ?? <Item>[];

    //initial route
    routes.add(r.HomePage(key: UniqueKey()));
    for (var item in i) {
      switch (item.collectionType) {
        case CollectionType.livetv:
          routes.add(r.LiveTvPage(key: UniqueKey()));
          break;
        default:
          routes.add(r.CollectionPage(key: UniqueKey(), item: item));
      }
    }
    return routes;
  }
}
