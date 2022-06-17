import 'package:jellyflut/screens/musicPlayer/models/audio_metadata.dart';
import 'package:moor/moor.dart';

abstract class AudioSource {
  final AudioMetadata metadata;

  const AudioSource({required this.metadata});
}

class RemoteAudioSource extends AudioSource {
  final Uri uri;

  const RemoteAudioSource({required this.uri, required super.metadata});
}

class ByteAudioSource extends AudioSource {
  final Uint8List byte;

  const ByteAudioSource({required this.byte, required super.metadata});
}

class FileAudioSource extends AudioSource {
  final String path;

  const FileAudioSource({required this.path, required super.metadata});
}
