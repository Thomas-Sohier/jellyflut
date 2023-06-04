import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_type.dart';

part 'subtitle.freezed.dart';
part 'subtitle.g.dart';

@immutable
@Freezed()
class Subtitle with _$Subtitle {
  const Subtitle._();

  const factory Subtitle(
      {required String index,
      int? jellyfinSubtitleIndex,
      required MediaType mediaType,
      required String name}) = _Subtitle;

  factory Subtitle.fromJson(Map<String, Object?> json) => _$SubtitleFromJson(json);

  /// Empty subtitle which represents an empty subtitle.
  static const empty = Subtitle(index: 'none', mediaType: MediaType.local, name: 'default');

  /// Convenience getter to determine whether the current subtitle is empty.
  bool get isEmpty => this == Subtitle.empty;

  /// Convenience getter to determine whether the current subtitle is not empty.
  bool get isNotEmpty => this != Subtitle.empty;
}
