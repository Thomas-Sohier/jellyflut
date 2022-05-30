import 'package:jellyflut/models/enum/image_type.dart';

class ImageTag {
  final ImageType imageType;
  final String value;

  const ImageTag({required this.imageType, required this.value});

  static List<ImageTag> fromMap(Map<String, dynamic> json) {
    final imageTags = <ImageTag>[];
    json.forEach((key, value) => imageTags
        .add(ImageTag(imageType: ImageType.fromString(key), value: value)));
    return imageTags;
  }

  Map<String, dynamic> toMap() =>
      {'ImageType': imageType.value, 'value': value};
}
