// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MediaAttachment _$$_MediaAttachmentFromJson(Map<String, dynamic> json) =>
    _$_MediaAttachment(
      codec: json['Codec'] as String?,
      codecTag: json['CodecTag'] as String?,
      comment: json['Comment'] as String?,
      index: json['Index'] as int?,
      fileName: json['FileName'] as String?,
      mimeType: json['MimeType'] as String?,
      deliveryUrl: json['DeliveryUrl'] as String?,
    );

Map<String, dynamic> _$$_MediaAttachmentToJson(_$_MediaAttachment instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Codec', instance.codec);
  writeNotNull('CodecTag', instance.codecTag);
  writeNotNull('Comment', instance.comment);
  writeNotNull('Index', instance.index);
  writeNotNull('FileName', instance.fileName);
  writeNotNull('MimeType', instance.mimeType);
  writeNotNull('DeliveryUrl', instance.deliveryUrl);
  return val;
}
