import 'package:flutter/cupertino.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class DetailsInfosFuture {
  Future<Color> dominantColor;
  Future<Item> item;

  DetailsInfosFuture({required this.dominantColor, required this.item});
}

class DetailsInfos {
  final Future<Color> dominantColor;
  final Item item;

  const DetailsInfos({required this.dominantColor, required this.item});
}
