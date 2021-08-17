import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/shared/blurhash.dart';

class LeftDetails extends StatelessWidget {
  final Item item;
  final String heroTag;

  const LeftDetails({
    Key? key,
    required this.item,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tag = 'Primary';
    final hash = BlurHashUtil.fallBackBlurHash(item.imageBlurHashes, tag) ?? '';
    return Stack(
      children: [
        BlurHash(hash: hash),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 12),
          child: Center(
              child: Poster(
            item: item,
            heroTag: heroTag,
            tag: tag,
            clickable: false,
            showParent: false,
            boxFit: BoxFit.contain,
          )),
        ),
      ],
    );
  }
}
