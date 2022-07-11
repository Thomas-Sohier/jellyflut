import 'package:flutter/material.dart';

import 'package:jellyflut/components/async_item_image/async_item_image.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class PlaceholderScreen extends StatelessWidget {
  final Item? item;
  const PlaceholderScreen({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return CircularProgressIndicator();
    }
    return itemPlacheholder();
  }

  Widget itemPlacheholder() {
    final item = this.item!;
    return AsyncImage(
        item: item,
        width: double.infinity,
        height: double.infinity,
        boxFit: BoxFit.fitHeight,
        imageType: ImageType.Backdrop,
        showParent: true,
        backup: item.type == ItemType.TvChannel ? true : false);
  }
}
