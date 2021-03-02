import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

import '../asyncImage.dart';

class Poster extends StatelessWidget {
  final String tag;
  final BoxFit boxFit;
  final Item item;
  final bool showParent;

  const Poster(
      {Key key,
      this.showParent = false,
      @required this.tag,
      @required this.boxFit,
      @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncImage(
      showParent ? item.getParentId() : item.getIdBasedOnImage(),
      item.imageTags.primary,
      item.imageBlurHashes,
      tag: tag,
      boxFit: boxFit,
    );
  }
}
