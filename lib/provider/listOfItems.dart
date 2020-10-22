import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class ListOfItems extends ChangeNotifier {
  final List<Item> _items = <Item>[];
  bool _sortByNameASC = false;
  bool _sortByNameDSC = false;
  bool _sortByDateASC = false;
  bool _sortByDateDSC = false;

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);
  // Singleton
  static final ListOfItems _listOfItems = ListOfItems._internal();

  factory ListOfItems() {
    return _listOfItems;
  }

  ListOfItems._internal();

  void addNewItems(List<Item> itemsToAdd) {
    _items.addAll(itemsToAdd);
    notifyListeners();
  }

  void reset() {
    _items.clear();
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
}
