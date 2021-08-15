import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/imageBlurHashes.dart';
import 'package:jellyflut/shared/blurhash.dart';
import 'package:octo_image/octo_image.dart';

class AsyncImage extends StatelessWidget {
  AsyncImage(this.itemId, this.imageTag, this.blurHash,
      {this.tag = 'Primary', this.boxFit = BoxFit.fitHeight, this.placeholder});

  final String? imageTag;
  final String itemId;
  final ImageBlurHashes? blurHash;
  final String tag;
  final BoxFit boxFit;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)), child: body());
  }

  Widget body() {
    var hash = BlurHashUtil.fallBackBlurHash(blurHash, tag);
    var url =
        getItemImageUrl(itemId, imageTag, type: tag, imageBlurHashes: blurHash);
    return OctoImage(
      image: CachedNetworkImageProvider(url),
      placeholderBuilder: imagePlaceholder(hash),
      errorBuilder: imagePlaceholderError(hash),
      fit: boxFit,
      fadeInDuration: Duration(milliseconds: 300),
      height: double.maxFinite,
      width: double.maxFinite,
    );
  }

  Widget Function(BuildContext, Object, StackTrace?) imagePlaceholderError(
      String? hash) {
    if (hash != null) {
      if (tag != 'Logo') {
        return OctoError.blurHash(hash, icon: Icons.warning_amber_rounded);
      }
      return (_, o, e) => Container();
    }
    return (_, o, e) => noPhotoActor();
  }

  Widget Function(BuildContext) imagePlaceholder(String? hash) {
    if (hash != null) {
      if (tag != 'Logo') {
        return OctoPlaceholder.blurHash(
          hash,
        );
      }
      return (_) => Container();
    }
    return (_) => noPhotoActor();
  }

  Widget noPhotoActor() {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(
          Icons.no_photography,
          color: Colors.white,
        ),
      ),
    );
  }
}
