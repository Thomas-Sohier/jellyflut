import 'package:flutter/material.dart';

class CarrousselModel extends ChangeNotifier {
  String itemId;

  // Singleton
  static final CarrousselModel _carrousselModel = CarrousselModel._internal();

  factory CarrousselModel() {
    return _carrousselModel;
  }

  CarrousselModel._internal();

  void changeItem(String _itemId) {
    _carrousselModel.itemId = _itemId;
    notifyListeners();
  }

  void reset() {
    _carrousselModel.itemId = null;
  }
}
