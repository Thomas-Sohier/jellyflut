import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/async_item_image/cubit/async_image_cubit.dart';
import 'package:jellyflut/components/zoomable_image/zommable_image_controller.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:octo_image/octo_image.dart';

import '../zoomable_image/zoomable_image.dart';

class AsyncImage extends StatelessWidget {
  final Item item;
  final ImageType imageType;
  final BorderRadius borderRadius;
  final String? tag;
  final BoxFit boxFit;
  final double? width;
  final double? height;
  final bool showParent;
  final bool backup;
  final bool showOverlay;
  final Widget? notFoundPlaceholder;
  final ZoomableImageController? zoomableImageController;

  /// Class to construct a class which return widget with image associated to parameters
  ///
  /// * [backup] mean to force parameter to search image and if there is no results then we return empty SizedBox
  /// * [showParent] mean to user parentid to load image datas
  /// * [placeholder] can be used to determine a placeholder while loading image
  const AsyncImage(
      {required this.item,
      super.key,
      this.imageType = ImageType.Primary,
      this.boxFit = BoxFit.fitHeight,
      this.width,
      this.height,
      this.borderRadius = const BorderRadius.all(Radius.circular(5)),
      this.notFoundPlaceholder,
      this.zoomableImageController,
      this.showOverlay = false,
      this.backup = true,
      this.showParent = false,
      this.tag});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AsyncImageCubit(context.read<ItemsRepository>(),
          itemId: item.id,
          zoomableImageController: zoomableImageController,
          hash: imageType != ImageType.Logo ? item.imageBlurHashes?.getBlurHashValueFromImageType(imageType) : null,
          width: width,
          height: height,
          showOverlay: showOverlay,
          notFoundPlaceholder: notFoundPlaceholder,
          backup: backup,
          borderRadius: borderRadius,
          showParent: showParent,
          boxFit: boxFit,
          imageType: imageType,
          imageTag: tag),
      child: const AsyncImageView(),
    );
  }
}

class AsyncImageView extends StatelessWidget {
  const AsyncImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AsyncImageCubit, AsyncImageState>(
      builder: (_, state) {
        switch (state.status) {
          case AsyncImageStatus.initial:
          case AsyncImageStatus.loading:
          case AsyncImageStatus.failure:
            return const AsyncImagePlaceholder();
          case AsyncImageStatus.success:
            return const AsyncImageLoaded();
          default:
            return const AsyncImagePlaceholder();
        }
      },
    );
  }
}

class AsyncImageLoaded extends StatelessWidget {
  const AsyncImageLoaded({super.key});

  @override
  Widget build(BuildContext context) {
    final asyncImageCubit = context.read<AsyncImageCubit>();
    return ClipRRect(
        borderRadius: asyncImageCubit.state.borderRadius,
        child: OctoImage(
            image: asyncImageCubit.state.image!,
            placeholderBuilder: (_) => const AsyncImagePlaceholder(),
            errorBuilder: (_, __, ___) => asyncImageCubit.state.notFoundPlaceholder ?? const AsyncImagePlaceholder(),
            imageBuilder: (_, image) => ZoomableImage(
                zoomableImageController: asyncImageCubit.state.zoomableImageController,
                imageWidget: image,
                overlay: asyncImageCubit.state.showOverlay ? Colors.black.withAlpha(100) : null),
            fadeInDuration: Duration(milliseconds: 100),
            fit: asyncImageCubit.state.boxFit,
            width: asyncImageCubit.state.width,
            height: asyncImageCubit.state.height));
  }
}

class AsyncImagePlaceholder extends StatelessWidget {
  const AsyncImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final asyncImageCubit = context.read<AsyncImageCubit>();
    if (asyncImageCubit.state.hash != null) {
      return OctoPlaceholder.blurHash(asyncImageCubit.state.hash!).call(context);
    }
    return const SizedBox();
  }
}
