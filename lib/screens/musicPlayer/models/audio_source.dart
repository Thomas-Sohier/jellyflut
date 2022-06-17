import 'dart:io';

import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';

class AudioSource {
  final String resource;
  final AudioMetadata metadata;

  const AudioSource._({required this.resource, required this.metadata});

  /// Makes [AudioSource] object from a [File].
  factory AudioSource.file(File file, {required AudioMetadata metadata}) {
    return AudioSource._(resource: file.path, metadata: metadata);
  }

  /// Makes [AudioSource] object from url.
  factory AudioSource.network(Uri url, {required AudioMetadata metadata}) {
    return AudioSource._(resource: url.toString(), metadata: metadata);
  }
}
