// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Download _$DownloadFromJson(Map<String, dynamic> json) => Download(
      id: json['id'] as String,
      name: json['name'] as String?,
      path: json['path'] as String,
      primary:
          const Uint8ListConverter().fromJson(json['primary'] as List<int>?),
      backdrop:
          const Uint8ListConverter().fromJson(json['backdrop'] as List<int>?),
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DownloadToJson(Download instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'primary': const Uint8ListConverter().toJson(instance.primary),
      'backdrop': const Uint8ListConverter().toJson(instance.backdrop),
      'item': instance.item,
    };
