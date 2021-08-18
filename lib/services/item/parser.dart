import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

// Useful for compute function only

Item parseItem(Map<String, dynamic> data) {
  return Item.fromMap(data);
}

Category parseCategory(Map<String, dynamic> data) {
  return Category.fromMap(data);
}
