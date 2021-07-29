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
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)), child: body());
  }

  Widget body() {
    var hash = _fallBackBlurHash(blurHash, tag);
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

  String? _fallBackBlurHash(ImageBlurHashes imageBlurHashes, String tag) {
    // TODO add enum
    if (tag == 'Primary') {
      return _fallBackBlurHashPrimary(imageBlurHashes);
    } else if (tag == 'Logo') {
      return _fallBackBlurHashLogo(imageBlurHashes);
    } else if (tag == 'Backdrop') {
      return imageBlurHashes.backdrop?.values.first;
    } else if (tag == 'Thumb') {
      return imageBlurHashes.thumb?.values.first;
    } else if (tag == 'Art') {
      return imageBlurHashes.art?.values.first;
    } else if (tag == 'Banner') {
      return imageBlurHashes.banner?.values.first;
    }
    return null;
  }

  String? _fallBackBlurHashPrimary(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.primary != null &&
        imageBlurHashes.primary!.isNotEmpty) {
      return imageBlurHashes.primary!.values.first;
    } else if (imageBlurHashes.backdrop != null &&
        imageBlurHashes.backdrop!.isNotEmpty) {
      return imageBlurHashes.backdrop!.values.first;
    } else if (imageBlurHashes.art != null && imageBlurHashes.art!.isNotEmpty) {
      return imageBlurHashes.art!.values.first;
    } else if (imageBlurHashes.thumb != null &&
        imageBlurHashes.thumb!.isNotEmpty) {
      return imageBlurHashes.thumb!.values.first;
    }
    return null;
  }

  String? _fallBackBlurHashLogo(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.logo != null) {
      return imageBlurHashes.logo!.values.first;
    }
    return null;
  }
}
