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
    return Container(
      foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.black,
          Colors.transparent,
          Colors.transparent,
          Colors.black
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0, 0.2, 0.7, 1],
      )),
      child: Container(
          foregroundDecoration: BoxDecoration(color: Color(0x59000000)),
          child: AsyncImage(
            item: item,
            width: double.infinity,
            height: double.infinity,
            tag: imageType,
            boxFit: BoxFit.cover,
          )),
    );
  }
}
