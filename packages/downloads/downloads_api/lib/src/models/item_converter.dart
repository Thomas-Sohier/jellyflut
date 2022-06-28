import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:json_annotation/json_annotation.dart';

class ItemConverter implements JsonConverter<Item, Map<String, dynamic>> {
  const ItemConverter();

  @override
  Item fromJson(Map<String, dynamic> json) {
    return Item.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson(Item object) {
    return object.toMap();
  }
}
