import 'package:flutter/material.dart';

import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoItem extends StatefulWidget {
  final Item item;
  final List<Item>? items;
  final String? heroTag;

  PhotoItem({super.key, required this.item, required this.heroTag, this.items});

  @override
  _PhotoItemState createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  late final PageController pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }

  Widget photoItem() {
    if (widget.items != null && widget.items!.isEmpty) {
      return PhotoView(
        heroAttributes: widget.heroTag != null
            ? PhotoViewHeroAttributes(tag: widget.heroTag!)
            : null,
        imageProvider: NetworkImage(ItemImageService.getItemImageUrl(
            widget.item.correctImageId(), widget.item.correctImageTags()!)),
      );
    }
    return listOfPhoto(widget.items!);
  }

  Widget listOfPhoto(List<Item> items) {
    var startAt = items.indexOf(widget.item);
    pageController = PageController(initialPage: startAt);
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        var item = items[index];
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(ItemImageService.getItemImageUrl(
              item.correctImageId(), item.correctImageTags()!)),
          initialScale: PhotoViewComputedScale.contained,
        );
      },
      itemCount: items.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
      pageController: pageController,
    );
  }
}
