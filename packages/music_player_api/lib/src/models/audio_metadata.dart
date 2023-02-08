import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

import 'uint8list_converter.dart';

part 'audio_metadata.freezed.dart';
part 'audio_metadata.g.dart';

@Freezed()
class AudioMetadata with _$AudioMetadata {
  const AudioMetadata._();

  factory AudioMetadata(
      {String? album,
      required String artist,
      required String title,
      String? artworkUrl,
      @Uint8ListConverter() required Uint8List artworkByte,
      required Item item}) = _AudioMetadata;

  factory AudioMetadata.fromJson(Map<String, Object?> json) => _$AudioMetadataFromJson(json);
}
