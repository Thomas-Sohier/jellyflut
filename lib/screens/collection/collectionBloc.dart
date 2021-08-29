import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:jellyflut/models/jellyfin/category.dart' as model;
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/collection/collectionEvent.dart';
import 'package:jellyflut/services/item/itemService.dart';
import 'package:jellyflut/shared/shared.dart';

/// A `CollectionBloc` which manages an `List<Item>` as its state.
class CollectionBloc extends Bloc<CollectionEvent, List<Item>> {
  late Item parentItem;
  // Sorting by name
  bool _sortByNameASC = false;
  bool _sortByNameDSC = true;
  // Sorting by date
  bool _sortByDateASC = false;
  bool _sortByDateDSC = true;
  // Used to know if we should load another async method to fetch items
  // prevent from calling 1000 times API
  bool _blockItemsLoading = false;

  CollectionBloc() : super([]);

  void initialize(Item item) {
    parentItem = item;
    getItems(item: item).then((model.Category category) => add(
        CollectionEvent(items: category.items, status: CollectionStatus.ADD)));
  }

  @override
  Stream<List<Item>> mapEventToState(CollectionEvent event) async* {
    switch (event.status) {
      case CollectionStatus.ADD:
        state.addAll(event.items);
        yield state.toList();
        break;
      case CollectionStatus.LOAD_MORE:
        yield* showMoreItem();
        break;
      case CollectionStatus.SORT_NAME:
        final items = await _sortByName();
        state.clear();
        state.addAll(items);
        yield state.toList();
        break;
      case CollectionStatus.SORT_DATE:
        final items = await _sortByDate();
        state.clear();
        state.addAll(items);
        yield state.toList();
        break;
    }
  }

  Stream<List<Item>> showMoreItem() async* {
    if (!_blockItemsLoading && state.isNotEmpty) {
      _blockItemsLoading = true;
      final category =
          await getItems(item: parentItem, startIndex: state.length);
      if (category.items.isNotEmpty) {
        _blockItemsLoading = false;
        state.addAll(category.items);
        yield state.toList();
      }
    }
  }

  Future<List<Item>> _sortByName() async {
    final i = await compute(_sortItemByName, {
      'items': state,
      'sortByNameASC': _sortByNameASC,
      'sortByNameDSC': _sortByNameDSC
    });
    _sortByNameASC = i['sortByNameASC'];
    _sortByNameDSC = i['sortByNameDSC'];
    return i['items'];
  }

  Future<List<Item>> _sortByDate() async {
    var i = await compute(_sortItemByDate, {
      'items': state,
      'sortByDateASC': _sortByDateASC,
      'sortByDateDSC': _sortByDateDSC
    });
    _sortByDateASC = i['sortByDateASC'];
    _sortByDateDSC = i['sortByDateDSC'];
    return i['items'];
  }

  Future<model.Category> getItems(
      {required Item item, int startIndex = 0}) async {
    return ItemService.getItems(
        parentId: item.id,
        sortBy: 'SortName',
        fields:
            'PrimaryImageAspectRatio,SortName,PrimaryImageAspectRatio,DateCreated, DateAdded',
        imageTypeLimit: 1,
        startIndex: startIndex,
        includeItemTypes: item
            .getCollectionType()
            .map((e) => getEnumValue(e.toString()))
            .toList()
            .join(','),
        limit: 20);
  }
}

Map<String, dynamic> _sortItemByName(Map<String, dynamic> arg) {
  List<Item> items = arg['items'];
  bool sortByNameASC = arg['sortByNameASC'];
  bool sortByNameDSC = arg['sortByNameDSC'];
  if (!sortByNameASC || (!sortByNameASC && !sortByNameDSC)) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return a.name.compareTo(b.name);
      } else {
        return -1;
      }
    });
    sortByNameASC = true;
    sortByNameDSC = false;
  } else if (sortByNameASC) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return b.name.compareTo(a.name);
      } else {
        return -1;
      }
    });
    sortByNameASC = false;
    sortByNameDSC = true;
  }
  return {
    'items': items,
    'sortByNameASC': sortByNameASC,
    'sortByNameDSC': sortByNameDSC
  };
}

Map<String, dynamic> _sortItemByDate(Map<String, dynamic> arg) {
  List<Item> items = arg['items'];
  bool sortByDateASC = arg['sortByDateASC'];
  bool sortByDateDSC = arg['sortByDateDSC'];
  if (!sortByDateASC || (!sortByDateASC && !sortByDateDSC)) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return a.dateCreated!.compareTo(b.dateCreated!);
      } else {
        return -1;
      }
    });
    sortByDateASC = true;
    sortByDateDSC = false;
  } else if (sortByDateASC) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return b.dateCreated!.compareTo(a.dateCreated!);
      } else {
        return -1;
      }
    });
    sortByDateASC = false;
    sortByDateDSC = true;
  }
  return {
    'items': items,
    'sortByDateASC': sortByDateASC,
    'sortByDateDSC': sortByDateDSC
  };
}
