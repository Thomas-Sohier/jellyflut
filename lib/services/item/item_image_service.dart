import 'package:jellyflut/globals.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class ItemImageService {
  static String getItemImageUrl(String itemId, String? imageTag,
      {int maxHeight = 1920, int maxWidth = 1080, ImageType type = ImageType.PRIMARY, int quality = 60}) {
    // Depending on type we use a different url with diffrent parameter
    switch (type) {
      case ImageType.LOGO:
        return '${server.url}/Items/$itemId/Images/${type.value}?quality=$quality&tag=$imageTag';
      case ImageType.BACKDROP:
        return '${server.url}/Items/$itemId/Images/${type.value}?tag=$imageTag&quality=$quality';
      default:
        return '${server.url}/Items/$itemId/Images/${type.value}?maxHeight=$maxHeight&maxWidth=$maxWidth&tag=$imageTag&quality=$quality';
    }
  }
}
