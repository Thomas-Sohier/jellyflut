import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/background.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';
import 'package:jellyflut/models/item.dart';

class AsyncImage extends StatefulWidget {
  AsyncImage(this.item, this.blurHash,
      {this.tag = "Primary", this.boxFit = BoxFit.fitHeight});

  final Item item;
  final ImageBlurHashes blurHash;
  final String tag;
  final BoxFit boxFit;

  @override
  State<StatefulWidget> createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  @override
  Widget build(BuildContext context) {
    return body(widget.item, widget.tag, widget.boxFit);
  }
}

Widget body(Item item, String tag, BoxFit boxFit) {
  return CachedNetworkImage(
    imageUrl: getItemImageUrl(item, type: tag),
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider, fit: boxFit, alignment: Alignment.topCenter),
      ),
    ),
    fadeInCurve: Curves.easeInOut,
    placeholder: (context, url) {
      String hash = _fallBackBlurHash(item.imageBlurHashes, tag);
      if (tag != "Logo" && hash != null)
        return AspectRatio(
            aspectRatio: 3 / 4,
            child:
                BlurHash(hash: _fallBackBlurHash(item.imageBlurHashes, tag)));
      else
        return Container();
    },
    errorWidget: (context, url, error) {
      String hash = _fallBackBlurHash(item.imageBlurHashes, tag);
      if (tag != "Logo" && hash != null)
        return AspectRatio(aspectRatio: 3 / 4, child: BlurHash(hash: hash));
      else
        return Container();
    },
  );
}

String _fallBackBlurHash(ImageBlurHashes imageBlurHashes, String tag) {
  if (tag == "Primary") {
    return _fallBackBlurHashPrimary(imageBlurHashes);
  } else if (tag == "Logo") {
    return _fallBackBlurHashLogo(imageBlurHashes);
  }
  return null;
}

String _fallBackBlurHashPrimary(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.primary != null) {
    return imageBlurHashes.primary.values.first;
  } else if (imageBlurHashes.thumb != null) {
    return imageBlurHashes.thumb.values.first;
  } else if (imageBlurHashes.backdrop != null) {
    return imageBlurHashes.backdrop.values.first;
  } else if (imageBlurHashes.art != null) {
    return imageBlurHashes.art.values.first;
  }
  return null;
}

String _fallBackBlurHashLogo(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.logo != null) {
    return imageBlurHashes.logo.values.first;
  }
  return null;
}
