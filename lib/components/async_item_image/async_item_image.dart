import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/async_item_image/cubit/async_image_cubit.dart';
import 'package:jellyflut/components/zoomable_image/zommable_image_controller.dart';
import 'package:jellyflut/components/zoomable_image/zoomable_image.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:octo_image/octo_image.dart';

// Import de votre BlurHash widget si vous le mettez dans un fichier séparé
// import 'package:jellyflut/shared/blurhash.dart';

class AsyncImage extends StatelessWidget {
  final Item item;
  final ImageType imageType;
  final BoxFit boxFit;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final ZoomableImageController? zoomableImageController;
  final bool showOverlay;
  final bool showParent;

  const AsyncImage({
    super.key,
    required this.item,
    this.imageType = ImageType.Primary,
    this.boxFit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    this.zoomableImageController,
    this.showOverlay = false,
    this.showParent = false,
  });

  @override
  Widget build(BuildContext context) {
    final hash = imageType != ImageType.Logo ? item.imageBlurHashes?.getBlurHashValueFromImageType(imageType) : null;

    return BlocProvider(
      create: (context) => AsyncImageCubit(
        itemsRepository: context.read<ItemsRepository>(),
        itemId: showParent ? item.seriesId ?? item.id : item.id,
        imageType: imageType,
        tag: item.id,
        hash: hash,
      )..init(), // On appelle la nouvelle méthode d'initialisation
      child: BlocBuilder<AsyncImageCubit, AsyncImageState>(
        builder: (context, state) {
          return ClipRRect(
            borderRadius: borderRadius,
            child: OctoImage(
              image: state.imageProvider ?? const NetworkImage(''),
              imageBuilder: _imageBuilder,
              placeholderBuilder: (context) {
                if (state.placeholderImage != null) {
                  return RawImage(image: state.placeholderImage!, fit: boxFit);
                }
                return Container(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1));
              },
              errorBuilder: (context, error, stack) {
                if (state.placeholderImage != null) {
                  return RawImage(image: state.placeholderImage!, fit: boxFit);
                }
                return Container(color: Colors.red.withValues(alpha: 0.1));
              },
              fit: boxFit,
              width: width,
              height: height,
            ),
          );
        },
      ),
    );
  }

  Widget _imageBuilder(BuildContext context, Widget image) {
    if (zoomableImageController != null) {
      return ZoomableImage(
        zoomableImageController: zoomableImageController,
        imageWidget: image,
        overlay: showOverlay ? Colors.black.withAlpha(100) : null,
      );
    }
    return image;
  }
}
