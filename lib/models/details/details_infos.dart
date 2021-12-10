import 'package:flutter/cupertino.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class DetailsInfosFuture {
  final Future<Color> dominantColor;
  final Future<Item> item;

  const DetailsInfosFuture({required this.dominantColor, required this.item});
}

class DetailsInfos {
  final Future<Color> dominantColor;
  final Item item;

  const DetailsInfos({required this.dominantColor, required this.item});
}
