import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/shared/blurhash_service.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
part 'async_image_state.dart';

class AsyncImageCubit extends Cubit<AsyncImageState> {
  AsyncImageCubit({
    required ItemsRepository itemsRepository,
    required String itemId,
    required ImageType imageType,
    double? width,
    double? height,
    String? tag,
    String? hash,
  }) : _itemsRepository = itemsRepository,
       _blurhashService = BlurHashService(),
       _itemId = itemId,
       _imageType = imageType,
       _width = width,
       _height = height,
       _tag = tag,
       _hash = hash,
       super(const AsyncImageState());

  final ItemsRepository _itemsRepository;
  final BlurHashService _blurhashService;
  final String _itemId;
  final ImageType _imageType;
  final double? _width;
  final double? _height;
  final String? _tag;
  final String? _hash;

  Future<void> loadImage() async {
    await Future.wait([_loadPlaceholder(), _loadImage()]);
  }

  Future<void> _loadPlaceholder() async {
    if (_hash == null) return;
    final placeholder = await _blurhashService.decode(_hash);
    if (isClosed) return;
    if (placeholder != null) {
      emit(state.copyWith(placeholderImage: placeholder));
    }
  }

  Future<void> _loadImage() async {
    emit(state.copyWith(status: AsyncImageStatus.loading));
    try {
      final url = _itemsRepository.getItemImageUrl(
        itemId: _itemId,
        type: _imageType,
        tag: _tag,
        maxWidth: _width?.toInt(),
        maxHeight: _height?.toInt(),
      );
      final provider = CachedNetworkImageProvider(url);
      if (isClosed) return;
      emit(state.copyWith(status: AsyncImageStatus.success, imageProvider: provider));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: AsyncImageStatus.failure));
    }
  }
}
