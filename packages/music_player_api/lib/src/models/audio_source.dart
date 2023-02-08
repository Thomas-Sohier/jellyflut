import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'audio_metadata.dart';
part 'audio_source.freezed.dart';
part 'audio_source.g.dart';

@Freezed()
class AudioSource with _$AudioSource {
  const AudioSource._();

  const factory AudioSource({
    required String resource,
    required AudioMetadata metadata,
  }) = _AudioSource;

  /// Makes [AudioSource] object from a [File].
  factory AudioSource.file(File file, {required AudioMetadata metadata}) {
    return AudioSource(resource: file.path, metadata: metadata);
  }

  /// Makes [AudioSource] object from url.
  factory AudioSource.network(Uri url, {required AudioMetadata metadata}) {
    return AudioSource(resource: url.toString(), metadata: metadata);
  }

  factory AudioSource.fromJson(Map<String, Object?> json) => _$AudioSourceFromJson(json);
}
