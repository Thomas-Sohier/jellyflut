// Useful for compute function only

import 'package:jellyflut_models/jellyflut_models.dart';

Item parseItem(Map<String, dynamic> data) {
  return Item.fromMap(data);
}

Category parseCategory(Map<String, dynamic> data) {
  return Category.fromMap(data);
}
