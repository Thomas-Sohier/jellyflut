import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:downloads_repository/downloads_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/providers/theme/theme_provider.dart';
import 'package:jellyflut/theme/theme.dart' as t;
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ItemsRepository _itemsRepository;
  final AuthenticationRepository _authenticationRepository;
  final DownloadsRepository _downloadsRepository;
  final SharedPreferences _sharedPreferences;
  final ThemeProvider _themeProvider;

  DetailsBloc({
    required Item item,
    required ItemsRepository itemsRepository,
    required AuthenticationRepository authenticationRepository,
    required DownloadsRepository downloadsRepository,
    required ThemeProvider themeProvider,
    required SharedPreferences sharedPreferences,
    bool contrastedPage = false,
    String? heroTag,
    ScreenLayout screenLayout = ScreenLayout.desktop,
  }) : _itemsRepository = itemsRepository,
       _authenticationRepository = authenticationRepository,
       _downloadsRepository = downloadsRepository,
       _sharedPreferences = sharedPreferences,
       _themeProvider = themeProvider,
       super(
         DetailsState(
           item: item,
           contrastedPage: contrastedPage,
           theme: themeProvider.getThemeData,
           heroTag: heroTag,
           screenLayout: screenLayout,
         ),
       ) {
    on<DetailsInitRequested>(_onDetailsInitRequested);
    on<DetailsItemUpdate>(_onItemUpdate);
    on<PinnedHeaderChangeRequested>(_shrinkOffsetChanged);
    on<DetailsScreenSizeChanged>(_onScreenLayoutChanged);
    on<DetailsUpdateSeedColor>(_onSeedColorUpdate);
  }

  /// Helper cache method
  /// generate cache colorkey from item and current user
  String spKey(String id) => 'colors-$id-$currentUserId';

  String get currentUserId => _authenticationRepository.currentUser.id;

  void _onDetailsInitRequested(DetailsInitRequested event, Emitter<DetailsState> emit) async {
    emit(state.copyWith(item: event.item, detailsStatus: DetailsStatus.loading));
    unawaited(_getItemBackgroundColor(event.item));
    final item = await _downloadsRepository.getItemFromStorage(itemId: event.item.id);
    if (item.isNotEmpty || offlineMode) {
      if (item.isEmpty) {
        return emit(state.copyWith(item: item, detailsStatus: DetailsStatus.failure));
      }
      return emit(state.copyWith(item: item, detailsStatus: DetailsStatus.success));
    } else {
      final item = await _itemsRepository.getItem(event.item.id);
      return emit(state.copyWith(item: item, detailsStatus: DetailsStatus.success));
    }
  }

  void _onItemUpdate(DetailsItemUpdate event, Emitter<DetailsState> emit) {
    emit(state.copyWith(item: event.item, detailsStatus: DetailsStatus.success));
  }

  void _onScreenLayoutChanged(DetailsScreenSizeChanged event, Emitter<DetailsState> emit) {
    if (event.screenLayout == state.screenLayout) return;
    if (event.screenLayout == ScreenLayout.desktop) {
      emit(state.copyWith(pinnedHeader: false, screenLayout: event.screenLayout));
    } else {
      emit(state.copyWith(screenLayout: event.screenLayout));
    }
  }

  /// Update the theme of current details
  void _onSeedColorUpdate(DetailsUpdateSeedColor event, Emitter<DetailsState> emit) {
    final detailsTheme = t.Theme.generateDetailsThemeDataFromPaletteColor(
      event.colors,
      state.contrastedPage,
      _themeProvider.getThemeData.brightness,
    );
    emit(state.copyWith(theme: detailsTheme));
  }

  void _shrinkOffsetChanged(PinnedHeaderChangeRequested event, Emitter<DetailsState> emit) {
    if (event.shrinkOffset > 0) {
      emit(state.copyWith(pinnedHeader: true));
    } else {
      emit(state.copyWith(pinnedHeader: false));
    }
  }

  Future<bool> cacheSeedColor(final List<Color> colors) async {
    final item = state.item;
    final colorsAsInt = colors.map((c) => c.toARGB32().toString());
    return _sharedPreferences.setStringList(spKey(item.id), colorsAsInt.toList());
  }

  bool isSeedColorCached() {
    final item = state.item;
    return _sharedPreferences.containsKey(spKey(item.id));
  }

  List<Color> getCachedSeedColor() {
    final item = state.item;
    final colorsAsString = _sharedPreferences.getStringList(spKey(item.id))!;
    return colorsAsString.map((c) => Color(int.parse(c))).toList();
  }

  Future<void> _getItemBackgroundColor(final Item item, {final bool cache = true}) async {
    // get seed color from sharedPref to prevent computation on remote image
    // to load faster and prevent future API call
    if (cache && isSeedColorCached()) {
      return add(DetailsUpdateSeedColor(colors: getCachedSeedColor()));
    }

    final url = _itemsRepository.getItemImageUrl(
      itemId: item.id,
      tag: item.correctImageTags(searchType: ImageType.Primary),
      type: item.correctImageType(searchType: ImageType.Primary),
      quality: 40,
    );

    return NetworkAssetBundle(Uri.parse(url)).load(url).then(_computePalette).then((colors) async {
      // save binary in sharedpref to load faster and prevent future API call
      if (cache) {
        await cacheSeedColor(colors);
        add(DetailsUpdateSeedColor(colors: colors));
      }
    });
  }

  /// Method that use an image ByteData to generate a color palette from most used
  /// colors
  Future<List<Color>> _computePalette(ByteData byteData) async {
    try {
      // Extract dominant colors from image.
      final quantizerResult = await _extractColorsFromImageProvider(
        ResizeImage(Image.memory(byteData.buffer.asUint8List()).image, height: 240, width: 240),
      );
      final colorToCount = quantizerResult.colorToCount.map(
        (key, value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
      );

      // Score colors for color scheme suitability.
      final filteredResults = Score.score(colorToCount, desired: 1, filter: true);
      final scoredResults = Score.score(colorToCount, desired: 4, filter: false);
      return <dynamic>{...filteredResults, ...scoredResults}.toList().map((argb) => Color(argb)).toList();
    } catch (e) {
      debugPrint('Error getting colors from image: $e');
      return [];
    }
  }

  // ColorScheme.fromImageProvider() utilities.

  // Extracts bytes from an [ImageProvider] and returns a [QuantizerResult]
  // containing the most dominant colors.
  Future<QuantizerResult> _extractColorsFromImageProvider(ImageProvider imageProvider) async {
    final scaledImage = await _imageProviderToScaled(imageProvider);
    final imageBytes = await scaledImage.toByteData();

    final quantizerResult = await QuantizerCelebi().quantize(
      imageBytes!.buffer.asUint32List(),
      128,
      returnInputPixelToClusterPixel: true,
    );
    return quantizerResult;
  }

  // Scale image size down to reduce computation time of color extraction.
  Future<ui.Image> _imageProviderToScaled(ImageProvider imageProvider) async {
    const maxDimension = 112.0;
    final stream = imageProvider.resolve(const ImageConfiguration(size: Size(maxDimension, maxDimension)));
    final imageCompleter = Completer<ui.Image>();
    late ImageStreamListener listener;
    late ui.Image scaledImage;
    Timer? loadFailureTimeout;

    listener = ImageStreamListener(
      (ImageInfo info, bool sync) async {
        loadFailureTimeout?.cancel();
        stream.removeListener(listener);
        final image = info.image;
        final width = image.width;
        final height = image.height;
        var paintWidth = width.toDouble();
        var paintHeight = height.toDouble();
        assert(width > 0 && height > 0);

        final rescale = width > maxDimension || height > maxDimension;
        if (rescale) {
          paintWidth = (width > height) ? maxDimension : (maxDimension / height) * width;
          paintHeight = (height > width) ? maxDimension : (maxDimension / width) * height;
        }
        final pictureRecorder = ui.PictureRecorder();
        final canvas = Canvas(pictureRecorder);
        paintImage(
          canvas: canvas,
          rect: Rect.fromLTRB(0, 0, paintWidth, paintHeight),
          image: image,
          filterQuality: FilterQuality.none,
        );

        final picture = pictureRecorder.endRecording();
        scaledImage = await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
        imageCompleter.complete(info.image);
      },
      onError: (Object exception, StackTrace? stackTrace) {
        stream.removeListener(listener);
        throw Exception('Failed to render image: $exception');
      },
    );

    loadFailureTimeout = Timer(const Duration(seconds: 5), () {
      stream.removeListener(listener);
      imageCompleter.completeError(TimeoutException('Timeout occurred trying to load image'));
    });

    stream.addListener(listener);
    await imageCompleter.future;
    return scaledImage;
  }

  // Converts AABBGGRR color int to AARRGGBB format.
  int _getArgbFromAbgr(int abgr) {
    const exceptRMask = 0xFF00FFFF;
    const onlyRMask = ~exceptRMask;
    const exceptBMask = 0xFFFFFF00;
    const onlyBMask = ~exceptBMask;
    final r = (abgr & onlyRMask) >> 16;
    final b = abgr & onlyBMask;
    return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
  }
}
