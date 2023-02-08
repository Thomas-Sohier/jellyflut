// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewState _$ViewStateFromJson(Map<String, dynamic> json) => ViewState(
      status: $enumDecodeNullable(_$ViewStatusEnumMap, json['status']) ?? ViewStatus.initial,
      isViewed: json['isViewed'] as bool? ?? false,
    );

Map<String, dynamic> _$ViewStateToJson(ViewState instance) => <String, dynamic>{
      'status': _$ViewStatusEnumMap[instance.status]!,
      'isViewed': instance.isViewed,
    };

const _$ViewStatusEnumMap = {
  ViewStatus.initial: 'initial',
  ViewStatus.loading: 'loading',
  ViewStatus.success: 'success',
  ViewStatus.failure: 'failure',
};
