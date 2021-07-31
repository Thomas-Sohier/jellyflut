import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

Future<PaletteGenerator> gePalette(String url) async {
  return PaletteGenerator.fromImageProvider(
    NetworkImage(url),
    maximumColorCount: 20,
  ).onError((error, stackTrace) {
    log(error.toString(), stackTrace: stackTrace);
    throw (error.toString());
  });
}
