import 'dart:typed_data';
import 'package:image/image.dart' as image_lib;

import 'package:flutter/painting.dart';

class ColorUtil {
  /// darken gibvn color
  /// ranges from 0.0 to 1.0
  static Color darken(Color color, [double amount = .05]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// lighten given color
  /// ranges from 0.0 to 1.0
  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Color invert(Color color) {
    final r = 255 - color.red;
    final g = 255 - color.green;
    final b = 255 - color.blue;

    return Color.fromARGB((color.opacity * 255).round(), r, g, b);
  }

  static Color changeColorHue(Color color, double hue) =>
      HSLColor.fromColor(color).withHue(hue).toColor();

  static Color changeColorSaturation(Color color, double saturation) =>
      HSLColor.fromColor(color).withSaturation(saturation).toColor();

  static Color changeColorLightness(Color color, double lightness) =>
      HSLColor.fromColor(color).withLightness(lightness).toColor();

  static List<Color> sortColors(List<Color> colors) {
    final sorted = <Color>[];

    sorted.addAll(colors);
    sorted.sort((a, b) => b.computeLuminance().compareTo(a.computeLuminance()));

    return sorted;
  }

  static List<Color> extractPixelsColors(Uint8List bytes,
      {int noOfPixelsPerAxis = 2}) {
    final colors = <Color>[];

    final List<int> values = bytes.buffer.asUint8List();
    final image = image_lib.decodeImage(values);

    if (image == null) return <Color>[];

    final pixels = <int>[];

    final width = image.width;
    final height = image.height;

    final xChunk = width ~/ (noOfPixelsPerAxis + 1);
    final yChunk = height ~/ (noOfPixelsPerAxis + 1);

    for (var j = 1; j < noOfPixelsPerAxis + 1; j++) {
      for (var i = 1; i < noOfPixelsPerAxis + 1; i++) {
        final pixel = image.getPixel(xChunk * i, yChunk * j);
        pixels.add(pixel);
        colors.add(abgrToColor(pixel));
      }
    }

    return colors;
  }

  static Color abgrToColor(int argbColor) {
    final r = (argbColor >> 16) & 0xFF;
    final b = argbColor & 0xFF;
    final hex = (argbColor & 0xFF00FF00) | (b << 16) | r;
    return Color(hex);
  }

  static Color getAverageColor(List<Color> colors) {
    var r = 0, g = 0, b = 0;

    for (var i = 0; i < colors.length; i++) {
      r += colors[i].red;
      g += colors[i].green;
      b += colors[i].blue;
    }

    r = r ~/ colors.length;
    g = g ~/ colors.length;
    b = b ~/ colors.length;

    return Color.fromRGBO(r, g, b, 1);
  }
}
