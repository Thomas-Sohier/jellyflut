import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

class SearchProvider extends ChangeNotifier {
  final Map<String, List<Item>> _searchResult = <String, List<Item>>{};
  bool _showResults = false;

  UnmodifiableMapView<String, List<Item>> get searchResult =>
      UnmodifiableMapView(_searchResult);

  bool get showResults => _showResults;

  // Singleton
  static final SearchProvider _searchProvider = SearchProvider._internal();

  factory SearchProvider() {
    return _searchProvider;
  }

  SearchProvider._internal();

  void showResult() {
    _showResults = true;
  }

  void hideResult() {
    _showResults = false;
  }

  void addSearchResult(Map<String, List<Item>> searchResult) {
    _searchResult.addAll(searchResult);
    notifyListeners();
  }

  void clearSearchResult() {
    _searchResult.clear();
    _showResults = false;
    notifyListeners();
  }
}
