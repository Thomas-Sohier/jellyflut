// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_People _$$_PeopleFromJson(Map<String, dynamic> json) => _$_People(
      id: json['Id'] as String,
      name: json['Name'] as String?,
      role: json['Role'] as String?,
      type: json['Type'] as String?,
      primaryImageTag: json['PrimaryImageTag'] as String?,
      imageBlurHashes: json['ImageBlurHashes'] == null
          ? null
          : ImageBlurHashes.fromJson(
              json['ImageBlurHashes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PeopleToJson(_$_People instance) {
  final val = <String, dynamic>{
    'Id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Name', instance.name);
  writeNotNull('Role', instance.role);
  writeNotNull('Type', instance.type);
  writeNotNull('PrimaryImageTag', instance.primaryImageTag);
  writeNotNull('ImageBlurHashes', instance.imageBlurHashes);
  return val;
}
