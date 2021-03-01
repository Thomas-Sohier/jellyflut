import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';

class ListOfItems extends ChangeNotifier {
  List<Item> _items = <Item>[];
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

  List<Item> get items => _items;
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

  void sortItemByDate() async {
    var i = await compute(_sortItemByDate, {
      'items': _items,
      'sortByDateASC': _sortByDateASC,
      'sortByDateDSC': _sortByDateDSC
    });
    _items = i['items'];
    _sortByDateASC = i['sortByDateASC'];
    _sortByDateDSC = i['sortByDateDSC'];
    notifyListeners();
  }

  void sortItemByName() async {
    var i = await compute(_sortItemByName, {
      'items': _items,
      'sortByNameASC': _sortByNameASC,
      'sortByNameDSC': _sortByNameDSC
    });
    _items = i['items'];
    _sortByNameASC = i['sortByNameASC'];
    _sortByNameDSC = i['sortByNameDSC'];
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

Map<String, dynamic> _sortItemByDate(Map<String, dynamic> arg) {
  List<Item> items = arg['items'];
  bool sortByDateASC = arg['sortByDateASC'];
  bool sortByDateDSC = arg['sortByDateDSC'];
  if (!sortByDateASC || (!sortByDateASC && !sortByDateDSC)) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return a.dateCreated.compareTo(b.dateCreated);
      } else {
        return -1;
      }
    });
    sortByDateASC = true;
    sortByDateDSC = false;
  } else if (sortByDateASC) {
    items.sort((a, b) {
      if (a.dateCreated != null && b.dateCreated != null) {
        return b.dateCreated.compareTo(a.dateCreated);
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
