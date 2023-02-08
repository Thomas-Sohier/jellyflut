import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/zoomable_image/zommable_image_controller.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'async_image_state.dart';

class AsyncImageCubit extends Cubit<AsyncImageState> {
  AsyncImageCubit(this._itemsRepository,
      {required String itemId,
      required BorderRadius borderRadius,
      ZoomableImageController? zoomableImageController,
      String? imageTag,
      String? hash,
      ImageType? imageType,
      double? width,
      Widget? notFoundPlaceholder,
      double? height,
      bool? backup,
      bool? showOverlay,
      bool? showParent,
      BoxFit? boxFit})
      : super(AsyncImageState(
            hash: hash,
            imageTag: imageTag,
            zoomableImageController: zoomableImageController,
            imageType: imageType ?? ImageType.Primary,
            notFoundPlaceholder: notFoundPlaceholder,
            borderRadius: borderRadius,
            itemId: itemId,
            width: width,
            height: height,
            backup: backup ?? true,
            showOverlay: showOverlay ?? false,
            showParent: showParent ?? false,
            boxFit: boxFit ?? BoxFit.cover)) {
    _init();
  }

  final ItemsRepository _itemsRepository;

  Future<void> _init() async {
    emit(state.copyWith(status: AsyncImageStatus.loading));

    try {
      final url = _itemsRepository.getItemImageUrl(itemId: state.itemId, tag: state.imageTag, type: state.imageType);
      final image = CachedNetworkImageProvider(url);
      emit(
        state.copyWith(status: AsyncImageStatus.success, image: image),
      );
    } on Exception {
      emit(state.copyWith(status: AsyncImageStatus.failure));
    }
  }
}
