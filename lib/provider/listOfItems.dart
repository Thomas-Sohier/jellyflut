import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class ListOfItems extends ChangeNotifier {
  final List<Item> _items = <Item>[];

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
}
