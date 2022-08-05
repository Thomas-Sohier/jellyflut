import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/form/fields/fields_enum.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'collection_event.dart';
part 'collection_state.dart';

enum ListItemsType { fromItem, fromList, fromFunction }

/// A `CollectionBloc` which manages an `List<Item>` as its state.
class CollectionBloc extends Bloc<CollectionEvent, SeasonState> {
  CollectionBloc({
    required ItemsRepository itemsRepository,
    Item? parentItem,
    List<Item>? items,
    Future<List<Item>> Function(int startIndex, int limit)? fetchMethod,
    bool showTitle = false,
    bool showIfEmpty = true,
    bool showSorting = true,
    double verticalListPosterHeight = double.infinity,
    double horizontalListPosterHeight = 150,
    double gridPosterHeight = 100,
    ListType listType = ListType.grid,
  })  : assert(parentItem != null || fetchMethod != null || items != null),
        super(SeasonState(
            fetchMethod: _initFetchMethod(
                itemsRepository: itemsRepository, parentItem: parentItem, items: items, fetchMethod: fetchMethod),
            listType: listType,
            showTitle: showTitle,
            showIfEmpty: showIfEmpty,
            showSorting: showSorting,
            horizontalListPosterHeight: horizontalListPosterHeight,
            verticalListPosterHeight: verticalListPosterHeight,
            gridPosterHeight: gridPosterHeight,
            scrollController: ScrollController())) {
    on<InitCollectionRequested>(_initCollectionList);
    on<ReplaceItem>(_replaceItems);
    on<ClearItemsRequested>(_onClearItems);
    on<SetScrollController>(_onScrollControllerUpdate);
    on<LoadMoreItemsRequested>(_onLoadMoreItems);
    on<ListTypeChangeRequested>(_onListTypeChange);
    on<SortByField>(_onSort);
  }

  static Future<List<Item>> Function(int startIndex, int limit) _initFetchMethod(
      {required ItemsRepository itemsRepository,
      Item? parentItem,
      List<Item>? items,
      Future<List<Item>> Function(int startIndex, int limit)? fetchMethod}) {
    ListItemsType findItemType() {
      if (parentItem != null) return ListItemsType.fromItem;
      if (fetchMethod != null) return ListItemsType.fromFunction;
      if (items != null) return ListItemsType.fromList;
      throw Exception('CollectionBloc badly initialized, need to have a parentItem or an item list or a fetch method');
    }

    final listItemsType = findItemType();
    switch (listItemsType) {
      case ListItemsType.fromItem:
        return (int startIndex, int limit) async {
          final category =
              await itemsRepository.getCategory(parentId: parentItem!.id, startIndex: startIndex, limit: limit);
          return category.items;
        };
      case ListItemsType.fromFunction:
        return fetchMethod!;
      case ListItemsType.fromList:
        return (int startIndex, int limit) async {
          return items?.sublist(startIndex, min(items.length, limit)) ?? [];
        };
      default:
        return (int startIndex, int limit) => Future.value(const <Item>[]);
    }
  }

  void _initCollectionList(InitCollectionRequested event, Emitter<SeasonState> emit) async {
    emit(state.copyWith(collectionStatus: SeasonStatus.loading));
    final items = await state.fetchMethod(state.items.length, 100);
    final canLoadMore = items.length >= 100;
    emit(state.copyWith(items: items, canLoadMore: canLoadMore, collectionStatus: SeasonStatus.success));
  }

  void _onClearItems(ClearItemsRequested event, Emitter<SeasonState> emit) {
    emit(state.copyWith(items: [], carouselSliderItems: [], canLoadMore: true));
  }

  void _onLoadMoreItems(LoadMoreItemsRequested event, Emitter<SeasonState> emit) async {
    if (state.canLoadMore && state.collectionStatus != SeasonStatus.loadingMore) {
      emit(state.copyWith(collectionStatus: SeasonStatus.loadingMore));
      final items = await state.fetchMethod(state.items.length, 100);
      final canLoadMore = items.length >= 100;

      emit(state.copyWith(
          items: [...state.items, ...items], canLoadMore: canLoadMore, collectionStatus: SeasonStatus.success));
    }
  }

  void _onScrollControllerUpdate(SetScrollController event, Emitter<SeasonState> emit) async {
    emit(state.copyWith(scrollController: event.scrollController));
  }

  void _onListTypeChange(ListTypeChangeRequested event, Emitter<SeasonState> emit) async {
    if (event.listType == null) {
      emit(state.copyWith(listType: state.listType.getNextListType()));
    } else {
      emit(state.copyWith(listType: event.listType));
    }
  }

  void _onSort(SortByField event, Emitter<SeasonState> emit) async {
    emit(state.copyWith(collectionStatus: SeasonStatus.loadingMore));
    final items = await _sortByField(event.fieldEnum);
    emit(state.copyWith(sortField: event.fieldEnum.fieldName, items: items, sortBy: state.sortBy.reverse()));
  }

  void _replaceItems(ReplaceItem event, Emitter<SeasonState> emit) async {
    emit(state.copyWith(items: event.items));
  }

  Future<List<Item>> _sortByField(FieldsEnum fieldEnum) async => (await compute(_sortItemByField,
      {'items': state.items, 'field': fieldEnum.fieldName, 'sortBy': state.sortBy.reverse()}))['items'];
}

Map<String, dynamic> _sortItemByField(Map<String, dynamic> arg) {
  late final sortingFunction;
  final List<Item> items = arg['items'];
  final String fieldToSort = arg['field'];
  final SortBy sortBy = arg['sortBy'];

  if (sortBy == SortBy.ASC) {
    sortingFunction = _sortByASC;
  } else if (sortBy == SortBy.DESC) {
    sortingFunction = _sortByDESC;
  }

  items.sort((a, b) {
    final aField = a.toJson()[fieldToSort];
    final bField = b.toJson()[fieldToSort];
    return sortingFunction(aField, bField);
  });

  return {'items': items};
}

int _sortByASC(dynamic a, dynamic b) {
  if (a != null && b != null) {
    return b.compareTo(a);
  } else if (a != null && b == null) {
    return -1;
  }
  if (a == null && b == null) {
    return 1;
  }
  return 0;
}

int _sortByDESC(dynamic a, dynamic b) {
  if (a != null && b != null) {
    return a.compareTo(b);
  } else if (a != null && b == null) {
    return -1;
  }
  if (a == null && b == null) {
    return 1;
  }
  return 0;
}
