import 'package:freezed_annotation/freezed_annotation.dart';

import 'remote_image_info.dart';

part 'remote_image.freezed.dart';
part 'remote_image.g.dart';

@Freezed()
class RemoteImage with _$RemoteImage {
  RemoteImage._();

  factory RemoteImage(
      {required List<RemoteImageInfo> images,
      required int totalRecordCount,
      required List<String> providers}) = _RemoteImage;

  factory RemoteImage.fromJson(Map<String, Object?> json) => _$RemoteImageFromJson(json);
}
