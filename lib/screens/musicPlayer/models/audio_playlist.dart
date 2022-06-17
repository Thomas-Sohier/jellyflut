import 'package:jellyflut/screens/musicPlayer/models/audio_source.dart';

class AudioPlaylist {
  final List<AudioSource> _audioSources;

  const AudioPlaylist({required audioSources}) : _audioSources = audioSources;

  List<AudioSource> get getPlaylist => _audioSources;

  void insert(AudioSource audioSource) {
    _audioSources.add(audioSource);
  }

  void remove(AudioSource audioSource) {
    _audioSources.remove(audioSource);
  }

  void removeAt(int index) {
    _audioSources.removeAt(index);
  }

  void move(int currentIndex, int newIndex) {
    _audioSources.insert(newIndex, _audioSources.removeAt(currentIndex));
  }

  void clear() {
    _audioSources.clear();
  }
}
