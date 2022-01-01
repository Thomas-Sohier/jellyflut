import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class HomeCategoryProvider extends ChangeNotifier {
  final Map<String, List<Item>> _categories = {};

  UnmodifiableMapView<String, List<Item>> get searchResult =>
      UnmodifiableMapView(_categories);

  // Getter
  Map<String, List<Item>> get getCategories => _categories;
  List<Item> getCategoryItem(final String key) => _categories.entries
      .firstWhere((element) => element.key == key,
          orElse: () => MapEntry(key, <Item>[]))
      .value;
  bool isCategoryPresent(final String key) => _categories.keys.contains(key);

  // Setter
  void addCategory(final MapEntry<String, List<Item>> category) {
    _categories.putIfAbsent(category.key, () => category.value);
    notifyListeners();
  }

  // Singleton
  static final HomeCategoryProvider _ItemsProvider =
      HomeCategoryProvider._internal();

  factory HomeCategoryProvider() {
    return _ItemsProvider;
  }

  HomeCategoryProvider._internal();
}
