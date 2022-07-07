// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'media_url.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MediaUrl _$MediaUrlFromJson(Map<String, dynamic> json) {
  return _MediaUrl.fromJson(json);
}

/// @nodoc
mixin _$MediaUrl {
  String? get url => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaUrlCopyWith<MediaUrl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaUrlCopyWith<$Res> {
  factory $MediaUrlCopyWith(MediaUrl value, $Res Function(MediaUrl) then) =
      _$MediaUrlCopyWithImpl<$Res>;
  $Res call({String? url, String? name});
}

/// @nodoc
class _$MediaUrlCopyWithImpl<$Res> implements $MediaUrlCopyWith<$Res> {
  _$MediaUrlCopyWithImpl(this._value, this._then);

  final MediaUrl _value;
  // ignore: unused_field
  final $Res Function(MediaUrl) _then;

  @override
  $Res call({
    Object? url = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_MediaUrlCopyWith<$Res> implements $MediaUrlCopyWith<$Res> {
  factory _$$_MediaUrlCopyWith(
          _$_MediaUrl value, $Res Function(_$_MediaUrl) then) =
      __$$_MediaUrlCopyWithImpl<$Res>;
  @override
  $Res call({String? url, String? name});
}

/// @nodoc
class __$$_MediaUrlCopyWithImpl<$Res> extends _$MediaUrlCopyWithImpl<$Res>
    implements _$$_MediaUrlCopyWith<$Res> {
  __$$_MediaUrlCopyWithImpl(
      _$_MediaUrl _value, $Res Function(_$_MediaUrl) _then)
      : super(_value, (v) => _then(v as _$_MediaUrl));

  @override
  _$_MediaUrl get _value => super._value as _$_MediaUrl;

  @override
  $Res call({
    Object? url = freezed,
    Object? name = freezed,
  }) {
    return _then(_$_MediaUrl(
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MediaUrl implements _MediaUrl {
  _$_MediaUrl({this.url, this.name});

  factory _$_MediaUrl.fromJson(Map<String, dynamic> json) =>
      _$$_MediaUrlFromJson(json);

  @override
  final String? url;
  @override
  final String? name;

  @override
  String toString() {
    return 'MediaUrl(url: $url, name: $name)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MediaUrl &&
            const DeepCollectionEquality().equals(other.url, url) &&
            const DeepCollectionEquality().equals(other.name, name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(url),
      const DeepCollectionEquality().hash(name));

  @JsonKey(ignore: true)
  @override
  _$$_MediaUrlCopyWith<_$_MediaUrl> get copyWith =>
      __$$_MediaUrlCopyWithImpl<_$_MediaUrl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MediaUrlToJson(this);
  }
}

abstract class _MediaUrl implements MediaUrl {
  factory _MediaUrl({final String? url, final String? name}) = _$_MediaUrl;

  factory _MediaUrl.fromJson(Map<String, dynamic> json) = _$_MediaUrl.fromJson;

  @override
  String? get url;
  @override
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$_MediaUrlCopyWith<_$_MediaUrl> get copyWith =>
      throw _privateConstructorUsedError;
}
