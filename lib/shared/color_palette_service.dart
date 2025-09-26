import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:items_repository/items_repository.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'dart:ui' as ui;

// NOTE: Le code de _computePalette, _extractColorsFromImageProvider, etc.
// a été déplacé ici depuis votre BLoC.

class ColorPaletteService {
  final SharedPreferences _prefs;
  final String _imageUrl;

  // Un cache en mémoire pour la session en cours pour éviter de lire les SharedPreferences à chaque fois.
  final Map<String, List<Color>> _inMemoryCache = {};

  ColorPaletteService({required SharedPreferences sharedPreferences, required String imageUrl})
    : _prefs = sharedPreferences,
      _imageUrl = imageUrl;

  String _cacheKey(String itemId) => 'colors-$itemId';

  Future<List<Color>> getPalette(Item item) async {
    final key = _cacheKey(item.id);

    // 1. Vérifier le cache en mémoire
    if (_inMemoryCache.containsKey(key)) {
      return _inMemoryCache[key]!;
    }

    // 2. Vérifier le cache persistant (SharedPreferences)
    if (_prefs.containsKey(key)) {
      final colors = _getCachedPalette(key);
      _inMemoryCache[key] = colors; // Mettre en cache en mémoire
      return colors;
    }

    // 3. Si non trouvé, générer, mettre en cache et retourner
    return _generateAndCachePalette(item);
  }

  List<Color> _getCachedPalette(String key) {
    final colorsAsString = _prefs.getStringList(key)!;
    return colorsAsString.map((c) => Color(int.parse(c))).toList();
  }

  Future<void> _cachePalette(String key, List<Color> colors) async {
    _inMemoryCache[key] = colors;
    final colorsAsInt = colors.map((c) => c.value.toString()).toList();
    await _prefs.setStringList(key, colorsAsInt);
  }

  Future<List<Color>> _generateAndCachePalette(Item item) async {
    try {
      final byteData = await NetworkAssetBundle(Uri.parse(_imageUrl)).load(_imageUrl);
      final colors = await _computePalette(byteData);
      if (colors.isNotEmpty) {
        await _cachePalette(_cacheKey(item.id), colors);
      }
      return colors;
    } catch (e) {
      debugPrint('Error generating palette: $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
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
