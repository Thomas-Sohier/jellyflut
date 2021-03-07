import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';

import '../asyncImage.dart';

class Poster extends StatelessWidget {
  final String tag;
  final BoxFit boxFit;
  final Item item;
  final bool isFocus;
  final Color focusColor;
  final bool showParent;

  const Poster(
      {Key key,
      this.showParent = false,
      @required this.tag,
      @required this.boxFit,
      @required this.isFocus,
      @required this.focusColor,
      @required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFocus
        ? Container(
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
                  tag: tag,
                  boxFit: boxFit,
                )))
        : AspectRatio(
            aspectRatio: item.getPrimaryAspectRatio(),
            child: AsyncImage(
              showParent ? item.getParentId() : item.getIdBasedOnImage(),
              item.imageTags.primary,
              item.imageBlurHashes,
              tag: tag,
              boxFit: boxFit,
            ));
  }
}
