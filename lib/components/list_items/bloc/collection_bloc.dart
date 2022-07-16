import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/form/fields/fields_enum.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'collection_event.dart';
part 'collection_state.dart';

enum ListItemsType { fromItem, fromList, fromFunction }

/// A `CollectionBloc` which manages an `List<Item>` as its state.
class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc({
    required ItemsRepository itemsRepository,
    Item? parentItem,
    List<Item>? items,
    Future<List<Item>> Function(int startIndex, int limit)? fetchMethod,
    bool showTitle = false,
    bool showIfEmpty = true,
    bool showSorting = true,
    ListType listType = ListType.grid,
  })  : assert(parentItem != null || fetchMethod != null || items != null),
        super(CollectionState(
            fetchMethod: _initFetchMethod(
                itemsRepository: itemsRepository, parentItem: parentItem, items: items, fetchMethod: fetchMethod),
            listType: listType,
            showTitle: showTitle,
            showIfEmpty: showIfEmpty,
            showSorting: showSorting,
            scrollController: ScrollController())) {
    on<InitCollectionRequested>(_initCollectionList);
    on<ClearItemsRequested>(_onClearItems);
    on<SetScrollController>(_onScrollControllerUpdate);
    on<LoadMoreItemsRequested>(_onLoadMoreItems);
    on<SortByField>(sortByField);
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

  void _initCollectionList(InitCollectionRequested event, Emitter<CollectionState> emit) async {
    emit(state.copyWith(collectionStatus: CollectionStatus.loading));
    final items = await state.fetchMethod(state.items.length, 100);
    final canLoadMore = items.length >= 100;
    emit(state.copyWith(items: items, canLoadMore: canLoadMore, collectionStatus: CollectionStatus.success));
  }

  void _onClearItems(ClearItemsRequested event, Emitter<CollectionState> emit) {
    emit(state.copyWith(items: [], carouselSliderItems: [], canLoadMore: true));
  }

  void _onLoadMoreItems(LoadMoreItemsRequested event, Emitter<CollectionState> emit) async {
    if (state.canLoadMore && state.collectionStatus != CollectionStatus.loadingMore) {
      emit(state.copyWith(collectionStatus: CollectionStatus.loadingMore));
      final items = await state.fetchMethod(state.items.length, 100);
      final canLoadMore = items.length >= 100;

      emit(state.copyWith(
          items: [...state.items, ...items], canLoadMore: canLoadMore, collectionStatus: CollectionStatus.success));
    }
  }

  void _onScrollControllerUpdate(SetScrollController event, Emitter<CollectionState> emit) async {
    emit(state.copyWith(scrollController: event.scrollController));
  }

  void sortByField(SortByField event, Emitter<CollectionState> emit) async {
    // emit(CollectionLoadingState());
    // final items = await _sortByField(event.fieldEnum, _sortBy);
    // _items.clear();
    // _items.addAll(items);
    // emit(CollectionLoadedState());
  }

  // Future<List<Item>> _sortByField(FieldsEnum fieldEnum, SortBy sortBy) async {
  //   final i = await compute(_sortItemByField, {'items': _items, 'field': fieldEnum.fieldName, 'sortBy': sortBy});
  //   _sortBy = sortBy.reverse();
  //   _currentSortedValue.value = fieldEnum;
  //   return i['items'];
  // }
}

enum SortBy {
  ASC,
  DESC;

  const SortBy();

  SortBy reverse() => this == SortBy.ASC ? SortBy.DESC : SortBy.ASC;
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
