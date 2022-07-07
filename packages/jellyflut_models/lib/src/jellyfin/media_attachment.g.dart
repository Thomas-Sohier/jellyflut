// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MediaAttachment _$$_MediaAttachmentFromJson(Map<String, dynamic> json) =>
    _$_MediaAttachment(
      codec: json['codec'] as String?,
      codecTag: json['codecTag'] as String?,
      comment: json['comment'] as String?,
      index: json['index'] as String?,
      fileName: json['fileName'] as String?,
      mimeType: json['mimeType'] as String?,
      deliveryUrl: json['deliveryUrl'] as String?,
    );

Map<String, dynamic> _$$_MediaAttachmentToJson(_$_MediaAttachment instance) =>
    <String, dynamic>{
      'codec': instance.codec,
      'codecTag': instance.codecTag,
      'comment': instance.comment,
      'index': instance.index,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
      'deliveryUrl': instance.deliveryUrl,
    };
