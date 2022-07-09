// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_blur_hashes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ImageBlurHashes _$$_ImageBlurHashesFromJson(Map<String, dynamic> json) =>
    _$_ImageBlurHashes(
      primary: (json['Primary'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      art: (json['Art'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      backdrop: (json['Backdrop'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      banner: (json['Banner'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      logo: (json['Logo'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      thumb: (json['Thumb'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      disc: (json['Disc'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      box: (json['Box'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      screenshot: (json['Screenshot'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      menu: (json['Menu'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      chapter: (json['Chapter'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      boxrear: (json['Boxrear'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      profile: (json['Profile'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$_ImageBlurHashesToJson(_$_ImageBlurHashes instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Primary', instance.primary);
  writeNotNull('Art', instance.art);
  writeNotNull('Backdrop', instance.backdrop);
  writeNotNull('Banner', instance.banner);
  writeNotNull('Logo', instance.logo);
  writeNotNull('Thumb', instance.thumb);
  writeNotNull('Disc', instance.disc);
  writeNotNull('Box', instance.box);
  writeNotNull('Screenshot', instance.screenshot);
  writeNotNull('Menu', instance.menu);
  writeNotNull('Chapter', instance.chapter);
  writeNotNull('Boxrear', instance.boxrear);
  writeNotNull('Profile', instance.profile);
  return val;
}
