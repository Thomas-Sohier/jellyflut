import 'package:freezed_annotation/freezed_annotation.dart';

import 'audio_source.dart';

part 'audio_playlist.freezed.dart';
part 'audio_playlist.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class AudioPlaylist with _$AudioPlaylist {
  const AudioPlaylist._();

  factory AudioPlaylist({
    required List<AudioSource> playlist,
  }) = _AudioPlaylist;

  factory AudioPlaylist.fromJson(Map<String, Object?> json) => _$AudioPlaylistFromJson(json);

  void add(AudioSource audioSource) => playlist.add(audioSource);

  void addAll(List<AudioSource> audioSources) => playlist.addAll(audioSources);

  void remove(AudioSource audioSource) => playlist.remove(audioSource);

  void removeAt(int index) => playlist.removeAt(index);

  void move(int currentIndex, int newIndex) {
    // _audioSources.insert(newIndex, _audioSources.removeAt(currentIndex));
    if (currentIndex < newIndex) {
      newIndex -= 1;
    }

    playlist.insert(newIndex, playlist.removeAt(currentIndex));
  }

  void clear() => playlist.clear();
}
