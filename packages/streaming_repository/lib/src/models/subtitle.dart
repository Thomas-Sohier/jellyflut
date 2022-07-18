import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_type.dart';

part 'subtitle.freezed.dart';
part 'subtitle.g.dart';

@Freezed()
class Subtitle with _$Subtitle {
  factory Subtitle(
      {required int index, int? jellyfinSubtitleIndex, required MediaType mediaType, required String name}) = _Subtitle;

  factory Subtitle.fromJson(Map<String, Object?> json) => _$SubtitleFromJson(json);
}
