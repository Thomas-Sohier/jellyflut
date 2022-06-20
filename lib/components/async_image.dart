import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/zoomable_image/zommable_image_controller.dart';
import 'package:jellyflut/components/zoomable_image/zoomable_image.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/shared/utils/blurhash_util.dart';
import 'package:jellyflut/shared/utils/color_util.dart';
import 'package:octo_image/octo_image.dart';

class AsyncImage extends StatefulWidget {
  final Item item;
  final ImageType tag;
  final BoxFit boxFit;
  final Widget Function(BuildContext)? placeholder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorWidget;
  final double? width;
  final double? height;
  final bool showParent;
  final bool backup;
  final bool showOverlay;
  final ZoomableImageController? zoomableImageController;

  /// Class to construct a class which return widget with image associated to parameters
  ///
  /// * [backup] mean to force parameter to search image and if there is no results then we return empty SizedBox
  /// * [showParent] mean to user parentid to load image datas
  /// * [placeholder] can be used to determine a placeholder while loading image
  const AsyncImage(
      {required this.item,
      super.key,
      this.tag = ImageType.PRIMARY,
      this.boxFit = BoxFit.fitHeight,
      this.placeholder,
      this.errorWidget,
      this.width,
      this.height,
      this.zoomableImageController,
      this.showOverlay = false,
      this.backup = true,
      this.showParent = false});

  @override
  State<AsyncImage> createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  late final Widget child;
  late final Color? overlay;
  late ImageType imageType;
  late String? imageTag;
  late String? hash;
  late String itemId;

  @override
  void initState() {
    super.initState();
    overlay = widget.showOverlay ? Colors.black.withAlpha(100) : null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    itemId = widget.showParent
        ? widget.item.getParentId()
        : widget.item.correctImageId();
    hash =
        BlurHashUtil.fallBackBlurHash(widget.item.imageBlurHashes, widget.tag);
    imageType = widget.backup
        ? widget.item.correctImageType(searchType: widget.tag)
        : widget.tag;
    imageTag = widget.backup
        ? widget.item.correctImageTags(searchType: widget.tag)
        : widget.item
            .getImageTagBySearchTypeOrNull(searchType: widget.tag)
            ?.value;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)), child: builder());
  }

  Widget builder() {
    final url =
        ItemImageService.getItemImageUrl(itemId, imageTag, type: imageType);
    return OctoImage(
        image: CachedNetworkImageProvider(url),
        placeholderBuilder: imagePlaceholder(hash),
        errorBuilder: imagePlaceholderError(hash),
        imageBuilder: (_, image) => ZoomableImage(
            zoomableImageController: widget.zoomableImageController,
            imageWidget: image,
            overlay: overlay),
        fit: widget.boxFit,
        width: widget.width,
        height: widget.height,
        fadeInDuration: Duration(milliseconds: 200));
  }

  Widget Function(BuildContext, Object, StackTrace?) imagePlaceholderError(
      String? hash) {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    if (hash != null) {
      if (widget.tag != ImageType.LOGO) {
        return OctoError.blurHash(hash, icon: Icons.warning_amber_rounded);
      }
      return (_, __, ___) => const SizedBox();
    }
    return widget.errorWidget != null
        ? widget.errorWidget!
        : (_, __, ___) => noPhotoActor();
  }

  Widget Function(BuildContext) imagePlaceholder(String? hash) {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }

    // If we don't have any hash then we don't have image so --> placeholder
    if (hash != null) {
      // If we show a Logo we don't load blurhash as it's a bit ugly
      if (widget.tag != ImageType.LOGO) {
        return OctoPlaceholder.blurHash(hash);
      }
      return (_) => const SizedBox();
    }
    return widget.placeholder != null
        ? widget.placeholder!
        : (_) => noPhotoActor();
  }

  Widget noPhotoActor() {
    return Container(
      color: ColorUtil.darken(Theme.of(context).colorScheme.background),
      child: Center(
        child: Icon(Icons.no_photography,
            color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
