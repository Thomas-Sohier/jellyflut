import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';
import 'package:jellyflut/shared/shared.dart';

class AsyncImage extends StatefulWidget {
  AsyncImage(this.itemId, this.blurHash,
      {this.tag = 'Primary',
      this.boxFit = BoxFit.fitHeight,
      this.alignment = Alignment.topCenter});

  final String itemId;
  final ImageBlurHashes blurHash;
  final String tag;
  final BoxFit boxFit;
  final Alignment alignment;

  @override
  State<StatefulWidget> createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  @override
  Widget build(BuildContext context) {
    return body(widget.itemId, widget.blurHash, widget.tag, widget.boxFit,
        widget.alignment);
  }
}

Widget body(String itemId, ImageBlurHashes blurHash, String tag, BoxFit boxFit,
    Alignment alignment) {
  return CachedNetworkImage(
    imageUrl: getItemImageUrl(itemId, blurHash, type: tag),
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider, fit: boxFit, alignment: alignment),
      ),
    ),
    fadeInCurve: Curves.easeInOut,
    placeholder: (context, url) {
      var hash = _fallBackBlurHash(blurHash, tag);
      if (tag != 'Logo' && hash != null) {
        return AspectRatio(
            aspectRatio: aspectRatio(),
            child: BlurHash(hash: _fallBackBlurHash(blurHash, tag)));
      } else {
        return Container();
      }
    },
    errorWidget: (context, url, error) {
      var hash = _fallBackBlurHash(blurHash, tag);
      if (tag != 'Logo' && hash != null) {
        return AspectRatio(
            aspectRatio: aspectRatio(), child: BlurHash(hash: hash));
      } else {
        return Container();
      }
    },
  );
}

String _fallBackBlurHash(ImageBlurHashes imageBlurHashes, String tag) {
  if (tag == 'Primary') {
    return _fallBackBlurHashPrimary(imageBlurHashes);
  } else if (tag == 'Logo') {
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
