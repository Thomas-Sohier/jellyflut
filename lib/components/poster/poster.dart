import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

import '../asyncImage.dart';

class Poster extends StatelessWidget {
  final String type;
  final BoxFit boxFit;
  final Item item;

  const Poster(
      {Key key,
      @required this.type,
      @required this.boxFit,
      @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: item.getPrimaryAspectRatio(),
      child: AsyncImage(
        item.getIdBasedOnImage(),
        item.imageTags.primary,
        item.imageBlurHashes,
        tag: type,
        boxFit: boxFit,
        alignment: Alignment.center,
      ),
    );
  }
}
