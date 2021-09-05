import 'enum_values.dart';

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
  ART,
  BACKDROP,
  BANNER,
  BOX,
  BOXREAR,
  CHAPTER,
  DISC,
  LOGO,
  MENU,
  PRIMARY,
  PROFILE,
  SCREENSHOT,
  THUMB,
}

final imageTypeValues = EnumValues({
  'Art': ImageType.ART,
  'Backdrop': ImageType.BACKDROP,
  'Banner': ImageType.BANNER,
  'Box': ImageType.BOX,
  'Boxrear': ImageType.BOXREAR,
  'Chapter': ImageType.CHAPTER,
  'Disc': ImageType.DISC,
  'Logo': ImageType.LOGO,
  'Menu': ImageType.MENU,
  'Primary': ImageType.PRIMARY,
  'Profile': ImageType.PROFILE,
  'Screenshot': ImageType.SCREENSHOT,
  'Thumb': ImageType.THUMB,
});
