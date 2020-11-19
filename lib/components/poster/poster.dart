import 'package:flutter/material.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/shared.dart';

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
      aspectRatio: handleAspectRatio(item),
      child: AsyncImage(
        itemsPoster(item),
        item.imageTags.primary,
        item.imageBlurHashes,
        tag: type,
        boxFit: boxFit,
        alignment: Alignment.center,
      ),
    );
  }
}

String itemsPoster(Item item) {
  if (item.type == 'Season') {
    if (item.imageTags.primary != null) return item.id;
    return item.seriesId;
  }
  return item.id;
}

double handleAspectRatio(Item item) {
  if (item.primaryImageAspectRatio != null) {
    if (item.primaryImageAspectRatio > 0.0) {
      return item.primaryImageAspectRatio;
    }
    return aspectRatio(type: item.type);
  }
  return aspectRatio(type: item.type);
}
