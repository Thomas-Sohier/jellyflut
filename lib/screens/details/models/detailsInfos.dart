import 'package:jellyflut/models/item.dart';
import 'package:palette_generator/palette_generator.dart';

class DetailsInfos {
  final Future<PaletteGenerator> paletteColors;
  final Future<Item> item;

  const DetailsInfos({required this.paletteColors, required this.item});
}
