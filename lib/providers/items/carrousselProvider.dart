import 'package:flutter/material.dart';

class CarrousselProvider extends ChangeNotifier {
  String? itemId;

  // Singleton
  static final CarrousselProvider _CarrousselProvider =
      CarrousselProvider._internal();

  factory CarrousselProvider() {
    return _CarrousselProvider;
  }

  CarrousselProvider._internal();

  void changeItem(String _itemId) {
    _CarrousselProvider.itemId = _itemId;
    notifyListeners();
  }

  void reset() {
    _CarrousselProvider.itemId = null;
  }
}
