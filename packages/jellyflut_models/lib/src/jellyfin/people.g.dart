// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'people.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_People _$$_PeopleFromJson(Map<String, dynamic> json) => _$_People(
      id: json['id'] as String,
      name: json['name'] as String?,
      role: json['role'] as String?,
      type: json['type'] as String?,
      primaryImageTag: json['primaryImageTag'] as String?,
      imageBlurHashes: json['imageBlurHashes'] == null
          ? null
          : ImageBlurHashes.fromJson(
              json['imageBlurHashes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PeopleToJson(_$_People instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
      'type': instance.type,
      'primaryImageTag': instance.primaryImageTag,
      'imageBlurHashes': instance.imageBlurHashes,
    };
