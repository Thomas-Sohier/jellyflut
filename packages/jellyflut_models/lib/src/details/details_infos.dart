import 'package:flutter/material.dart';

import '../jellyfin/jellyfin.dart';

class DetailsInfosFuture {
  ThemeData theme;
  Future<Item> item;

  DetailsInfosFuture({required this.theme, required this.item});
}
