import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/itemImageService.dart';

class MusicItem {
  MusicItem(
      {required this.id,
      required this.title,
      required this.item,
      this.artist,
      this.album,
      this.url,
      this.image});

  int id;
  String title;
  Item item;
  String? artist;
  String? album;
  String? url;
  Uint8List? image;

  static Future<MusicItem> parseFromItem(int id, String url, Item item) async {
    final urlImage = ItemImageService.getItemImageUrl(
        item.correctImageId(), item.correctImageTags(),
        imageBlurHashes: item.imageBlurHashes);
    return MusicItem(
        id: id,
        album: item.album,
        item: item,
        artist: item.artists!.map((e) => e.name.trim()).join(', ').toString(),
        title: item.name,
        url: url,
        image: (await NetworkAssetBundle(Uri.parse(urlImage)).load(urlImage))
            .buffer
            .asUint8List());
  }

  Map<String, dynamic> toMap() => {
        'Id': id,
        'Title': title,
        'Item': item.toMap(),
        'Artist': artist,
        'Album': album,
        'Url': url,
        'Image': image,
      };
}
