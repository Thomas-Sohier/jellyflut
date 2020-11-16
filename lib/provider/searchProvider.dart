import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class SearchProvider extends ChangeNotifier {
  Map<String, List<Item>> _searchResult = <String, List<Item>>{};

  UnmodifiableMapView<String, List<Item>> get searchResult =>
      UnmodifiableMapView(_searchResult);

  // Singleton
  static final SearchProvider _searchProvider = SearchProvider._internal();

  factory SearchProvider() {
    return _searchProvider;
  }

  SearchProvider._internal();

  void addSearchResult(Map<String, List<Item>> searchResult) {
    _searchResult.addAll(searchResult);
    notifyListeners();
  }

  void clearSearchResult() {
    _searchResult.clear();
    notifyListeners();
  }
}
