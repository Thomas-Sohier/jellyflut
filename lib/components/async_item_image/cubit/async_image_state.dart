part of 'async_image_cubit.dart';

enum AsyncImageStatus { initial, loading, success, failure }

class AsyncImageState extends Equatable {
  const AsyncImageState({
    this.status = AsyncImageStatus.initial,
    this.imageProvider,
    this.placeholderImage, // Ajout de la propriété
  });

  final AsyncImageStatus status;
  final ImageProvider? imageProvider;
  final ui.Image? placeholderImage; // ui.Image pour RawImage

  @override
  List<Object?> get props => [status, imageProvider, placeholderImage];

  AsyncImageState copyWith({AsyncImageStatus? status, ImageProvider? imageProvider, ui.Image? placeholderImage}) {
    return AsyncImageState(
      status: status ?? this.status,
      imageProvider: imageProvider ?? this.imageProvider,
      placeholderImage: placeholderImage ?? this.placeholderImage,
    );
  }
}
