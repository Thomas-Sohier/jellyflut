import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:jellyflut/models/jellyfin/imageBlurHashes.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/shared/palette.dart';

class BlurHashUtil {
  static Future<Color> getDominantColor(Item item, String tag) async {
    final hash = BlurHashUtil.fallBackBlurHash(item.imageBlurHashes, tag) ?? '';
    return compute(Palette.generatePalettefromBlurhash, hash);
  }

  static String? fallBackBlurHash(
      ImageBlurHashes? imageBlurHashes, String tag) {
    // TODO add enum
    if (imageBlurHashes == null) {
      return null;
    } else if (tag == 'Primary') {
      return _fallBackBlurHashPrimary(imageBlurHashes);
    } else if (tag == 'Logo') {
      return _fallBackBlurHashLogo(imageBlurHashes);
    } else if (tag == 'Backdrop') {
      return imageBlurHashes.backdrop?.values.first;
    } else if (tag == 'Thumb') {
      return imageBlurHashes.thumb?.values.first;
    } else if (tag == 'Art') {
      return imageBlurHashes.art?.values.first;
    } else if (tag == 'Banner') {
      return imageBlurHashes.banner?.values.first;
    }
    return null;
  }

  static String? _fallBackBlurHashPrimary(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.primary != null &&
        imageBlurHashes.primary!.values.isNotEmpty) {
      return imageBlurHashes.primary!.values.first;
    } else if (imageBlurHashes.backdrop != null &&
        imageBlurHashes.backdrop!.values.isNotEmpty) {
      return imageBlurHashes.backdrop!.values.first;
    } else if (imageBlurHashes.art != null &&
        imageBlurHashes.art!.values.isNotEmpty) {
      return imageBlurHashes.art!.values.first;
    } else if (imageBlurHashes.thumb != null &&
        imageBlurHashes.thumb!.values.isNotEmpty) {
      return imageBlurHashes.thumb!.values.first;
    }
    return null;
  }

  static String? _fallBackBlurHashLogo(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.logo != null) {
      return imageBlurHashes.logo!.values.first;
    }
    return null;
  }
}
