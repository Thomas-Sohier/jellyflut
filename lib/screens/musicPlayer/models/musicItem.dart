import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';

class MusicItem {
  MusicItem(
      {required this.id,
      required this.title,
      this.artist,
      this.album,
      this.url,
      this.image});

  int id;
  String title;
  String? artist;
  String? album;
  String? url;
  Uint8List? image;

  static Future<MusicItem> parseFromItem(int id, String url, Item item) async {
    final urlImage = getItemImageUrl(
        item.correctImageId(), item.correctImageTags(),
        imageBlurHashes: item.imageBlurHashes);
    return MusicItem(
        id: id,
        album: item.album,
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
        'Artist': artist,
        'Album': album,
        'Url': url,
        'Image': image,
      };
}
