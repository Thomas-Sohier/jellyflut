import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/components/async_item_image/cubit/async_image_cubit.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

// Le type de builder reste le même.
typedef AsyncImageBuilder = Widget Function(BuildContext context, ImageProvider imageProvider, ImageInfo imageInfo);

class AsyncImageProvider extends StatelessWidget {
  // L'item Jellyfin pour lequel charger l'image.
  final Item item;

  // Le builder qui sera appelé lorsque l'image et ses dimensions seront prêtes.
  // C'est ici que vous construirez le widget final (ex: votre ItemPoster).
  final AsyncImageBuilder builder;

  // Le type d'image à charger (Primary; Backdrop; Logo...).
  // Par défaut : ImageType.Primary
  final ImageType imageType;

  // Indique s'il faut utiliser l'ID du parent (série; album) pour trouver l'image.
  // Par défaut : false
  final bool showParent;

  // La largeur souhaitée pour l'image. Passée à l'API pour optimiser la taille du fichier.
  final double? width;

  // La hauteur souhaitée pour l'image. Passée à l'API pour optimiser la taille du fichier.
  final double? height;

  // Un builder optionnel pour afficher un widget pendant le chargement.
  final WidgetBuilder? placeholder;

  // Un builder optionnel pour afficher un widget en cas d'erreur de chargement.
  final WidgetBuilder? error;

  const AsyncImageProvider({
    super.key,
    required this.item,
    required this.builder,
    this.imageType = ImageType.Primary,
    this.showParent = false,
    this.width,
    this.height,
    this.placeholder,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsyncImageCubit(
        itemsRepository: context.read<ItemsRepository>(),
        itemId: showParent ? item.seriesId ?? item.id : item.id,
        imageType: imageType,
        tag: item.id,
      )..loadImage(),
      child: BlocBuilder<AsyncImageCubit, AsyncImageState>(
        builder: (context, state) {
          switch (state.status) {
            case AsyncImageStatus.success:
              if (state.imageProvider != null) {
                return _ImageInfoResolver(
                  imageProvider: state.imageProvider!,
                  builder: builder,
                  placeholder: placeholder,
                );
              }
              return error?.call(context) ?? const SizedBox();
            case AsyncImageStatus.loading:
            case AsyncImageStatus.initial:
              return placeholder?.call(context) ?? const SizedBox();
            case AsyncImageStatus.failure:
              return error?.call(context) ?? const SizedBox();
          }
        },
      ),
    );
  }
}

class _ImageInfoResolver extends StatefulWidget {
  const _ImageInfoResolver({required this.imageProvider, required this.builder, this.placeholder});

  final ImageProvider imageProvider;
  final AsyncImageBuilder builder;
  final WidgetBuilder? placeholder;

  @override
  State<_ImageInfoResolver> createState() => _ImageInfoResolverState();
}

class _ImageInfoResolverState extends State<_ImageInfoResolver> {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  late final ImageStreamListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = ImageStreamListener(
      _handleImageFrame,
      onError: (exception, stackTrace) {
        // Gérer l'erreur de chargement de l'image si nécessaire
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(_ImageInfoResolver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != oldWidget.imageProvider) {
      _resolveImage();
    }
  }

  void _resolveImage() {
    _imageStream?.removeListener(_listener);
    _imageStream = widget.imageProvider.resolve(const ImageConfiguration());
    _imageStream!.addListener(_listener);
  }

  void _handleImageFrame(ImageInfo imageInfo, bool synchronousCall) {
    if (mounted) {
      setState(() {
        _imageInfo = imageInfo;
      });
    }
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageInfo != null) {
      return widget.builder(context, widget.imageProvider, _imageInfo!);
    }

    return widget.placeholder?.call(context) ?? const SizedBox();
  }
}
