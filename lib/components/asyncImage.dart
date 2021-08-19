import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/imageType.dart';
import 'package:jellyflut/models/jellyfin/imageBlurHashes.dart';
import 'package:jellyflut/services/item/itemImageService.dart';
import 'package:jellyflut/shared/blurhash.dart';
import 'package:octo_image/octo_image.dart';

class AsyncImage extends StatelessWidget {
  AsyncImage(this.itemId, this.imageTag, this.blurHash,
      {this.tag = ImageType.PRIMARY,
      this.boxFit = BoxFit.fitHeight,
      this.placeholder,
      this.errorWidget});

  final String? imageTag;
  final String itemId;
  final ImageBlurHashes? blurHash;
  final ImageType tag;
  final BoxFit boxFit;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)), child: body());
  }

  Widget body() {
    var hash = BlurHashUtil.fallBackBlurHash(blurHash, tag);
    var url = ItemImageService.getItemImageUrl(itemId, imageTag,
        type: tag, imageBlurHashes: blurHash);
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
      if (tag != ImageType.LOGO) {
        return OctoError.blurHash(hash, icon: Icons.warning_amber_rounded);
      }
      return (_, o, e) => Container();
    }
    return (_, o, e) => errorWidget != null ? errorWidget! : noPhotoActor();
  }

  Widget Function(BuildContext) imagePlaceholder(String? hash) {
    // If we don't have any hash then we don't have image so --> placeholder
    if (hash != null) {
      // If we show a Logo we don't load blurhash as it's a bit ugly
      if (tag != ImageType.LOGO) {
        return OctoPlaceholder.blurHash(
          hash,
        );
      }
      return (_) => Container();
    }
    return (_) => placeholder != null ? placeholder! : noPhotoActor();
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
