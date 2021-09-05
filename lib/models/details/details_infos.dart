import 'package:flutter/cupertino.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class DetailsInfos {
  final Future<Color> dominantColor;
  final Future<Item> item;

  const DetailsInfos({required this.dominantColor, required this.item});
}
