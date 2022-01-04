import 'dart:ui';

import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';
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
          child: DropShadow(
            blurRadius: 8,
            offset: const Offset(0, 0),
            child: Poster(
              item: item,
              heroTag: heroTag,
              tag: ImageType.PRIMARY,
              clickable: false,
              showParent: false,
              boxFit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
