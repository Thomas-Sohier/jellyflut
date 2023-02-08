part of 'async_image_cubit.dart';

enum AsyncImageStatus { initial, loading, success, failure }

class AsyncImageState extends Equatable {
  AsyncImageState(
      {required this.itemId,
      this.image,
      this.zoomableImageController,
      this.status = AsyncImageStatus.initial,
      this.hash,
      this.imageTag,
      this.width,
      this.notFoundPlaceholder,
      this.height,
      required this.borderRadius,
      required this.boxFit,
      required this.showOverlay,
      required this.backup,
      required this.showParent,
      required this.imageType});

  final AsyncImageStatus status;
  final ZoomableImageController? zoomableImageController;
  final ImageProvider<Object>? image;
  final String itemId;
  final String? hash;
  final String? imageTag;
  final ImageType imageType;
  final Widget? notFoundPlaceholder;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final bool showOverlay;
  final bool backup;
  final bool showParent;
  final BoxFit boxFit;

  AsyncImageState copyWith(
      {AsyncImageStatus? status,
      ZoomableImageController? zoomableImageController,
      Widget? notFoundPlaceholder,
      String? itemId,
      String? hash,
      String? imageTag,
      ImageType? imageType,
      double? width,
      double? height,
      ImageProvider<Object>? image,
      BorderRadius? borderRadius,
      bool? showOverlay,
      bool? backup,
      bool? showParent,
      BoxFit? boxFit}) {
    return AsyncImageState(
        status: status ?? this.status,
        itemId: itemId ?? this.itemId,
        zoomableImageController: zoomableImageController ?? this.zoomableImageController,
        notFoundPlaceholder: notFoundPlaceholder ?? this.notFoundPlaceholder,
        hash: hash ?? this.hash,
        image: image ?? this.image,
        imageTag: imageTag ?? this.imageTag,
        borderRadius: borderRadius ?? this.borderRadius,
        imageType: imageType ?? this.imageType,
        width: width ?? this.width,
        height: height ?? this.height,
        showOverlay: showOverlay ?? this.showOverlay,
        backup: backup ?? this.backup,
        showParent: showParent ?? this.showParent,
        boxFit: boxFit ?? this.boxFit);
  }

  @override
  List<Object?> get props => [
        status,
        itemId,
        hash,
        zoomableImageController,
        imageTag,
        imageTag,
        width,
        notFoundPlaceholder,
        borderRadius,
        height,
        showOverlay,
        backup,
        showParent,
        boxFit
      ];
}
