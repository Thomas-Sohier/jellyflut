// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ExternalUrl _$$_ExternalUrlFromJson(Map<String, dynamic> json) =>
    _$_ExternalUrl(
      name: json['Name'] as String?,
      url: json['Url'] as String?,
    );

Map<String, dynamic> _$$_ExternalUrlToJson(_$_ExternalUrl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Name', instance.name);
  writeNotNull('Url', instance.url);
  return val;
}
