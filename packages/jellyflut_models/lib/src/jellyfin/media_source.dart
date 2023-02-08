import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/index.dart';
import 'index.dart';

part 'media_source.freezed.dart';
part 'media_source.g.dart';

@Freezed()
class MediaSource with _$MediaSource {
  factory MediaSource({
    required Protocol protocol,
    String? id,
    String? path,
    String? encoderPath,
    Protocol? encoderProtocol,
    required MediaSourceType type,
    String? container,
    int? size,
    String? name,

    ///Gets or sets a value indicating whether the media is remote. Differentiate internet url vs local network.
    required bool isRemote,
    String? eTag,
    int? runTimeTicks,
    required bool readAtNativeFramerate,
    required bool ignoreDts,
    required bool ignoreIndex,
    required bool genPtsInput,
    required bool supportsTranscoding,
    required bool supportsDirectStream,
    required bool supportsDirectPlay,
    required bool isInfiniteStream,
    required bool requiresOpening,
    String? openToken,
    required bool requiresClosing,
    String? liveStreamId,
    int? bufferMs,
    required bool requiresLooping,
    required bool supportsProbing,
    VideoType? videoType,
    IsoType? isoType,
    Video3DFormat? video3DFormat,
    @Default(<MediaStream>[]) List<MediaStream> mediaStreams,
    @Default(<MediaAttachment>[]) List<MediaAttachment> mediaAttachments,
    @Default(<String>[]) List<String> formats,
    int? bitrate,
    Timestamp? timestamp,
    @Default(<String, String>{}) Map<String, String> requiredHttpHeaders,
    String? transcodingUrl,
    String? transcodingSubProtocol,
    String? transcodingContainer,
    int? analyzeDurationMs,
    int? defaultAudioStreamIndex,
    int? defaultSubtitleStreamIndex,
  }) = _MediaSource;

  factory MediaSource.fromJson(Map<String, Object?> json) => _$MediaSourceFromJson(json);
}
