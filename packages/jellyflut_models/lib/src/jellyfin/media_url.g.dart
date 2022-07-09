// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MediaUrl _$$_MediaUrlFromJson(Map<String, dynamic> json) => _$_MediaUrl(
      url: json['Url'] as String?,
      name: json['Name'] as String?,
    );

Map<String, dynamic> _$$_MediaUrlToJson(_$_MediaUrl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Url', instance.url);
  writeNotNull('Name', instance.name);
  return val;
}
