import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_blur_hashes.freezed.dart';
part 'image_blur_hashes.g.dart';

@Freezed()
class ImageBlurHashes with _$ImageBlurHashes {
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
}
