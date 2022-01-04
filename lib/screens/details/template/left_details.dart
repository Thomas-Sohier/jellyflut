import 'package:flutter/material.dart';

import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class LeftDetails extends StatelessWidget {
  final Item item;
  final String? heroTag;

  const LeftDetails({
    Key? key,
    required this.item,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (c, constraint) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: constraint.maxHeight * 0.9),
        child: Center(
          child: Poster(
            item: item,
            heroTag: heroTag,
            tag: ImageType.PRIMARY,
            clickable: false,
            dropShadow: true,
            showParent: false,
            boxFit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
