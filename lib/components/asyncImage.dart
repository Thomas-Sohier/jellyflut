import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';
import 'package:octo_image/octo_image.dart';

class AsyncImage extends StatelessWidget {
  AsyncImage(this.itemId, this.imageTag, this.blurHash,
      {this.tag = 'Primary', this.boxFit = BoxFit.fitHeight, this.placeholder});

  final String itemId;
  final ImageBlurHashes blurHash;
  final String tag;
  final String imageTag;
  final BoxFit boxFit;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: body(itemId, imageTag, blurHash, tag, boxFit, placeholder));
  }
}

Widget body(String itemId, String imageTag, ImageBlurHashes blurHash,
    String tag, BoxFit boxFit, Widget placeholder) {
  var hash = _fallBackBlurHash(blurHash, tag);
  var url =
      getItemImageUrl(itemId, imageTag, type: tag, imageBlurHashes: blurHash);
  return OctoImage(
    image: CachedNetworkImageProvider(url),
    placeholderBuilder: tag != 'Logo'
        ? OctoPlaceholder.blurHash(
            hash,
          )
        : (_) => Container(),
    errorBuilder: tag != 'Logo'
        ? OctoError.blurHash(hash, icon: Icons.warning_amber_rounded)
        : (context, object, e) => Container(),
    fit: boxFit,
    fadeInDuration: Duration(milliseconds: 300),
    height: double.maxFinite,
    width: double.maxFinite,
  );
}

String _fallBackBlurHash(ImageBlurHashes imageBlurHashes, String tag) {
  if (tag == 'Primary') {
    return _fallBackBlurHashPrimary(imageBlurHashes);
  } else if (tag == 'Logo') {
    return _fallBackBlurHashLogo(imageBlurHashes);
  }
  return 'Primary';
}

String _fallBackBlurHashPrimary(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes == null) {
    return null;
  } else if (imageBlurHashes.primary != null) {
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
