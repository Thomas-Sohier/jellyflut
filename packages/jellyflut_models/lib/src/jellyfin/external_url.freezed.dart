// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'external_url.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ExternalUrl _$ExternalUrlFromJson(Map<String, dynamic> json) {
  return _ExternalUrl.fromJson(json);
}

/// @nodoc
mixin _$ExternalUrl {
  String? get name => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExternalUrlCopyWith<ExternalUrl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalUrlCopyWith<$Res> {
  factory $ExternalUrlCopyWith(
          ExternalUrl value, $Res Function(ExternalUrl) then) =
      _$ExternalUrlCopyWithImpl<$Res>;
  $Res call({String? name, String? url});
}

/// @nodoc
class _$ExternalUrlCopyWithImpl<$Res> implements $ExternalUrlCopyWith<$Res> {
  _$ExternalUrlCopyWithImpl(this._value, this._then);

  final ExternalUrl _value;
  // ignore: unused_field
  final $Res Function(ExternalUrl) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_ExternalUrlCopyWith<$Res>
    implements $ExternalUrlCopyWith<$Res> {
  factory _$$_ExternalUrlCopyWith(
          _$_ExternalUrl value, $Res Function(_$_ExternalUrl) then) =
      __$$_ExternalUrlCopyWithImpl<$Res>;
  @override
  $Res call({String? name, String? url});
}

/// @nodoc
class __$$_ExternalUrlCopyWithImpl<$Res> extends _$ExternalUrlCopyWithImpl<$Res>
    implements _$$_ExternalUrlCopyWith<$Res> {
  __$$_ExternalUrlCopyWithImpl(
      _$_ExternalUrl _value, $Res Function(_$_ExternalUrl) _then)
      : super(_value, (v) => _then(v as _$_ExternalUrl));

  @override
  _$_ExternalUrl get _value => super._value as _$_ExternalUrl;

  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
  }) {
    return _then(_$_ExternalUrl(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ExternalUrl implements _ExternalUrl {
  _$_ExternalUrl({this.name, this.url});

  factory _$_ExternalUrl.fromJson(Map<String, dynamic> json) =>
      _$$_ExternalUrlFromJson(json);

  @override
  final String? name;
  @override
  final String? url;

  @override
  String toString() {
    return 'ExternalUrl(name: $name, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExternalUrl &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.url, url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(url));

  @JsonKey(ignore: true)
  @override
  _$$_ExternalUrlCopyWith<_$_ExternalUrl> get copyWith =>
      __$$_ExternalUrlCopyWithImpl<_$_ExternalUrl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ExternalUrlToJson(this);
  }
}

abstract class _ExternalUrl implements ExternalUrl {
  factory _ExternalUrl({final String? name, final String? url}) =
      _$_ExternalUrl;

  factory _ExternalUrl.fromJson(Map<String, dynamic> json) =
      _$_ExternalUrl.fromJson;

  @override
  String? get name;
  @override
  String? get url;
  @override
  @JsonKey(ignore: true)
  _$$_ExternalUrlCopyWith<_$_ExternalUrl> get copyWith =>
      throw _privateConstructorUsedError;
}
