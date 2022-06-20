import 'package:flutter/material.dart';

import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class LeftDetails extends StatelessWidget {
  final Item item;
  final String? heroTag;
  final BoxConstraints constraints;

  const LeftDetails({
    super.key,
    required this.item,
    required this.constraints,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.9),
      child: Center(
        child: Poster(
          key: ValueKey(item),
          item: item,
          heroTag: heroTag,
          tag: ImageType.PRIMARY,
          clickable: false,
          dropShadow: true,
          showParent: false,
          boxFit: BoxFit.contain,
        ),
      ),
    );
  }
}
