import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/shared/utils/blurhash_util.dart';

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
    final hash = BlurHashUtil.fallBackBlurHash(
            item.imageBlurHashes, ImageType.PRIMARY) ??
        '';
    return Stack(
      children: [
        BlurHash(hash: hash),
        ClipRect(
            clipBehavior: Clip.hardEdge,
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 17, sigmaY: 17),
                child: Container(color: Colors.white.withOpacity(0.2)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 12),
          child: Center(
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
      ],
    );
  }
}
