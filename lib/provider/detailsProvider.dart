import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class DetailsProvider extends ChangeNotifier {
  Item _item = Item();

  Item get item => _item;
  // Singleton
  static final DetailsProvider _detailsProvider = DetailsProvider._internal();

  factory DetailsProvider() {
    return _detailsProvider;
  }

  DetailsProvider._internal();

  void updateItem(Item item) {
    _item = item;
    notifyListeners();
  }

  void clear() {
    _item = Item();
  }
}
