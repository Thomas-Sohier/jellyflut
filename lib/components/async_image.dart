import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/shared/utils/blurhash_util.dart';
import 'package:octo_image/octo_image.dart';

class AsyncImage extends StatelessWidget {
  final Item item;
  final ImageType tag;
  final BoxFit boxFit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool showParent;

  const AsyncImage(
      {required this.item,
      Key? key,
      this.tag = ImageType.PRIMARY,
      this.boxFit = BoxFit.fitHeight,
      this.placeholder,
      this.errorWidget,
      this.showParent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)), child: body());
  }

  Widget body() {
    final itemId = showParent ? item.getParentId() : item.correctImageId();
    final hash = BlurHashUtil.fallBackBlurHash(item.imageBlurHashes, tag);
    final url = ItemImageService.getItemImageUrl(
        itemId, item.correctImageTags(searchType: tag),
        type: item.correctImageType(searchType: tag),
        imageTags: item.imageTags);
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
      return (_, o, e) => const SizedBox();
    }
    return (_, o, e) => errorWidget != null ? errorWidget! : noPhotoActor();
  }

  Widget Function(BuildContext) imagePlaceholder(String? hash) {
    // If we don't have any hash then we don't have image so --> placeholder
    if (hash != null) {
      // If we show a Logo we don't load blurhash as it's a bit ugly
      if (tag != ImageType.LOGO) {
        return OctoPlaceholder.blurHash(hash);
      }
      return (_) => const SizedBox();
    }
    return (_) => placeholder != null ? placeholder! : noPhotoActor();
  }

  Widget noPhotoActor() {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(Icons.no_photography, color: Colors.white),
      ),
    );
  }
}
