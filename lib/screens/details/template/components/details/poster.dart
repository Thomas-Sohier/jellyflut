import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/poster.dart' as root_poster;
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class Poster extends StatelessWidget {
  final Item item;
  final String? heroTag;

  const Poster({super.key, required this.item, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: root_poster.Poster(
          item: item,
          key: ValueKey(item),
          boxFit: BoxFit.cover,
          clickable: false,
          showParent: true,
          tag: ImageType.PRIMARY,
          heroTag: heroTag,
        ));
  }
}
