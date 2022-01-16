import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:rxdart/rxdart.dart';

class DetailsInfosFuture {
  BehaviorSubject<Future<List<Color>>> dominantColor;
  ThemeData theme;
  Future<Item> item;

  DetailsInfosFuture(
      {required this.dominantColor, required this.theme, required this.item});
}
