import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_url.freezed.dart';
part 'external_url.g.dart';

@Freezed()
class ExternalUrl with _$ExternalUrl {
  factory ExternalUrl({
    String? name,
    String? url,
  }) = _ExternalUrl;
  factory ExternalUrl.fromJson(Map<String, Object?> json) => _$ExternalUrlFromJson(json);
}
