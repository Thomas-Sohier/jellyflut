import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/components/asyncImage.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class BackgroundImage extends StatelessWidget {
  final Item item;
  final String imageType;

  const BackgroundImage(
      {Key? key, required this.item, this.imageType = 'Primary'})
      : super(key: key);

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
            item.correctImageId(searchType: imageType),
            item.correctImageTags(searchType: imageType),
            item.imageBlurHashes,
            tag: imageType,
            boxFit: BoxFit.cover,
          )),
    );
  }
}
