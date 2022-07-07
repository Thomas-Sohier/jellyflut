// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'media_attachment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MediaAttachment _$MediaAttachmentFromJson(Map<String, dynamic> json) {
  return _MediaAttachment.fromJson(json);
}

/// @nodoc
mixin _$MediaAttachment {
  /// Gets or sets the codec.
  String? get codec => throw _privateConstructorUsedError;

  ///Gets or sets the codec tag.
  String? get codecTag => throw _privateConstructorUsedError;

  /// Gets or sets the comment
  String? get comment => throw _privateConstructorUsedError;

  /// Gets or sets the index
  String? get index => throw _privateConstructorUsedError;

  /// Gets or sets the filename
  String? get fileName => throw _privateConstructorUsedError;

  /// Gets or sets the MIME type
  String? get mimeType => throw _privateConstructorUsedError;

  /// Gets or sets the delivery URL
  String? get deliveryUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaAttachmentCopyWith<MediaAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaAttachmentCopyWith<$Res> {
  factory $MediaAttachmentCopyWith(
          MediaAttachment value, $Res Function(MediaAttachment) then) =
      _$MediaAttachmentCopyWithImpl<$Res>;
  $Res call(
      {String? codec,
      String? codecTag,
      String? comment,
      String? index,
      String? fileName,
      String? mimeType,
      String? deliveryUrl});
}

/// @nodoc
class _$MediaAttachmentCopyWithImpl<$Res>
    implements $MediaAttachmentCopyWith<$Res> {
  _$MediaAttachmentCopyWithImpl(this._value, this._then);

  final MediaAttachment _value;
  // ignore: unused_field
  final $Res Function(MediaAttachment) _then;

  @override
  $Res call({
    Object? codec = freezed,
    Object? codecTag = freezed,
    Object? comment = freezed,
    Object? index = freezed,
    Object? fileName = freezed,
    Object? mimeType = freezed,
    Object? deliveryUrl = freezed,
  }) {
    return _then(_value.copyWith(
      codec: codec == freezed
          ? _value.codec
          : codec // ignore: cast_nullable_to_non_nullable
              as String?,
      codecTag: codecTag == freezed
          ? _value.codecTag
          : codecTag // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: comment == freezed
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: fileName == freezed
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: mimeType == freezed
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryUrl: deliveryUrl == freezed
          ? _value.deliveryUrl
          : deliveryUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_MediaAttachmentCopyWith<$Res>
    implements $MediaAttachmentCopyWith<$Res> {
  factory _$$_MediaAttachmentCopyWith(
          _$_MediaAttachment value, $Res Function(_$_MediaAttachment) then) =
      __$$_MediaAttachmentCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? codec,
      String? codecTag,
      String? comment,
      String? index,
      String? fileName,
      String? mimeType,
      String? deliveryUrl});
}

/// @nodoc
class __$$_MediaAttachmentCopyWithImpl<$Res>
    extends _$MediaAttachmentCopyWithImpl<$Res>
    implements _$$_MediaAttachmentCopyWith<$Res> {
  __$$_MediaAttachmentCopyWithImpl(
      _$_MediaAttachment _value, $Res Function(_$_MediaAttachment) _then)
      : super(_value, (v) => _then(v as _$_MediaAttachment));

  @override
  _$_MediaAttachment get _value => super._value as _$_MediaAttachment;

  @override
  $Res call({
    Object? codec = freezed,
    Object? codecTag = freezed,
    Object? comment = freezed,
    Object? index = freezed,
    Object? fileName = freezed,
    Object? mimeType = freezed,
    Object? deliveryUrl = freezed,
  }) {
    return _then(_$_MediaAttachment(
      codec: codec == freezed
          ? _value.codec
          : codec // ignore: cast_nullable_to_non_nullable
              as String?,
      codecTag: codecTag == freezed
          ? _value.codecTag
          : codecTag // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: comment == freezed
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as String?,
      fileName: fileName == freezed
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: mimeType == freezed
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryUrl: deliveryUrl == freezed
          ? _value.deliveryUrl
          : deliveryUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MediaAttachment implements _MediaAttachment {
  _$_MediaAttachment(
      {this.codec,
      this.codecTag,
      this.comment,
      this.index,
      this.fileName,
      this.mimeType,
      this.deliveryUrl});

  factory _$_MediaAttachment.fromJson(Map<String, dynamic> json) =>
      _$$_MediaAttachmentFromJson(json);

  /// Gets or sets the codec.
  @override
  final String? codec;

  ///Gets or sets the codec tag.
  @override
  final String? codecTag;

  /// Gets or sets the comment
  @override
  final String? comment;

  /// Gets or sets the index
  @override
  final String? index;

  /// Gets or sets the filename
  @override
  final String? fileName;

  /// Gets or sets the MIME type
  @override
  final String? mimeType;

  /// Gets or sets the delivery URL
  @override
  final String? deliveryUrl;

  @override
  String toString() {
    return 'MediaAttachment(codec: $codec, codecTag: $codecTag, comment: $comment, index: $index, fileName: $fileName, mimeType: $mimeType, deliveryUrl: $deliveryUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MediaAttachment &&
            const DeepCollectionEquality().equals(other.codec, codec) &&
            const DeepCollectionEquality().equals(other.codecTag, codecTag) &&
            const DeepCollectionEquality().equals(other.comment, comment) &&
            const DeepCollectionEquality().equals(other.index, index) &&
            const DeepCollectionEquality().equals(other.fileName, fileName) &&
            const DeepCollectionEquality().equals(other.mimeType, mimeType) &&
            const DeepCollectionEquality()
                .equals(other.deliveryUrl, deliveryUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(codec),
      const DeepCollectionEquality().hash(codecTag),
      const DeepCollectionEquality().hash(comment),
      const DeepCollectionEquality().hash(index),
      const DeepCollectionEquality().hash(fileName),
      const DeepCollectionEquality().hash(mimeType),
      const DeepCollectionEquality().hash(deliveryUrl));

  @JsonKey(ignore: true)
  @override
  _$$_MediaAttachmentCopyWith<_$_MediaAttachment> get copyWith =>
      __$$_MediaAttachmentCopyWithImpl<_$_MediaAttachment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MediaAttachmentToJson(this);
  }
}

abstract class _MediaAttachment implements MediaAttachment {
  factory _MediaAttachment(
      {final String? codec,
      final String? codecTag,
      final String? comment,
      final String? index,
      final String? fileName,
      final String? mimeType,
      final String? deliveryUrl}) = _$_MediaAttachment;

  factory _MediaAttachment.fromJson(Map<String, dynamic> json) =
      _$_MediaAttachment.fromJson;

  @override

  /// Gets or sets the codec.
  String? get codec;
  @override

  ///Gets or sets the codec tag.
  String? get codecTag;
  @override

  /// Gets or sets the comment
  String? get comment;
  @override

  /// Gets or sets the index
  String? get index;
  @override

  /// Gets or sets the filename
  String? get fileName;
  @override

  /// Gets or sets the MIME type
  String? get mimeType;
  @override

  /// Gets or sets the delivery URL
  String? get deliveryUrl;
  @override
  @JsonKey(ignore: true)
  _$$_MediaAttachmentCopyWith<_$_MediaAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}
