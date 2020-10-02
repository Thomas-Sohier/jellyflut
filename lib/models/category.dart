// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'dart:collection';
import 'dart:convert';

import 'package:jellyflut/models/userData.dart';

import 'imageBlurHashes.dart';
import 'imageTags.dart';

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

class Item {
  Item({
    this.name,
    this.serverId,
    this.id,
    this.isFolder,
    this.type,
    this.userData,
    this.collectionType,
    this.imageTags,
    this.backdropImageTags,
    this.imageBlurHashes,
    this.locationType,
  });

  String name;
  String serverId;
  String id;
  bool isFolder;
  String type;
  UserData userData;
  String collectionType;
  ImageTags imageTags;
  List<dynamic> backdropImageTags;
  ImageBlurHashes imageBlurHashes;
  String locationType;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        name: json["Name"],
        serverId: json["ServerId"],
        id: json["Id"],
        isFolder: json["IsFolder"],
        type: json["Type"],
        userData: UserData.fromMap(json["UserData"]),
        collectionType: json["CollectionType"],
        imageTags: ImageTags.fromMap(json["ImageTags"]),
        backdropImageTags:
            List<dynamic>.from(json["BackdropImageTags"].map((x) => x)),
        imageBlurHashes: ImageBlurHashes.fromMap(json["ImageBlurHashes"]),
        locationType: json["LocationType"],
      );

  Map<String, dynamic> toMap() => {
        "Name": name,
        "ServerId": serverId,
        "Id": id,
        "IsFolder": isFolder,
        "Type": type,
        "UserData": userData.toMap(),
        "CollectionType": collectionType,
        "ImageTags": imageTags.toMap(),
        "BackdropImageTags":
            List<dynamic>.from(backdropImageTags.map((x) => x)),
        "ImageBlurHashes": imageBlurHashes.toMap(),
        "LocationType": locationType,
      };
}
