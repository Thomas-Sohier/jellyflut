import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class StreamModel extends ChangeNotifier {
  Item _item = Item();

  // Singleton
  static final StreamModel _streamProvider = StreamModel._internal();

  Item get item => _item;

  factory StreamModel() {
    return _streamProvider;
  }

  StreamModel._internal();

  void setItem(Item item) {
    _item = item;
  }
}
