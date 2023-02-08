import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;

abstract class ColorUtil {
  static Map<int, Color> generateColorSwatch(Color color) => <int, Color>{
        50: ColorUtil.lighten(color, 0.45),
        100: ColorUtil.lighten(color, 0.4),
        200: ColorUtil.lighten(color, 0.3),
        300: ColorUtil.lighten(color, 0.2),
        400: ColorUtil.lighten(color, 0.1),
        500: color,
        600: ColorUtil.darken(color, 0.1),
        700: ColorUtil.darken(color, 0.2),
        800: ColorUtil.darken(color, 0.3),
        900: ColorUtil.darken(color, 0.4)
      };

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
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Color invert(Color color) {
    final r = 255 - color.red;
    final g = 255 - color.green;
    final b = 255 - color.blue;

    return Color.fromARGB((color.opacity * 255).round(), r, g, b);
  }

  static Color changeColorHue(Color color, double hue) => HSLColor.fromColor(color).withHue(hue).toColor();

  static Color changeColorSaturation(Color color, double saturation) =>
      HSLColor.fromColor(color).withSaturation(saturation).toColor();

  static Color changeColorLightness(Color color, double lightness) =>
      HSLColor.fromColor(color).withLightness(lightness).toColor();

  static Color applyColorSaturation(Color color, double saturation) {
    final hslColor = HSLColor.fromColor(color);
    final tempSaturation = hslColor.saturation + saturation;
    final s = tempSaturation < 0 || tempSaturation > 1 ? hslColor.saturation : tempSaturation;
    return hslColor.withSaturation(s).toColor();
  }

  static Color applyColorLightness(Color color, double lightness) {
    final hslColor = HSLColor.fromColor(color);
    final tempLightness = hslColor.lightness + lightness;
    final l = tempLightness < 0 || tempLightness > 1 ? hslColor.lightness : tempLightness;
    return hslColor.withLightness(l).toColor();
  }

  static List<Color> sortColors(List<Color> colors) {
    final sorted = <Color>[];

    sorted.addAll(colors);
    sorted.sort((a, b) => a.computeLuminance().compareTo(b.computeLuminance()));
    sorted.removeWhere((c) => c.computeLuminance() < 0.05 || c.computeLuminance() > 0.95);

    return sorted;
  }

  static List<Color> extractPixelsColors(Uint8List bytes, {int noOfPixelsPerAxis = 2}) {
    final colors = <Color>[];

    final values = bytes.buffer.asUint8List();
    final image = image_lib.decodeImage(values);

    if (image == null) return <Color>[];

    final width = image.width;
    final height = image.height;

    final xChunk = width ~/ (noOfPixelsPerAxis + 1);
    final yChunk = height ~/ (noOfPixelsPerAxis + 1);

    for (var j = 1; j < noOfPixelsPerAxis + 1; j++) {
      for (var i = 1; i < noOfPixelsPerAxis + 1; i++) {
        final pixel = image.getPixel(xChunk * i, yChunk * j);
        colors.add(Color.fromARGB(pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
      }
    }

    return colors;
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

  static MaterialColor colorToMaterialColor(Color color) {
    final swatch = generateColorSwatch(color);
    return MaterialColor(color.value, swatch);
  }
}
