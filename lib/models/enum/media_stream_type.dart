import 'enum_values.dart';

///Audio
/// The audio.
///
/// EmbeddedImage
/// The embedded image.
///
/// Subtitle
/// The subtitle.
///
/// Video
/// The video.

enum MediaStreamType { AUDIO, EMBEDDEDIMAGE, SUBTITLE, VIDEO }

final mediaStreamType = EnumValues({
  'Audio': MediaStreamType.AUDIO,
  'EmbeddedImage': MediaStreamType.EMBEDDEDIMAGE,
  'Subtitle': MediaStreamType.SUBTITLE,
  'Video': MediaStreamType.VIDEO
});
