import 'dart:ui' as ui;

import 'package:blurhash_ffi/blurhash.dart';

class BlurHashService {
  final _cache = <String, ui.Image>{};

  Future<ui.Image?> decode(String? hash) async {
    if (hash == null || hash.isEmpty) {
      return null;
    }
    if (_cache.containsKey(hash)) {
      return _cache[hash];
    }

    try {
      final image = await BlurhashFFI.decode(hash, width: 16, height: 16);
      _cache[hash] = image;
      return image;
    } catch (e) {
      return null;
    }
  }
}
