import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/jellyfin/imageBlurHashes.dart';

class ItemImageService {
  static String getItemImageUrl(String itemId, String? imageTag,
      {ImageBlurHashes? imageBlurHashes,
      int maxHeight = 1920,
      int maxWidth = 1080,
      String type = 'Primary',
      int quality = 60}) {
    var finalType = type;
    if (imageBlurHashes != null) {
      finalType = _fallBackImg(imageBlurHashes, type);
    }
    if (type == 'Logo') {
      return '${server.url}/Items/$itemId/Images/$finalType?quality=$quality&tag=$imageTag';
    } else if (type == 'Backdrop') {
      return '${server.url}/Items/$itemId/Images/$finalType?maxWidth=800&tag=$imageTag&quality=$quality';
    } else {
      return '${server.url}/Items/$itemId/Images/$finalType?maxHeight=$maxHeight&maxWidth=$maxWidth&tag=$imageTag&quality=$quality';
    }
  }

  static String _fallBackImg(ImageBlurHashes imageBlurHashes, String tag) {
    var hash = 'hash';
    if (tag == 'Primary') {
      hash = _fallBackPrimary(imageBlurHashes);
    } else if (tag == 'Backdrop') {
      hash = _fallBackBackdrop(imageBlurHashes);
    } else if (tag == 'Logo') {
      hash = tag;
    }
    return hash;
  }

  static String _fallBackPrimary(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.primary != null) {
      return 'Primary';
    } else if (imageBlurHashes.thumb != null) {
      return 'Thumb';
    } else if (imageBlurHashes.backdrop != null) {
      return 'Backdrop';
    } else if (imageBlurHashes.art != null) {
      return 'Art';
    } else {
      return 'Primary';
    }
  }

  static String _fallBackBackdrop(ImageBlurHashes imageBlurHashes) {
    if (imageBlurHashes.backdrop != null)
      // ignore: curly_braces_in_flow_control_structures
      return 'Backdrop';
    else if (imageBlurHashes.thumb != null) {
      return 'Thumb';
    } else if (imageBlurHashes.art != null) {
      return 'Art';
    } else if (imageBlurHashes.primary != null) {
      return 'Primary';
    } else {
      return 'Primary';
    }
  }
}
