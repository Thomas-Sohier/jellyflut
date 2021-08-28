import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/itemType.dart';
import 'package:jellyflut/shared/theme.dart';

Widget gradientMask({required Widget child, double radius = 0.5}) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return RadialGradient(
        center: Alignment.topLeft,
        radius: radius,
        colors: <Color>[jellyLightBLue, jellyLightPurple],
        tileMode: TileMode.mirror,
      ).createShader(bounds);
    },
    child: child,
  );
}

double aspectRatio({ItemType? type}) {
  if (type == ItemType.MUSICALBUM || type == ItemType.AUDIO) {
    return 1 / 1;
  } else if (type == ItemType.PHOTO) {
    return 4 / 3;
  } else if (type == ItemType.BOOK) {
    return 2 / 3;
  }
  return 2 / 3;
}

String printDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

String removeAllHtmlTags(String htmlText) {
  var exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

  return htmlText.replaceAll(exp, '');
}

String getEnumValue(String enumValue) {
  return enumValue.substring(enumValue.toString().indexOf('.') + 1);
}
