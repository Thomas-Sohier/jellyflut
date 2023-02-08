import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellyfin_authentication_api/src/models/subtitle_mode.dart';

part 'configuration.freezed.dart';
part 'configuration.g.dart';

/// {@template configuration}
/// A single configuration item.
///
/// Contains a [audioLanguagePreference],  [playDefaultAudioTrack], [subtitleLanguagePreference],
/// [displayMissingEpisodes], [groupedFolders], [subtitleMode],
/// [displayCollectionsView], [orderedViews], [latestItemsExcludes],
/// [myMediaExcludes], [hidePlayedInLatest], [rememberAudioSelections],
/// [rememberSubtitleSelections] and [enableNextEpisodeAutoPlay]
///
///
/// [Configuration]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
@Freezed()
class Configuration with _$Configuration {
  const factory Configuration(
      {String? audioLanguagePreference,
      required bool playDefaultAudioTrack,
      String? subtitleLanguagePreference,
      required bool displayMissingEpisodes,
      @Default(<String>[]) List<String> groupedFolders,
      SubtitleMode? subtitleMode,
      required bool displayCollectionsView,
      required bool enableLocalPassword,
      @Default(<String>[]) List<String> orderedViews,
      @Default(<String>[]) List<String> latestItemsExcludes,
      @Default(<String>[]) List<String> myMediaExcludes,
      required bool hidePlayedInLatest,
      required bool rememberAudioSelections,
      required bool rememberSubtitleSelections,
      required bool enableNextEpisodeAutoPlay}) = _Configuration;

  /// Deserializes the given [JsonMap] into a [Configuration].
  factory Configuration.fromJson(Map<String, Object?> json) => _$ConfigurationFromJson(json);
}
