// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavState _$FavStateFromJson(Map<String, dynamic> json) => FavState(
      status: $enumDecodeNullable(_$FavStatusEnumMap, json['status']) ??
          FavStatus.initial,
      isFav: json['isFav'] as bool? ?? false,
    );

Map<String, dynamic> _$FavStateToJson(FavState instance) => <String, dynamic>{
      'status': _$FavStatusEnumMap[instance.status],
      'isFav': instance.isFav,
    };

const _$FavStatusEnumMap = {
  FavStatus.initial: 'initial',
  FavStatus.loading: 'loading',
  FavStatus.success: 'success',
  FavStatus.failure: 'failure',
};
