// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'named_guid_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NamedGuidPair _$$_NamedGuidPairFromJson(Map<String, dynamic> json) =>
    _$_NamedGuidPair(
      name: json['Name'] as String?,
      id: json['Id'] as String?,
    );

Map<String, dynamic> _$$_NamedGuidPairToJson(_$_NamedGuidPair instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('Name', instance.name);
  writeNotNull('Id', instance.id);
  return val;
}
