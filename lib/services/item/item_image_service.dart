import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/image_blur_hashes.dart';
import 'package:jellyflut/shared/shared.dart';

class ItemImageService {
  static String getItemImageUrl(String itemId, String? imageTag,
      {ImageBlurHashes? imageBlurHashes,
      int maxHeight = 1920,
      int maxWidth = 1080,
      ImageType type = ImageType.PRIMARY,
      int quality = 60}) {
    var finalType = getEnumValue(type.toString());
    if (imageBlurHashes != null) {
      finalType = getEnumValue(_fallBackImg(imageBlurHashes, type).toString());
    }
    if (type == ImageType.LOGO) {
      return '${server.url}/Items/$itemId/Images/$finalType?quality=$quality&tag=$imageTag';
    } else if (type == ImageType.BACKDROP) {
      return '${server.url}/Items/$itemId/Images/$finalType?maxWidth=800&tag=$imageTag&quality=$quality';
    } else {
      return '${server.url}/Items/$itemId/Images/$finalType?maxHeight=$maxHeight&maxWidth=$maxWidth&tag=$imageTag&quality=$quality';
    }
  }

  static ImageType _fallBackImg(
      ImageBlurHashes imageBlurHashes, ImageType tag) {
    if (tag == ImageType.PRIMARY) {
      return _fallBackPrimary(imageBlurHashes);
    } else if (tag == ImageType.BACKDROP) {
      return _fallBackBackdrop(imageBlurHashes);
    }
    return tag;
  }

  static ImageType _fallBackPrimary(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.primary != null) {
      return ImageType.PRIMARY;
    } else if (imageBlurHashes.thumb != null) {
      return ImageType.THUMB;
    } else if (imageBlurHashes.backdrop != null) {
      return ImageType.BACKDROP;
    } else if (imageBlurHashes.art != null) {
      return ImageType.ART;
    } else {
      return ImageType.PRIMARY;
    }
  }

  static ImageType _fallBackBackdrop(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.backdrop != null)
      // ignore: curly_braces_in_flow_control_structures
      return ImageType.BACKDROP;
    else if (imageBlurHashes.thumb != null) {
      return ImageType.THUMB;
    } else if (imageBlurHashes.art != null) {
      return ImageType.ART;
    } else if (imageBlurHashes.primary != null) {
      return ImageType.PRIMARY;
    } else {
      return ImageType.PRIMARY;
    }
  }
}
