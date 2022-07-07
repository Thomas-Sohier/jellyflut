// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'people.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

People _$PeopleFromJson(Map<String, dynamic> json) {
  return _People.fromJson(json);
}

/// @nodoc
mixin _$People {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get primaryImageTag => throw _privateConstructorUsedError;
  ImageBlurHashes? get imageBlurHashes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PeopleCopyWith<People> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeopleCopyWith<$Res> {
  factory $PeopleCopyWith(People value, $Res Function(People) then) =
      _$PeopleCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String? name,
      String? role,
      String? type,
      String? primaryImageTag,
      ImageBlurHashes? imageBlurHashes});

  $ImageBlurHashesCopyWith<$Res>? get imageBlurHashes;
}

/// @nodoc
class _$PeopleCopyWithImpl<$Res> implements $PeopleCopyWith<$Res> {
  _$PeopleCopyWithImpl(this._value, this._then);

  final People _value;
  // ignore: unused_field
  final $Res Function(People) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? role = freezed,
    Object? type = freezed,
    Object? primaryImageTag = freezed,
    Object? imageBlurHashes = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryImageTag: primaryImageTag == freezed
          ? _value.primaryImageTag
          : primaryImageTag // ignore: cast_nullable_to_non_nullable
              as String?,
      imageBlurHashes: imageBlurHashes == freezed
          ? _value.imageBlurHashes
          : imageBlurHashes // ignore: cast_nullable_to_non_nullable
              as ImageBlurHashes?,
    ));
  }

  @override
  $ImageBlurHashesCopyWith<$Res>? get imageBlurHashes {
    if (_value.imageBlurHashes == null) {
      return null;
    }

    return $ImageBlurHashesCopyWith<$Res>(_value.imageBlurHashes!, (value) {
      return _then(_value.copyWith(imageBlurHashes: value));
    });
  }
}

/// @nodoc
abstract class _$$_PeopleCopyWith<$Res> implements $PeopleCopyWith<$Res> {
  factory _$$_PeopleCopyWith(_$_People value, $Res Function(_$_People) then) =
      __$$_PeopleCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String? name,
      String? role,
      String? type,
      String? primaryImageTag,
      ImageBlurHashes? imageBlurHashes});

  @override
  $ImageBlurHashesCopyWith<$Res>? get imageBlurHashes;
}

/// @nodoc
class __$$_PeopleCopyWithImpl<$Res> extends _$PeopleCopyWithImpl<$Res>
    implements _$$_PeopleCopyWith<$Res> {
  __$$_PeopleCopyWithImpl(_$_People _value, $Res Function(_$_People) _then)
      : super(_value, (v) => _then(v as _$_People));

  @override
  _$_People get _value => super._value as _$_People;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? role = freezed,
    Object? type = freezed,
    Object? primaryImageTag = freezed,
    Object? imageBlurHashes = freezed,
  }) {
    return _then(_$_People(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryImageTag: primaryImageTag == freezed
          ? _value.primaryImageTag
          : primaryImageTag // ignore: cast_nullable_to_non_nullable
              as String?,
      imageBlurHashes: imageBlurHashes == freezed
          ? _value.imageBlurHashes
          : imageBlurHashes // ignore: cast_nullable_to_non_nullable
              as ImageBlurHashes?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_People extends _People {
  _$_People(
      {required this.id,
      this.name,
      this.role,
      this.type,
      this.primaryImageTag,
      this.imageBlurHashes})
      : super._();

  factory _$_People.fromJson(Map<String, dynamic> json) =>
      _$$_PeopleFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final String? role;
  @override
  final String? type;
  @override
  final String? primaryImageTag;
  @override
  final ImageBlurHashes? imageBlurHashes;

  @override
  String toString() {
    return 'People(id: $id, name: $name, role: $role, type: $type, primaryImageTag: $primaryImageTag, imageBlurHashes: $imageBlurHashes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_People &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.role, role) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other.primaryImageTag, primaryImageTag) &&
            const DeepCollectionEquality()
                .equals(other.imageBlurHashes, imageBlurHashes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(role),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(primaryImageTag),
      const DeepCollectionEquality().hash(imageBlurHashes));

  @JsonKey(ignore: true)
  @override
  _$$_PeopleCopyWith<_$_People> get copyWith =>
      __$$_PeopleCopyWithImpl<_$_People>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PeopleToJson(this);
  }
}

abstract class _People extends People {
  factory _People(
      {required final String id,
      final String? name,
      final String? role,
      final String? type,
      final String? primaryImageTag,
      final ImageBlurHashes? imageBlurHashes}) = _$_People;
  _People._() : super._();

  factory _People.fromJson(Map<String, dynamic> json) = _$_People.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  String? get role;
  @override
  String? get type;
  @override
  String? get primaryImageTag;
  @override
  ImageBlurHashes? get imageBlurHashes;
  @override
  @JsonKey(ignore: true)
  _$$_PeopleCopyWith<_$_People> get copyWith =>
      throw _privateConstructorUsedError;
}
