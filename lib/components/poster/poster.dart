import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

import '../asyncImage.dart';

class Poster extends StatelessWidget {
  final String type;
  final BoxFit boxFit;
  final Item item;
  final Color focusColor;
  final bool showParent;

  const Poster(
      {Key key,
      this.showParent = false,
      @required this.type,
      @required this.focusColor,
      @required this.boxFit,
      @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: focusColor),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.all(2),
        child: AspectRatio(
          aspectRatio: item.getPrimaryAspectRatio(),
          child: AsyncImage(
            showParent ? item.getParentId() : item.getIdBasedOnImage(),
            item.imageTags.primary,
            item.imageBlurHashes,
            tag: type,
            boxFit: boxFit,
            alignment: Alignment.center,
          ),
        ));
  }
}
