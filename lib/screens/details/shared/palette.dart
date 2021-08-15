import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/shared/colors.dart';
import 'package:palette_generator/palette_generator.dart';

class Palette {
  static Future<PaletteGenerator> getPalette(
      Item item, String searchType) async {
    final url = getItemImageUrl(item.correctImageId(searchType: searchType),
        item.correctImageTags(searchType: searchType),
        imageBlurHashes: item.imageBlurHashes, type: searchType);
    return gePalette(url);
  }
}
