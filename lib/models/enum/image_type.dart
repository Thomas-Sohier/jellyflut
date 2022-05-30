/// Art
/// The art.
///
/// Backdrop
/// The backdrop.
///
/// Banner
/// The banner.
///
/// Box
/// The box.
///
/// BoxRear
/// The box rear.
///
/// Chapter
/// The chapter image.
///
/// Disc
/// The disc.
///
/// Logo
/// The logo.
///
/// Menu
/// The menu.
///
/// Primary
/// The primary.
///
/// Profile
/// The user profile image.
///
/// Screenshot
/// The screenshot.
///
/// Thumb
/// The thumb.

enum ImageType {
  ART('Art'),
  BACKDROP('Backdrop'),
  BANNER('Banner'),
  BOX('Box'),
  BOXREAR('Boxrear'),
  CHAPTER('Chapter'),
  DISC('Disc'),
  LOGO('Logo'),
  MENU('Menu'),
  PRIMARY('Primary'),
  PROFILE('Profile'),
  SCREENSHOT('Screenshot'),
  THUMB('Thumb');

  final String value;
  const ImageType(this.value);

  static ImageType fromString(String value) {
    return ImageType.values
        .firstWhere((ext) => ext.value.toLowerCase() == value.toLowerCase());
  }
}
