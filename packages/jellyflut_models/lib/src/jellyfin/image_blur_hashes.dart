import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

part 'image_blur_hashes.freezed.dart';
part 'image_blur_hashes.g.dart';

@Freezed()
class ImageBlurHashes with _$ImageBlurHashes {
  const ImageBlurHashes._();

  factory ImageBlurHashes(
      {Map<String, String>? primary,
      Map<String, String>? art,
      Map<String, String>? backdrop,
      Map<String, String>? banner,
      Map<String, String>? logo,
      Map<String, String>? thumb,
      Map<String, String>? disc,
      Map<String, String>? box,
      Map<String, String>? screenshot,
      Map<String, String>? menu,
      Map<String, String>? chapter,
      Map<String, String>? boxrear,
      Map<String, String>? profile}) = _ImageBlurHashes;

  factory ImageBlurHashes.fromJson(Map<String, Object?> json) => _$ImageBlurHashesFromJson(json);

  String? getBlurHashValueFromImageType(ImageType imageType) {
    final map = getBlurHashFromImageType(imageType);
    if (map == null || map.isEmpty) return null;
    return map.values.first;
  }

  Map<String, String>? getBlurHashFromImageType(ImageType imageType) {
    switch (imageType) {
      case ImageType.Primary:
        return primary;
      case ImageType.Art:
        return art;
      case ImageType.Backdrop:
        return backdrop;
      case ImageType.Banner:
        return banner;
      case ImageType.Logo:
        return logo;
      case ImageType.Thumb:
        return thumb;
      case ImageType.Disc:
        return disc;
      case ImageType.Box:
        return box;
      case ImageType.Screenshot:
        return screenshot;
      case ImageType.Menu:
        return menu;
      case ImageType.Chapter:
        return chapter;
      case ImageType.Profile:
        return profile;
      default:
    }
    return null;
  }
}
