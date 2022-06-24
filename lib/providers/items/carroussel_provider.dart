import 'package:flutter/material.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class CarrousselProvider extends ChangeNotifier {
  Item? _item;

  // Singleton
  static final CarrousselProvider _CarrousselProvider =
      CarrousselProvider._internal();

  factory CarrousselProvider() {
    return _CarrousselProvider;
  }

  CarrousselProvider._internal();

  Item? get item => _item;

  void changeItem(Item item) {
    _CarrousselProvider._item = item;
    notifyListeners();
  }

  void reset() {
    _CarrousselProvider._item = null;
  }
}
