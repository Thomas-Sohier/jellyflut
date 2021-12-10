import 'package:flutter/painting.dart';

class ColorUtil {
  /// darken gibvn color
  /// ranges from 0.0 to 1.0
  static Color darken(Color color, [double amount = .1]) {
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
}
