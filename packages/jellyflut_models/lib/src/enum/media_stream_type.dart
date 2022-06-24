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

enum MediaStreamType {
  AUDIO('Audio'),
  Book('Book'),
  EMBEDDEDIMAGE('EmbeddedImage'),
  Photo('Photo'),
  SUBTITLE('Subtitle'),
  VIDEO('Video');

  final String value;
  const MediaStreamType(this.value);

  static MediaStreamType fromString(String value) {
    return MediaStreamType.values
        .firstWhere((type) => type.value.toLowerCase() == value.toLowerCase());
  }
}
