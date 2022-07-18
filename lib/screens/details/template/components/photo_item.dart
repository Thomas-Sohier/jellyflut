import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/screens/details/bloc/details_bloc.dart';

import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoItem extends StatelessWidget {
  const PhotoItem({super.key});

  @override
  Widget build(BuildContext context) {
    final heroTag = context.read<DetailsBloc>().state.heroTag;
    final item = context.read<DetailsBloc>().state.item;
    final items = <Item>[];
    if (items.isEmpty) {
      return PhotoView(
        heroAttributes: heroTag != null ? PhotoViewHeroAttributes(tag: heroTag) : null,
        imageProvider: NetworkImage(context
            .read<ItemsRepository>()
            .getItemImageUrl(itemId: item.correctImageId(), type: ImageType.Primary, tag: item.correctImageTags()!)),
      );
    }
    return listOfPhoto(items);
  }

  Widget listOfPhoto(List<Item> items) {
    const startAt = 0;
    final pageController = PageController(initialPage: startAt);
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        var item = items[index];
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(context
              .read<ItemsRepository>()
              .getItemImageUrl(itemId: item.correctImageId(), type: ImageType.Primary, tag: item.correctImageTags()!)),
          initialScale: PhotoViewComputedScale.contained,
        );
      },
      itemCount: items.length,
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
      pageController: pageController,
    );
  }
}
