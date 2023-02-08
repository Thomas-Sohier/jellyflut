import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class SearchProvider extends ChangeNotifier {
  final Map<String, Future<Category>> _searchResult = <String, Future<Category>>{};

  UnmodifiableMapView<String, Future<Category>> get searchResult => UnmodifiableMapView(_searchResult);

  // Singleton
  static final SearchProvider _searchProvider = SearchProvider._internal();

  factory SearchProvider() {
    return _searchProvider;
  }

  SearchProvider._internal();

  void addSearchResult(String key, Future<Category> result) {
    _searchResult.putIfAbsent(key, () => result);
    notifyListeners();
  }

  void clearSearchResult() {
    _searchResult.clear();
    notifyListeners();
  }
}
