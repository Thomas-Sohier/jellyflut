import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';

class AsyncImage extends StatefulWidget {
  AsyncImage(this.itemId, this.blurHash, {this.tag = "Primary"});

  final String itemId;
  final ImageBlurHashes blurHash;
  final String tag;

  @override
  State<StatefulWidget> createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      getItemImageUrl(widget.itemId, type: widget.tag),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return BlurHash(hash: _fallBackBlurHash(widget.blurHash, widget.tag));
      },
      errorBuilder: (context, error, stackTrace) {
        return Container();
      },
    );
  }
}

String _fallBackBlurHash(ImageBlurHashes imageBlurHashes, String tag) {
  String hash;
  if (tag == "Primary") {
    hash = _fallBackBlurHashPrimary(imageBlurHashes);
  } else if (tag == "Logo") {
    hash = _fallBackBlurHashLogo(imageBlurHashes);
  }
  return hash;
}

String _fallBackBlurHashPrimary(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.primary != null) {
    return imageBlurHashes.primary.values.first;
  } else if (imageBlurHashes.thumb != null) {
    return imageBlurHashes.thumb.values.first;
  }
  return "";
}

String _fallBackBlurHashLogo(ImageBlurHashes imageBlurHashes) {
  if (imageBlurHashes.logo != null) {
    return imageBlurHashes.logo.values.first;
  }
  return "";
}
