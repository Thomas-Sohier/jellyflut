import 'package:jellyflut/globals.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ItemImageService {
  static String getItemImageUrl(String itemId, String? imageTag,
      {int maxHeight = 1920,
      int maxWidth = 1080,
      ImageType type = ImageType.PRIMARY,
      int quality = 60}) {
    var finalType = type.value;

    // we only fallback search type image if we have imageTags list not empty
    // or if we search a logo
    // if (imageTags != null && type != ImageType.LOGO) {
    //   final fallbackType = ImageUtil.fallbackImageType(imageTags, type);
    //   finalType = fallbackType.value;
    // }

    // Depending on type we use a different url with diffrent parameter
    switch (type) {
      case ImageType.LOGO:
        return '${server.url}/Items/$itemId/Images/$finalType?quality=$quality&tag=$imageTag';
      case ImageType.BACKDROP:
        return '${server.url}/Items/$itemId/Images/$finalType?tag=$imageTag&quality=$quality';
      default:
        return '${server.url}/Items/$itemId/Images/$finalType?maxHeight=$maxHeight&maxWidth=$maxWidth&tag=$imageTag&quality=$quality';
    }
  }
}
