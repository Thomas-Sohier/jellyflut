import 'package:jellyflut_models/jellyflut_models.dart';

class ImageUtil {
  static ImageType fallbackImageType(List<ImageTag> imageTags, ImageType tag) {
    return imageTags
        .map((ImageTag iTag) => iTag.imageType)
        .firstWhere((ImageType imageType) => imageType == tag, orElse: () => ImageType.Primary);
  }
}
