import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/shared/utils/blurhash_util.dart';
import 'package:octo_image/octo_image.dart';

class AsyncImage extends StatefulWidget {
  final Item item;
  final ImageType tag;
  final BoxFit boxFit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final bool showParent;

  const AsyncImage(
      {required this.item,
      Key? key,
      this.tag = ImageType.PRIMARY,
      this.boxFit = BoxFit.fitHeight,
      this.placeholder,
      this.errorWidget,
      this.width,
      this.height,
      this.showParent = false})
      : super(key: key);

  @override
  _AsyncImageState createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  late final Widget child;

  @override
  void initState() {
    super.initState();
    final itemId = widget.showParent
        ? widget.item.getParentId()
        : widget.item.correctImageId();
    final hash =
        BlurHashUtil.fallBackBlurHash(widget.item.imageBlurHashes, widget.tag);
    final url = ItemImageService.getItemImageUrl(
        itemId, widget.item.correctImageTags(searchType: widget.tag),
        type: widget.item.correctImageType(searchType: widget.tag),
        imageTags: widget.item.imageTags);

    if (widget.width != null && widget.height != null) {
      child = OctoImage(
          image: CachedNetworkImageProvider(url),
          placeholderBuilder: imagePlaceholder(hash),
          errorBuilder: imagePlaceholderError(hash),
          fit: widget.boxFit,
          width: widget.width,
          height: widget.height,
          fadeInDuration: Duration(milliseconds: 300));
    } else {
      child = OctoImage(
          image: CachedNetworkImageProvider(url),
          placeholderBuilder: imagePlaceholder(hash),
          errorBuilder: imagePlaceholderError(hash),
          fit: widget.boxFit,
          fadeInDuration: Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)), child: child);
  }

  Widget Function(BuildContext, Object, StackTrace?) imagePlaceholderError(
      String? hash) {
    if (hash != null) {
      if (widget.tag != ImageType.LOGO) {
        return OctoError.blurHash(hash, icon: Icons.warning_amber_rounded);
      }
      return (_, o, e) => const SizedBox();
    }
    return (_, o, e) =>
        widget.errorWidget != null ? widget.errorWidget! : noPhotoActor();
  }

  Widget Function(BuildContext) imagePlaceholder(String? hash) {
    // If we don't have any hash then we don't have image so --> placeholder
    if (hash != null) {
      // If we show a Logo we don't load blurhash as it's a bit ugly
      if (widget.tag != ImageType.LOGO) {
        return OctoPlaceholder.blurHash(hash);
      }
      return (_) => const SizedBox();
    }
    return (_) =>
        widget.placeholder != null ? widget.placeholder! : noPhotoActor();
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
