import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/image_tag.dart';

class ImageUtil {
  static ImageType fallbackImageType(List<ImageTag> imageTags, ImageType tag) {
    return imageTags.map((ImageTag iTag) => iTag.imageType).firstWhere(
        (ImageType imageType) => imageType == tag,
        orElse: () => ImageType.PRIMARY);
  }
}
