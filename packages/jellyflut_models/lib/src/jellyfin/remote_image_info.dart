import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/index.dart';

part 'remote_image_info.freezed.dart';
part 'remote_image_info.g.dart';

@Freezed()
class RemoteImageInfo with _$RemoteImageInfo {
  RemoteImageInfo._();

  factory RemoteImageInfo(
      {String? providerName,
      String? url,
      String? thumbnailUrl,
      int? height,
      int? width,
      double? communityRating,
      int? voteCount,
      String? language,
      required ImageType type,
      required RatingType ratingType}) = _RemoteImageInfo;

  factory RemoteImageInfo.fromJson(Map<String, Object?> json) => _$RemoteImageInfoFromJson(json);
}
