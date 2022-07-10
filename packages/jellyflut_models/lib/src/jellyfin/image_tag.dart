import '../enum/index.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_tag.freezed.dart';
part 'image_tag.g.dart';

@Freezed()
class ImageTag with _$ImageTag {
  factory ImageTag({required ImageType imageType, required String value}) = _ImageTag;

  factory ImageTag.fromJson(Map<String, Object?> json) => _$ImageTagFromJson(json);
}
