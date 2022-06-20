import 'package:flutter/material.dart';

import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class BackgroundImage extends StatelessWidget {
  final Item item;
  final ImageType imageType;

  const BackgroundImage(
      {super.key, required this.item, this.imageType = ImageType.PRIMARY});

  @override
  Widget build(BuildContext context) {
    return AsyncImage(
      item: item,
      width: double.infinity,
      height: double.infinity,
      tag: imageType,
      boxFit: BoxFit.cover,
    );
  }
}
