import 'package:flutter/material.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class DetailsInfosFuture {
  ThemeData theme;
  Future<Item> item;

  DetailsInfosFuture({required this.theme, required this.item});
}
