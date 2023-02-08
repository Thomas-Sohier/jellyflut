import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_url.freezed.dart';
part 'media_url.g.dart';

@Freezed()
class MediaUrl with _$MediaUrl {
  factory MediaUrl({String? url, String? name}) = _MediaUrl;

  factory MediaUrl.fromJson(Map<String, Object?> json) => _$MediaUrlFromJson(json);
}
