// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'named_guid_pair.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NamedGuidPair _$NamedGuidPairFromJson(Map<String, dynamic> json) {
  return _NamedGuidPair.fromJson(json);
}

/// @nodoc
mixin _$NamedGuidPair {
  String? get name => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NamedGuidPairCopyWith<NamedGuidPair> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NamedGuidPairCopyWith<$Res> {
  factory $NamedGuidPairCopyWith(
          NamedGuidPair value, $Res Function(NamedGuidPair) then) =
      _$NamedGuidPairCopyWithImpl<$Res>;
  $Res call({String? name, String? id});
}

/// @nodoc
class _$NamedGuidPairCopyWithImpl<$Res>
    implements $NamedGuidPairCopyWith<$Res> {
  _$NamedGuidPairCopyWithImpl(this._value, this._then);

  final NamedGuidPair _value;
  // ignore: unused_field
  final $Res Function(NamedGuidPair) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_NamedGuidPairCopyWith<$Res>
    implements $NamedGuidPairCopyWith<$Res> {
  factory _$$_NamedGuidPairCopyWith(
          _$_NamedGuidPair value, $Res Function(_$_NamedGuidPair) then) =
      __$$_NamedGuidPairCopyWithImpl<$Res>;
  @override
  $Res call({String? name, String? id});
}

/// @nodoc
class __$$_NamedGuidPairCopyWithImpl<$Res>
    extends _$NamedGuidPairCopyWithImpl<$Res>
    implements _$$_NamedGuidPairCopyWith<$Res> {
  __$$_NamedGuidPairCopyWithImpl(
      _$_NamedGuidPair _value, $Res Function(_$_NamedGuidPair) _then)
      : super(_value, (v) => _then(v as _$_NamedGuidPair));

  @override
  _$_NamedGuidPair get _value => super._value as _$_NamedGuidPair;

  @override
  $Res call({
    Object? name = freezed,
    Object? id = freezed,
  }) {
    return _then(_$_NamedGuidPair(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NamedGuidPair implements _NamedGuidPair {
  _$_NamedGuidPair({this.name, this.id});

  factory _$_NamedGuidPair.fromJson(Map<String, dynamic> json) =>
      _$$_NamedGuidPairFromJson(json);

  @override
  final String? name;
  @override
  final String? id;

  @override
  String toString() {
    return 'NamedGuidPair(name: $name, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NamedGuidPair &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.id, id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(id));

  @JsonKey(ignore: true)
  @override
  _$$_NamedGuidPairCopyWith<_$_NamedGuidPair> get copyWith =>
      __$$_NamedGuidPairCopyWithImpl<_$_NamedGuidPair>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NamedGuidPairToJson(this);
  }
}

abstract class _NamedGuidPair implements NamedGuidPair {
  factory _NamedGuidPair({final String? name, final String? id}) =
      _$_NamedGuidPair;

  factory _NamedGuidPair.fromJson(Map<String, dynamic> json) =
      _$_NamedGuidPair.fromJson;

  @override
  String? get name;
  @override
  String? get id;
  @override
  @JsonKey(ignore: true)
  _$$_NamedGuidPairCopyWith<_$_NamedGuidPair> get copyWith =>
      throw _privateConstructorUsedError;
}
