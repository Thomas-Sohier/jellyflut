// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'media_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MediaSource _$MediaSourceFromJson(Map<String, dynamic> json) {
  return _MediaSource.fromJson(json);
}

/// @nodoc
mixin _$MediaSource {
  Protocol get protocol => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;
  String? get encoderPath => throw _privateConstructorUsedError;
  Protocol? get encoderProtocol => throw _privateConstructorUsedError;
  MediaSourceType get type => throw _privateConstructorUsedError;
  String? get container => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  ///Gets or sets a value indicating whether the media is remote. Differentiate internet url vs local network.
  bool get isRemote => throw _privateConstructorUsedError;
  String? get eTag => throw _privateConstructorUsedError;
  int? get runTimeTicks => throw _privateConstructorUsedError;
  bool get readAtNativeFramerate => throw _privateConstructorUsedError;
  bool get ignoreDts => throw _privateConstructorUsedError;
  bool get ignoreIndex => throw _privateConstructorUsedError;
  bool get genPtsInput => throw _privateConstructorUsedError;
  bool get supportsTranscoding => throw _privateConstructorUsedError;
  bool get supportsDirectStream => throw _privateConstructorUsedError;
  bool get supportsDirectPlay => throw _privateConstructorUsedError;
  bool get isInfiniteStream => throw _privateConstructorUsedError;
  bool get requiresOpening => throw _privateConstructorUsedError;
  String? get openToken => throw _privateConstructorUsedError;
  bool get requiresClosing => throw _privateConstructorUsedError;
  String? get liveStreamId => throw _privateConstructorUsedError;
  int? get bufferMs => throw _privateConstructorUsedError;
  bool get requiresLooping => throw _privateConstructorUsedError;
  bool get supportsProbing => throw _privateConstructorUsedError;
  VideoType? get videoType => throw _privateConstructorUsedError;
  IsoType? get isoType => throw _privateConstructorUsedError;
  Video3DFormat? get video3DFormat => throw _privateConstructorUsedError;
  List<MediaStream> get mediaStreams => throw _privateConstructorUsedError;
  List<MediaAttachment> get mediaAttachments =>
      throw _privateConstructorUsedError;
  List<String> get formats => throw _privateConstructorUsedError;
  int? get bitrate => throw _privateConstructorUsedError;
  Timestamp? get timestamp => throw _privateConstructorUsedError;
  Map<String, String> get requiredHttpHeaders =>
      throw _privateConstructorUsedError;
  String? get transcodingUrl => throw _privateConstructorUsedError;
  String? get transcodingSubProtocol => throw _privateConstructorUsedError;
  String? get transcodingContainer => throw _privateConstructorUsedError;
  int? get analyzeDurationMs => throw _privateConstructorUsedError;
  int? get defaultAudioStreamIndex => throw _privateConstructorUsedError;
  int? get defaultSubtitleStreamIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaSourceCopyWith<MediaSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaSourceCopyWith<$Res> {
  factory $MediaSourceCopyWith(
          MediaSource value, $Res Function(MediaSource) then) =
      _$MediaSourceCopyWithImpl<$Res>;
  $Res call(
      {Protocol protocol,
      String? id,
      String? path,
      String? encoderPath,
      Protocol? encoderProtocol,
      MediaSourceType type,
      String? container,
      int? size,
      String? name,
      bool isRemote,
      String? eTag,
      int? runTimeTicks,
      bool readAtNativeFramerate,
      bool ignoreDts,
      bool ignoreIndex,
      bool genPtsInput,
      bool supportsTranscoding,
      bool supportsDirectStream,
      bool supportsDirectPlay,
      bool isInfiniteStream,
      bool requiresOpening,
      String? openToken,
      bool requiresClosing,
      String? liveStreamId,
      int? bufferMs,
      bool requiresLooping,
      bool supportsProbing,
      VideoType? videoType,
      IsoType? isoType,
      Video3DFormat? video3DFormat,
      List<MediaStream> mediaStreams,
      List<MediaAttachment> mediaAttachments,
      List<String> formats,
      int? bitrate,
      Timestamp? timestamp,
      Map<String, String> requiredHttpHeaders,
      String? transcodingUrl,
      String? transcodingSubProtocol,
      String? transcodingContainer,
      int? analyzeDurationMs,
      int? defaultAudioStreamIndex,
      int? defaultSubtitleStreamIndex});
}

/// @nodoc
class _$MediaSourceCopyWithImpl<$Res> implements $MediaSourceCopyWith<$Res> {
  _$MediaSourceCopyWithImpl(this._value, this._then);

  final MediaSource _value;
  // ignore: unused_field
  final $Res Function(MediaSource) _then;

  @override
  $Res call({
    Object? protocol = freezed,
    Object? id = freezed,
    Object? path = freezed,
    Object? encoderPath = freezed,
    Object? encoderProtocol = freezed,
    Object? type = freezed,
    Object? container = freezed,
    Object? size = freezed,
    Object? name = freezed,
    Object? isRemote = freezed,
    Object? eTag = freezed,
    Object? runTimeTicks = freezed,
    Object? readAtNativeFramerate = freezed,
    Object? ignoreDts = freezed,
    Object? ignoreIndex = freezed,
    Object? genPtsInput = freezed,
    Object? supportsTranscoding = freezed,
    Object? supportsDirectStream = freezed,
    Object? supportsDirectPlay = freezed,
    Object? isInfiniteStream = freezed,
    Object? requiresOpening = freezed,
    Object? openToken = freezed,
    Object? requiresClosing = freezed,
    Object? liveStreamId = freezed,
    Object? bufferMs = freezed,
    Object? requiresLooping = freezed,
    Object? supportsProbing = freezed,
    Object? videoType = freezed,
    Object? isoType = freezed,
    Object? video3DFormat = freezed,
    Object? mediaStreams = freezed,
    Object? mediaAttachments = freezed,
    Object? formats = freezed,
    Object? bitrate = freezed,
    Object? timestamp = freezed,
    Object? requiredHttpHeaders = freezed,
    Object? transcodingUrl = freezed,
    Object? transcodingSubProtocol = freezed,
    Object? transcodingContainer = freezed,
    Object? analyzeDurationMs = freezed,
    Object? defaultAudioStreamIndex = freezed,
    Object? defaultSubtitleStreamIndex = freezed,
  }) {
    return _then(_value.copyWith(
      protocol: protocol == freezed
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as Protocol,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      encoderPath: encoderPath == freezed
          ? _value.encoderPath
          : encoderPath // ignore: cast_nullable_to_non_nullable
              as String?,
      encoderProtocol: encoderProtocol == freezed
          ? _value.encoderProtocol
          : encoderProtocol // ignore: cast_nullable_to_non_nullable
              as Protocol?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaSourceType,
      container: container == freezed
          ? _value.container
          : container // ignore: cast_nullable_to_non_nullable
              as String?,
      size: size == freezed
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isRemote: isRemote == freezed
          ? _value.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool,
      eTag: eTag == freezed
          ? _value.eTag
          : eTag // ignore: cast_nullable_to_non_nullable
              as String?,
      runTimeTicks: runTimeTicks == freezed
          ? _value.runTimeTicks
          : runTimeTicks // ignore: cast_nullable_to_non_nullable
              as int?,
      readAtNativeFramerate: readAtNativeFramerate == freezed
          ? _value.readAtNativeFramerate
          : readAtNativeFramerate // ignore: cast_nullable_to_non_nullable
              as bool,
      ignoreDts: ignoreDts == freezed
          ? _value.ignoreDts
          : ignoreDts // ignore: cast_nullable_to_non_nullable
              as bool,
      ignoreIndex: ignoreIndex == freezed
          ? _value.ignoreIndex
          : ignoreIndex // ignore: cast_nullable_to_non_nullable
              as bool,
      genPtsInput: genPtsInput == freezed
          ? _value.genPtsInput
          : genPtsInput // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsTranscoding: supportsTranscoding == freezed
          ? _value.supportsTranscoding
          : supportsTranscoding // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDirectStream: supportsDirectStream == freezed
          ? _value.supportsDirectStream
          : supportsDirectStream // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDirectPlay: supportsDirectPlay == freezed
          ? _value.supportsDirectPlay
          : supportsDirectPlay // ignore: cast_nullable_to_non_nullable
              as bool,
      isInfiniteStream: isInfiniteStream == freezed
          ? _value.isInfiniteStream
          : isInfiniteStream // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresOpening: requiresOpening == freezed
          ? _value.requiresOpening
          : requiresOpening // ignore: cast_nullable_to_non_nullable
              as bool,
      openToken: openToken == freezed
          ? _value.openToken
          : openToken // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresClosing: requiresClosing == freezed
          ? _value.requiresClosing
          : requiresClosing // ignore: cast_nullable_to_non_nullable
              as bool,
      liveStreamId: liveStreamId == freezed
          ? _value.liveStreamId
          : liveStreamId // ignore: cast_nullable_to_non_nullable
              as String?,
      bufferMs: bufferMs == freezed
          ? _value.bufferMs
          : bufferMs // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresLooping: requiresLooping == freezed
          ? _value.requiresLooping
          : requiresLooping // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsProbing: supportsProbing == freezed
          ? _value.supportsProbing
          : supportsProbing // ignore: cast_nullable_to_non_nullable
              as bool,
      videoType: videoType == freezed
          ? _value.videoType
          : videoType // ignore: cast_nullable_to_non_nullable
              as VideoType?,
      isoType: isoType == freezed
          ? _value.isoType
          : isoType // ignore: cast_nullable_to_non_nullable
              as IsoType?,
      video3DFormat: video3DFormat == freezed
          ? _value.video3DFormat
          : video3DFormat // ignore: cast_nullable_to_non_nullable
              as Video3DFormat?,
      mediaStreams: mediaStreams == freezed
          ? _value.mediaStreams
          : mediaStreams // ignore: cast_nullable_to_non_nullable
              as List<MediaStream>,
      mediaAttachments: mediaAttachments == freezed
          ? _value.mediaAttachments
          : mediaAttachments // ignore: cast_nullable_to_non_nullable
              as List<MediaAttachment>,
      formats: formats == freezed
          ? _value.formats
          : formats // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bitrate: bitrate == freezed
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      requiredHttpHeaders: requiredHttpHeaders == freezed
          ? _value.requiredHttpHeaders
          : requiredHttpHeaders // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      transcodingUrl: transcodingUrl == freezed
          ? _value.transcodingUrl
          : transcodingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      transcodingSubProtocol: transcodingSubProtocol == freezed
          ? _value.transcodingSubProtocol
          : transcodingSubProtocol // ignore: cast_nullable_to_non_nullable
              as String?,
      transcodingContainer: transcodingContainer == freezed
          ? _value.transcodingContainer
          : transcodingContainer // ignore: cast_nullable_to_non_nullable
              as String?,
      analyzeDurationMs: analyzeDurationMs == freezed
          ? _value.analyzeDurationMs
          : analyzeDurationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultAudioStreamIndex: defaultAudioStreamIndex == freezed
          ? _value.defaultAudioStreamIndex
          : defaultAudioStreamIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultSubtitleStreamIndex: defaultSubtitleStreamIndex == freezed
          ? _value.defaultSubtitleStreamIndex
          : defaultSubtitleStreamIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
abstract class _$$_MediaSourceCopyWith<$Res>
    implements $MediaSourceCopyWith<$Res> {
  factory _$$_MediaSourceCopyWith(
          _$_MediaSource value, $Res Function(_$_MediaSource) then) =
      __$$_MediaSourceCopyWithImpl<$Res>;
  @override
  $Res call(
      {Protocol protocol,
      String? id,
      String? path,
      String? encoderPath,
      Protocol? encoderProtocol,
      MediaSourceType type,
      String? container,
      int? size,
      String? name,
      bool isRemote,
      String? eTag,
      int? runTimeTicks,
      bool readAtNativeFramerate,
      bool ignoreDts,
      bool ignoreIndex,
      bool genPtsInput,
      bool supportsTranscoding,
      bool supportsDirectStream,
      bool supportsDirectPlay,
      bool isInfiniteStream,
      bool requiresOpening,
      String? openToken,
      bool requiresClosing,
      String? liveStreamId,
      int? bufferMs,
      bool requiresLooping,
      bool supportsProbing,
      VideoType? videoType,
      IsoType? isoType,
      Video3DFormat? video3DFormat,
      List<MediaStream> mediaStreams,
      List<MediaAttachment> mediaAttachments,
      List<String> formats,
      int? bitrate,
      Timestamp? timestamp,
      Map<String, String> requiredHttpHeaders,
      String? transcodingUrl,
      String? transcodingSubProtocol,
      String? transcodingContainer,
      int? analyzeDurationMs,
      int? defaultAudioStreamIndex,
      int? defaultSubtitleStreamIndex});
}

/// @nodoc
class __$$_MediaSourceCopyWithImpl<$Res> extends _$MediaSourceCopyWithImpl<$Res>
    implements _$$_MediaSourceCopyWith<$Res> {
  __$$_MediaSourceCopyWithImpl(
      _$_MediaSource _value, $Res Function(_$_MediaSource) _then)
      : super(_value, (v) => _then(v as _$_MediaSource));

  @override
  _$_MediaSource get _value => super._value as _$_MediaSource;

  @override
  $Res call({
    Object? protocol = freezed,
    Object? id = freezed,
    Object? path = freezed,
    Object? encoderPath = freezed,
    Object? encoderProtocol = freezed,
    Object? type = freezed,
    Object? container = freezed,
    Object? size = freezed,
    Object? name = freezed,
    Object? isRemote = freezed,
    Object? eTag = freezed,
    Object? runTimeTicks = freezed,
    Object? readAtNativeFramerate = freezed,
    Object? ignoreDts = freezed,
    Object? ignoreIndex = freezed,
    Object? genPtsInput = freezed,
    Object? supportsTranscoding = freezed,
    Object? supportsDirectStream = freezed,
    Object? supportsDirectPlay = freezed,
    Object? isInfiniteStream = freezed,
    Object? requiresOpening = freezed,
    Object? openToken = freezed,
    Object? requiresClosing = freezed,
    Object? liveStreamId = freezed,
    Object? bufferMs = freezed,
    Object? requiresLooping = freezed,
    Object? supportsProbing = freezed,
    Object? videoType = freezed,
    Object? isoType = freezed,
    Object? video3DFormat = freezed,
    Object? mediaStreams = freezed,
    Object? mediaAttachments = freezed,
    Object? formats = freezed,
    Object? bitrate = freezed,
    Object? timestamp = freezed,
    Object? requiredHttpHeaders = freezed,
    Object? transcodingUrl = freezed,
    Object? transcodingSubProtocol = freezed,
    Object? transcodingContainer = freezed,
    Object? analyzeDurationMs = freezed,
    Object? defaultAudioStreamIndex = freezed,
    Object? defaultSubtitleStreamIndex = freezed,
  }) {
    return _then(_$_MediaSource(
      protocol: protocol == freezed
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as Protocol,
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      encoderPath: encoderPath == freezed
          ? _value.encoderPath
          : encoderPath // ignore: cast_nullable_to_non_nullable
              as String?,
      encoderProtocol: encoderProtocol == freezed
          ? _value.encoderProtocol
          : encoderProtocol // ignore: cast_nullable_to_non_nullable
              as Protocol?,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaSourceType,
      container: container == freezed
          ? _value.container
          : container // ignore: cast_nullable_to_non_nullable
              as String?,
      size: size == freezed
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      isRemote: isRemote == freezed
          ? _value.isRemote
          : isRemote // ignore: cast_nullable_to_non_nullable
              as bool,
      eTag: eTag == freezed
          ? _value.eTag
          : eTag // ignore: cast_nullable_to_non_nullable
              as String?,
      runTimeTicks: runTimeTicks == freezed
          ? _value.runTimeTicks
          : runTimeTicks // ignore: cast_nullable_to_non_nullable
              as int?,
      readAtNativeFramerate: readAtNativeFramerate == freezed
          ? _value.readAtNativeFramerate
          : readAtNativeFramerate // ignore: cast_nullable_to_non_nullable
              as bool,
      ignoreDts: ignoreDts == freezed
          ? _value.ignoreDts
          : ignoreDts // ignore: cast_nullable_to_non_nullable
              as bool,
      ignoreIndex: ignoreIndex == freezed
          ? _value.ignoreIndex
          : ignoreIndex // ignore: cast_nullable_to_non_nullable
              as bool,
      genPtsInput: genPtsInput == freezed
          ? _value.genPtsInput
          : genPtsInput // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsTranscoding: supportsTranscoding == freezed
          ? _value.supportsTranscoding
          : supportsTranscoding // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDirectStream: supportsDirectStream == freezed
          ? _value.supportsDirectStream
          : supportsDirectStream // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsDirectPlay: supportsDirectPlay == freezed
          ? _value.supportsDirectPlay
          : supportsDirectPlay // ignore: cast_nullable_to_non_nullable
              as bool,
      isInfiniteStream: isInfiniteStream == freezed
          ? _value.isInfiniteStream
          : isInfiniteStream // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresOpening: requiresOpening == freezed
          ? _value.requiresOpening
          : requiresOpening // ignore: cast_nullable_to_non_nullable
              as bool,
      openToken: openToken == freezed
          ? _value.openToken
          : openToken // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresClosing: requiresClosing == freezed
          ? _value.requiresClosing
          : requiresClosing // ignore: cast_nullable_to_non_nullable
              as bool,
      liveStreamId: liveStreamId == freezed
          ? _value.liveStreamId
          : liveStreamId // ignore: cast_nullable_to_non_nullable
              as String?,
      bufferMs: bufferMs == freezed
          ? _value.bufferMs
          : bufferMs // ignore: cast_nullable_to_non_nullable
              as int?,
      requiresLooping: requiresLooping == freezed
          ? _value.requiresLooping
          : requiresLooping // ignore: cast_nullable_to_non_nullable
              as bool,
      supportsProbing: supportsProbing == freezed
          ? _value.supportsProbing
          : supportsProbing // ignore: cast_nullable_to_non_nullable
              as bool,
      videoType: videoType == freezed
          ? _value.videoType
          : videoType // ignore: cast_nullable_to_non_nullable
              as VideoType?,
      isoType: isoType == freezed
          ? _value.isoType
          : isoType // ignore: cast_nullable_to_non_nullable
              as IsoType?,
      video3DFormat: video3DFormat == freezed
          ? _value.video3DFormat
          : video3DFormat // ignore: cast_nullable_to_non_nullable
              as Video3DFormat?,
      mediaStreams: mediaStreams == freezed
          ? _value._mediaStreams
          : mediaStreams // ignore: cast_nullable_to_non_nullable
              as List<MediaStream>,
      mediaAttachments: mediaAttachments == freezed
          ? _value._mediaAttachments
          : mediaAttachments // ignore: cast_nullable_to_non_nullable
              as List<MediaAttachment>,
      formats: formats == freezed
          ? _value._formats
          : formats // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bitrate: bitrate == freezed
          ? _value.bitrate
          : bitrate // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      requiredHttpHeaders: requiredHttpHeaders == freezed
          ? _value._requiredHttpHeaders
          : requiredHttpHeaders // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      transcodingUrl: transcodingUrl == freezed
          ? _value.transcodingUrl
          : transcodingUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      transcodingSubProtocol: transcodingSubProtocol == freezed
          ? _value.transcodingSubProtocol
          : transcodingSubProtocol // ignore: cast_nullable_to_non_nullable
              as String?,
      transcodingContainer: transcodingContainer == freezed
          ? _value.transcodingContainer
          : transcodingContainer // ignore: cast_nullable_to_non_nullable
              as String?,
      analyzeDurationMs: analyzeDurationMs == freezed
          ? _value.analyzeDurationMs
          : analyzeDurationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultAudioStreamIndex: defaultAudioStreamIndex == freezed
          ? _value.defaultAudioStreamIndex
          : defaultAudioStreamIndex // ignore: cast_nullable_to_non_nullable
              as int?,
      defaultSubtitleStreamIndex: defaultSubtitleStreamIndex == freezed
          ? _value.defaultSubtitleStreamIndex
          : defaultSubtitleStreamIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MediaSource implements _MediaSource {
  _$_MediaSource(
      {required this.protocol,
      this.id,
      this.path,
      this.encoderPath,
      this.encoderProtocol,
      required this.type,
      this.container,
      this.size,
      this.name,
      required this.isRemote,
      this.eTag,
      this.runTimeTicks,
      required this.readAtNativeFramerate,
      required this.ignoreDts,
      required this.ignoreIndex,
      required this.genPtsInput,
      required this.supportsTranscoding,
      required this.supportsDirectStream,
      required this.supportsDirectPlay,
      required this.isInfiniteStream,
      required this.requiresOpening,
      this.openToken,
      required this.requiresClosing,
      this.liveStreamId,
      this.bufferMs,
      required this.requiresLooping,
      required this.supportsProbing,
      this.videoType,
      this.isoType,
      this.video3DFormat,
      final List<MediaStream> mediaStreams = const <MediaStream>[],
      final List<MediaAttachment> mediaAttachments = const <MediaAttachment>[],
      final List<String> formats = const <String>[],
      this.bitrate,
      this.timestamp,
      final Map<String, String> requiredHttpHeaders = const <String, String>{},
      this.transcodingUrl,
      this.transcodingSubProtocol,
      this.transcodingContainer,
      this.analyzeDurationMs,
      this.defaultAudioStreamIndex,
      this.defaultSubtitleStreamIndex})
      : _mediaStreams = mediaStreams,
        _mediaAttachments = mediaAttachments,
        _formats = formats,
        _requiredHttpHeaders = requiredHttpHeaders;

  factory _$_MediaSource.fromJson(Map<String, dynamic> json) =>
      _$$_MediaSourceFromJson(json);

  @override
  final Protocol protocol;
  @override
  final String? id;
  @override
  final String? path;
  @override
  final String? encoderPath;
  @override
  final Protocol? encoderProtocol;
  @override
  final MediaSourceType type;
  @override
  final String? container;
  @override
  final int? size;
  @override
  final String? name;

  ///Gets or sets a value indicating whether the media is remote. Differentiate internet url vs local network.
  @override
  final bool isRemote;
  @override
  final String? eTag;
  @override
  final int? runTimeTicks;
  @override
  final bool readAtNativeFramerate;
  @override
  final bool ignoreDts;
  @override
  final bool ignoreIndex;
  @override
  final bool genPtsInput;
  @override
  final bool supportsTranscoding;
  @override
  final bool supportsDirectStream;
  @override
  final bool supportsDirectPlay;
  @override
  final bool isInfiniteStream;
  @override
  final bool requiresOpening;
  @override
  final String? openToken;
  @override
  final bool requiresClosing;
  @override
  final String? liveStreamId;
  @override
  final int? bufferMs;
  @override
  final bool requiresLooping;
  @override
  final bool supportsProbing;
  @override
  final VideoType? videoType;
  @override
  final IsoType? isoType;
  @override
  final Video3DFormat? video3DFormat;
  final List<MediaStream> _mediaStreams;
  @override
  @JsonKey()
  List<MediaStream> get mediaStreams {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaStreams);
  }

  final List<MediaAttachment> _mediaAttachments;
  @override
  @JsonKey()
  List<MediaAttachment> get mediaAttachments {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaAttachments);
  }

  final List<String> _formats;
  @override
  @JsonKey()
  List<String> get formats {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_formats);
  }

  @override
  final int? bitrate;
  @override
  final Timestamp? timestamp;
  final Map<String, String> _requiredHttpHeaders;
  @override
  @JsonKey()
  Map<String, String> get requiredHttpHeaders {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_requiredHttpHeaders);
  }

  @override
  final String? transcodingUrl;
  @override
  final String? transcodingSubProtocol;
  @override
  final String? transcodingContainer;
  @override
  final int? analyzeDurationMs;
  @override
  final int? defaultAudioStreamIndex;
  @override
  final int? defaultSubtitleStreamIndex;

  @override
  String toString() {
    return 'MediaSource(protocol: $protocol, id: $id, path: $path, encoderPath: $encoderPath, encoderProtocol: $encoderProtocol, type: $type, container: $container, size: $size, name: $name, isRemote: $isRemote, eTag: $eTag, runTimeTicks: $runTimeTicks, readAtNativeFramerate: $readAtNativeFramerate, ignoreDts: $ignoreDts, ignoreIndex: $ignoreIndex, genPtsInput: $genPtsInput, supportsTranscoding: $supportsTranscoding, supportsDirectStream: $supportsDirectStream, supportsDirectPlay: $supportsDirectPlay, isInfiniteStream: $isInfiniteStream, requiresOpening: $requiresOpening, openToken: $openToken, requiresClosing: $requiresClosing, liveStreamId: $liveStreamId, bufferMs: $bufferMs, requiresLooping: $requiresLooping, supportsProbing: $supportsProbing, videoType: $videoType, isoType: $isoType, video3DFormat: $video3DFormat, mediaStreams: $mediaStreams, mediaAttachments: $mediaAttachments, formats: $formats, bitrate: $bitrate, timestamp: $timestamp, requiredHttpHeaders: $requiredHttpHeaders, transcodingUrl: $transcodingUrl, transcodingSubProtocol: $transcodingSubProtocol, transcodingContainer: $transcodingContainer, analyzeDurationMs: $analyzeDurationMs, defaultAudioStreamIndex: $defaultAudioStreamIndex, defaultSubtitleStreamIndex: $defaultSubtitleStreamIndex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MediaSource &&
            const DeepCollectionEquality().equals(other.protocol, protocol) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.path, path) &&
            const DeepCollectionEquality()
                .equals(other.encoderPath, encoderPath) &&
            const DeepCollectionEquality()
                .equals(other.encoderProtocol, encoderProtocol) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.container, container) &&
            const DeepCollectionEquality().equals(other.size, size) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.isRemote, isRemote) &&
            const DeepCollectionEquality().equals(other.eTag, eTag) &&
            const DeepCollectionEquality()
                .equals(other.runTimeTicks, runTimeTicks) &&
            const DeepCollectionEquality()
                .equals(other.readAtNativeFramerate, readAtNativeFramerate) &&
            const DeepCollectionEquality().equals(other.ignoreDts, ignoreDts) &&
            const DeepCollectionEquality()
                .equals(other.ignoreIndex, ignoreIndex) &&
            const DeepCollectionEquality()
                .equals(other.genPtsInput, genPtsInput) &&
            const DeepCollectionEquality()
                .equals(other.supportsTranscoding, supportsTranscoding) &&
            const DeepCollectionEquality()
                .equals(other.supportsDirectStream, supportsDirectStream) &&
            const DeepCollectionEquality()
                .equals(other.supportsDirectPlay, supportsDirectPlay) &&
            const DeepCollectionEquality()
                .equals(other.isInfiniteStream, isInfiniteStream) &&
            const DeepCollectionEquality()
                .equals(other.requiresOpening, requiresOpening) &&
            const DeepCollectionEquality().equals(other.openToken, openToken) &&
            const DeepCollectionEquality()
                .equals(other.requiresClosing, requiresClosing) &&
            const DeepCollectionEquality()
                .equals(other.liveStreamId, liveStreamId) &&
            const DeepCollectionEquality().equals(other.bufferMs, bufferMs) &&
            const DeepCollectionEquality()
                .equals(other.requiresLooping, requiresLooping) &&
            const DeepCollectionEquality()
                .equals(other.supportsProbing, supportsProbing) &&
            const DeepCollectionEquality().equals(other.videoType, videoType) &&
            const DeepCollectionEquality().equals(other.isoType, isoType) &&
            const DeepCollectionEquality()
                .equals(other.video3DFormat, video3DFormat) &&
            const DeepCollectionEquality()
                .equals(other._mediaStreams, _mediaStreams) &&
            const DeepCollectionEquality()
                .equals(other._mediaAttachments, _mediaAttachments) &&
            const DeepCollectionEquality().equals(other._formats, _formats) &&
            const DeepCollectionEquality().equals(other.bitrate, bitrate) &&
            const DeepCollectionEquality().equals(other.timestamp, timestamp) &&
            const DeepCollectionEquality()
                .equals(other._requiredHttpHeaders, _requiredHttpHeaders) &&
            const DeepCollectionEquality()
                .equals(other.transcodingUrl, transcodingUrl) &&
            const DeepCollectionEquality()
                .equals(other.transcodingSubProtocol, transcodingSubProtocol) &&
            const DeepCollectionEquality()
                .equals(other.transcodingContainer, transcodingContainer) &&
            const DeepCollectionEquality()
                .equals(other.analyzeDurationMs, analyzeDurationMs) &&
            const DeepCollectionEquality().equals(
                other.defaultAudioStreamIndex, defaultAudioStreamIndex) &&
            const DeepCollectionEquality().equals(
                other.defaultSubtitleStreamIndex, defaultSubtitleStreamIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(protocol),
        const DeepCollectionEquality().hash(id),
        const DeepCollectionEquality().hash(path),
        const DeepCollectionEquality().hash(encoderPath),
        const DeepCollectionEquality().hash(encoderProtocol),
        const DeepCollectionEquality().hash(type),
        const DeepCollectionEquality().hash(container),
        const DeepCollectionEquality().hash(size),
        const DeepCollectionEquality().hash(name),
        const DeepCollectionEquality().hash(isRemote),
        const DeepCollectionEquality().hash(eTag),
        const DeepCollectionEquality().hash(runTimeTicks),
        const DeepCollectionEquality().hash(readAtNativeFramerate),
        const DeepCollectionEquality().hash(ignoreDts),
        const DeepCollectionEquality().hash(ignoreIndex),
        const DeepCollectionEquality().hash(genPtsInput),
        const DeepCollectionEquality().hash(supportsTranscoding),
        const DeepCollectionEquality().hash(supportsDirectStream),
        const DeepCollectionEquality().hash(supportsDirectPlay),
        const DeepCollectionEquality().hash(isInfiniteStream),
        const DeepCollectionEquality().hash(requiresOpening),
        const DeepCollectionEquality().hash(openToken),
        const DeepCollectionEquality().hash(requiresClosing),
        const DeepCollectionEquality().hash(liveStreamId),
        const DeepCollectionEquality().hash(bufferMs),
        const DeepCollectionEquality().hash(requiresLooping),
        const DeepCollectionEquality().hash(supportsProbing),
        const DeepCollectionEquality().hash(videoType),
        const DeepCollectionEquality().hash(isoType),
        const DeepCollectionEquality().hash(video3DFormat),
        const DeepCollectionEquality().hash(_mediaStreams),
        const DeepCollectionEquality().hash(_mediaAttachments),
        const DeepCollectionEquality().hash(_formats),
        const DeepCollectionEquality().hash(bitrate),
        const DeepCollectionEquality().hash(timestamp),
        const DeepCollectionEquality().hash(_requiredHttpHeaders),
        const DeepCollectionEquality().hash(transcodingUrl),
        const DeepCollectionEquality().hash(transcodingSubProtocol),
        const DeepCollectionEquality().hash(transcodingContainer),
        const DeepCollectionEquality().hash(analyzeDurationMs),
        const DeepCollectionEquality().hash(defaultAudioStreamIndex),
        const DeepCollectionEquality().hash(defaultSubtitleStreamIndex)
      ]);

  @JsonKey(ignore: true)
  @override
  _$$_MediaSourceCopyWith<_$_MediaSource> get copyWith =>
      __$$_MediaSourceCopyWithImpl<_$_MediaSource>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MediaSourceToJson(this);
  }
}

abstract class _MediaSource implements MediaSource {
  factory _MediaSource(
      {required final Protocol protocol,
      final String? id,
      final String? path,
      final String? encoderPath,
      final Protocol? encoderProtocol,
      required final MediaSourceType type,
      final String? container,
      final int? size,
      final String? name,
      required final bool isRemote,
      final String? eTag,
      final int? runTimeTicks,
      required final bool readAtNativeFramerate,
      required final bool ignoreDts,
      required final bool ignoreIndex,
      required final bool genPtsInput,
      required final bool supportsTranscoding,
      required final bool supportsDirectStream,
      required final bool supportsDirectPlay,
      required final bool isInfiniteStream,
      required final bool requiresOpening,
      final String? openToken,
      required final bool requiresClosing,
      final String? liveStreamId,
      final int? bufferMs,
      required final bool requiresLooping,
      required final bool supportsProbing,
      final VideoType? videoType,
      final IsoType? isoType,
      final Video3DFormat? video3DFormat,
      final List<MediaStream> mediaStreams,
      final List<MediaAttachment> mediaAttachments,
      final List<String> formats,
      final int? bitrate,
      final Timestamp? timestamp,
      final Map<String, String> requiredHttpHeaders,
      final String? transcodingUrl,
      final String? transcodingSubProtocol,
      final String? transcodingContainer,
      final int? analyzeDurationMs,
      final int? defaultAudioStreamIndex,
      final int? defaultSubtitleStreamIndex}) = _$_MediaSource;

  factory _MediaSource.fromJson(Map<String, dynamic> json) =
      _$_MediaSource.fromJson;

  @override
  Protocol get protocol;
  @override
  String? get id;
  @override
  String? get path;
  @override
  String? get encoderPath;
  @override
  Protocol? get encoderProtocol;
  @override
  MediaSourceType get type;
  @override
  String? get container;
  @override
  int? get size;
  @override
  String? get name;
  @override

  ///Gets or sets a value indicating whether the media is remote. Differentiate internet url vs local network.
  bool get isRemote;
  @override
  String? get eTag;
  @override
  int? get runTimeTicks;
  @override
  bool get readAtNativeFramerate;
  @override
  bool get ignoreDts;
  @override
  bool get ignoreIndex;
  @override
  bool get genPtsInput;
  @override
  bool get supportsTranscoding;
  @override
  bool get supportsDirectStream;
  @override
  bool get supportsDirectPlay;
  @override
  bool get isInfiniteStream;
  @override
  bool get requiresOpening;
  @override
  String? get openToken;
  @override
  bool get requiresClosing;
  @override
  String? get liveStreamId;
  @override
  int? get bufferMs;
  @override
  bool get requiresLooping;
  @override
  bool get supportsProbing;
  @override
  VideoType? get videoType;
  @override
  IsoType? get isoType;
  @override
  Video3DFormat? get video3DFormat;
  @override
  List<MediaStream> get mediaStreams;
  @override
  List<MediaAttachment> get mediaAttachments;
  @override
  List<String> get formats;
  @override
  int? get bitrate;
  @override
  Timestamp? get timestamp;
  @override
  Map<String, String> get requiredHttpHeaders;
  @override
  String? get transcodingUrl;
  @override
  String? get transcodingSubProtocol;
  @override
  String? get transcodingContainer;
  @override
  int? get analyzeDurationMs;
  @override
  int? get defaultAudioStreamIndex;
  @override
  int? get defaultSubtitleStreamIndex;
  @override
  @JsonKey(ignore: true)
  _$$_MediaSourceCopyWith<_$_MediaSource> get copyWith =>
      throw _privateConstructorUsedError;
}
