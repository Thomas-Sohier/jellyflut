import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:blurhash_dart/blurhash_extensions.dart';
import 'package:flutter/painting.dart';
// import 'package:palette_generator/palette_generator.dart';

class Palette {
  static Color generatePalettefromBlurhash(String hash) {
    final blurHash = BlurHash.decode(hash);
    final rgb = blurHash.averageLinearRgb.toRgb();
    return Color.fromRGBO(rgb.r.toInt(), rgb.g.toInt(), rgb.b.toInt(), 1);
  }
}
