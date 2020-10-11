// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'dart:convert';

import 'package:jellyflut/models/item.dart';

Category categoryFromMap(String str) => Category.fromMap(json.decode(str));

String categoryToMap(Category data) => json.encode(data.toMap());

class Category {
  Category({
    this.items,
    this.totalRecordCount,
    this.startIndex,
  });

  List<Item> items;
  int totalRecordCount;
  int startIndex;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        items: List<Item>.from(json["Items"].map((x) => Item.fromMap(x))),
        totalRecordCount: json["TotalRecordCount"],
        startIndex: json["StartIndex"],
      );

  Map<String, dynamic> toMap() => {
        "Items": List<dynamic>.from(items.map((x) => x.toMap())),
        "TotalRecordCount": totalRecordCount,
        "StartIndex": startIndex,
      };
}
