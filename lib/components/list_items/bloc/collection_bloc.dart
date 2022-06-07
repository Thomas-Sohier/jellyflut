import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyflut/models/enum/list_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart' as model;
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/form/forms/fields/fields_enum.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:rxdart/rxdart.dart';

part 'collection_event.dart';
part 'collection_state.dart';

/// A `CollectionBloc` which manages an `List<Item>` as its state.
class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  late Item parentItem;
  final List<Item> carouselSliderItems = <Item>[];
  final List<Item> _items = <Item>[];
  final BehaviorSubject<ListType> listType = BehaviorSubject<ListType>();
  late final Future<model.Category> Function(
      int startIndex, int numberOfItemsToLoad) loadMoreFunction;

  // Used to know if we should load another async method to fetch items
  // prevent from calling 1000 times API
  bool _blockItemsLoading = false;
  SortBy _sortBy = SortBy.ASC;
  final ValueNotifier<FieldsEnum?> _currentSortedValue =
      ValueNotifier<FieldsEnum?>(null);

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  SortBy get getSortOrder => _sortBy;
  ValueNotifier<FieldsEnum?> get getCurrentSortedValue => _currentSortedValue;

  CollectionBloc(
      {final ListType listType = ListType.GRID, required this.loadMoreFunction})
      : super(CollectionLoadingState()) {
    this.listType.add(listType);
    on<AddItem>(addItems);
    on<ClearItem>(removeItems);
    on<LoadMoreItems>(showMoreItem);
    on<SortByField>(sortByField);
  }

  void initialize(Item item) {
    parentItem = item;
    getItems(item: item)
        .then((model.Category category) => add(AddItem(items: category.items)));
  }

  void removeItems(ClearItem event, Emitter<CollectionState> emit) {
    _items.clear();
    emit(CollectionLoadedState());
  }

  void addItems(AddItem event, Emitter<CollectionState> emit) {
    emit(CollectionLoadingState());
    _items.addAll(event.items);
    // Filter only unplayed items
    final unplayedItems =
        _items.where((element) => !element.isPlayed()).toList();
    unplayedItems.shuffle();
    carouselSliderItems.addAll(event.items);
    emit(CollectionLoadedState());
  }

  void showMoreItem(LoadMoreItems event, Emitter<CollectionState> emit) async {
    if (!_blockItemsLoading && items.isNotEmpty) {
      _blockItemsLoading = true;
      final category = await loadMoreFunction(items.length, 100);
      if (category.items.isNotEmpty) {
        _blockItemsLoading = false;
        _items.addAll(category.items);
        emit(CollectionLoadedState());
      }
    }
  }

  void sortByField(SortByField event, Emitter<CollectionState> emit) async {
    emit(CollectionLoadingState());
    final items = await _sortByField(event.fieldEnum, _sortBy);
    _items.clear();
    _items.addAll(items);
    emit(CollectionLoadedState());
  }

  Future<List<Item>> _sortByField(FieldsEnum fieldEnum, SortBy sortBy) async {
    final i = await compute(_sortItemByField,
        {'items': _items, 'field': fieldEnum.name, 'sortBy': sortBy});
    _sortBy = sortBy.reverse();
    _currentSortedValue.value = fieldEnum;
    return i['items'];
  }

  Future<model.Category> getItems(
      {required Item item, int startIndex = 0}) async {
    return ItemService.getItems(
        parentId: item.id,
        sortBy: 'SortName',
        fields:
            'PrimaryImageAspectRatio,SortName,PrimaryImageAspectRatio,DateCreated,DateAdded,Overview',
        imageTypeLimit: 1,
        recursive: false,
        startIndex: startIndex,
        includeItemTypes:
            item.getCollectionType().map((e) => e.value).toList().join(','),
        limit: 100);
  }
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
    final aField = a[fieldToSort];
    final bField = b[fieldToSort];
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
