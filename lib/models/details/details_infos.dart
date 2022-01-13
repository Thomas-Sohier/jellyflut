import 'package:flutter/cupertino.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:rxdart/rxdart.dart';

class DetailsInfosFuture {
  BehaviorSubject<Future<List<Color>>> dominantColor;
  Future<Item> item;

  DetailsInfosFuture({required this.dominantColor, required this.item});
}
