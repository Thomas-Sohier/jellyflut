import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/index.dart';

part 'media_stream.freezed.dart';
part 'media_stream.g.dart';

@Freezed()
class MediaStream with _$MediaStream {
  MediaStream._();

  factory MediaStream({
    String? codec,
    String? language,
    String? colorTransfer,
    String? colorPrimaries,
    String? timeBase,
    String? codecTimeBase,
    String? videoRange,
    String? displayTitle,
    String? nalLengthSize,
    bool? isInterlaced,
    bool? isAvc,
    int? bitRate,
    int? bitDepth,
    int? refFrames,
    bool? isDefault,
    bool? isForced,
    int? height,
    int? width,
    double? averageFrameRate,
    double? realFrameRate,
    String? profile,
    required MediaStreamType type,
    String? aspectRatio,
    required int index,
    bool? isExternal,
    String? deliveryMethod,
    String? deliveryUrl,
    bool? isTextSubtitleStream,
    bool? supportsExternalStream,
    String? pixelFormat,
    int? level,
    String? channelLayout,
    int? channels,
    int? sampleRate,
    String? title,
    String? localizedUndefined,
    String? localizedDefault,
    String? localizedForced,
  }) = _MediaStream;

  factory MediaStream.fromJson(Map<String, Object?> json) => _$MediaStreamFromJson(json);

  bool isRemote() {
    if (isExternal != null) return isExternal!;
    return true;
  }
}
