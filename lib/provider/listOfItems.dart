import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';

class ListOfItems extends ChangeNotifier {
  final List<Item> _items = <Item>[];
  final List<Item> _headerItems = <Item>[];
  Item _parentItem;
  bool _sortByNameASC = false;
  bool _sortByNameDSC = false;
  bool _sortByDateASC = false;
  bool _sortByDateDSC = false;

  // pagination
  int pageCount = 1;
  int startIndex = 0;
  bool isLoading = false;
  bool blockItemsLoading = false;

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  // Singleton
  static final ListOfItems _listOfItems = ListOfItems._internal();

  factory ListOfItems() {
    return _listOfItems;
  }

  ListOfItems._internal();

  void addNewItems(List<Item> itemsToAdd) async {
    _items.addAll(itemsToAdd);
    notifyListeners();
  }

  void reset() {
    pageCount = 1;
    startIndex = 0;
    _headerItems.clear();
    _items.clear();
  }

  Item getParentItem() {
    return _parentItem;
  }

  void setParentItem(Item parentItem) {
    _parentItem = parentItem;
  }

  Future<List<Item>> getheaderItems() async {
    if (_headerItems.isNotEmpty) return _headerItems;

    var filter = 'IsNotFolder,IsUnplayed';
    var fields =
        'ItemCounts,PrimaryImageAspectRatio,BasicSyncInfo,CanDelete,MediaSourceCount,Overview';
    var category = await getItems(
        parentId: _parentItem.id,
        limit: 5,
        fields: fields,
        filter: filter,
        sortBy: 'Random');
    _headerItems.addAll(category.items);
    return _headerItems;
  }

  void sortItemByDate() {
    if (_sortByDateDSC || !_sortByDateASC && !_sortByDateDSC) {
      _items.sort((a, b) {
        if (a.dateCreated != null && b.dateCreated != null) {
          return a.dateCreated.compareTo(b.dateCreated);
        } else {
          return -1;
        }
      });
      _sortByDateASC = true;
      _sortByDateDSC = false;
    } else if (_sortByDateASC) {
      _items.sort((a, b) {
        if (a.dateCreated != null && b.dateCreated != null) {
          return b.dateCreated.compareTo(a.dateCreated);
        } else {
          return -1;
        }
      });
      _sortByDateASC = false;
      _sortByDateDSC = true;
    }
    notifyListeners();
  }

  void sortItemByName() {
    if (_sortByNameDSC || !_sortByNameASC && !_sortByNameDSC) {
      _items.sort((a, b) => a.name.compareTo(b.name));
      _sortByNameASC = true;
      _sortByNameDSC = false;
    } else if (_sortByNameASC) {
      _items.sort((a, b) => b.name.compareTo(a.name));
      _sortByNameASC = false;
      _sortByNameDSC = true;
    }
    notifyListeners();
  }

  void showMoreItem() {
    if (blockItemsLoading == false) {
      blockItemsLoading = true;
      getItems(
              parentId: _parentItem.id,
              sortBy: 'Name',
              fields: 'DateCreated, DateAdded',
              startIndex: startIndex,
              includeItemTypes: _parentItem.getCollectionType(),
              limit: 100)
          .then((_category) {
        addNewItems(_category.items);
        if (_category.items.isNotEmpty) {
          startIndex = startIndex + 100;
          pageCount++;
          notifyListeners();
        }
        blockItemsLoading = false;
      });
    }
  }
}
