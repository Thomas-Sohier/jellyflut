part of 'music_player_bloc.dart';

enum ScreenLayout {
  mobile,
  desktop;
}

@immutable
abstract class MusicPlayerEvent extends Equatable {
  const MusicPlayerEvent();

  @override
  List<Object> get props => [];
}

class PlaySongRequested extends MusicPlayerEvent {
  final Item item;
  const PlaySongRequested({required this.item});

  @override
  List<Object> get props => [item];
}

class PlayPlaylistRequested extends MusicPlayerEvent {
  final Item item;
  const PlayPlaylistRequested({required this.item});

  @override
  List<Object> get props => [item];
}

class StopRequested extends MusicPlayerEvent {}

class NextSongRequested extends MusicPlayerEvent {}

class PreviousSongRequested extends MusicPlayerEvent {}

class TogglePlayPauseRequested extends MusicPlayerEvent {}

class ReoderList extends MusicPlayerEvent {
  final int oldIndex;
  final int newIndex;

  const ReoderList({required this.oldIndex, required this.newIndex});

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class PlayAtIndex extends MusicPlayerEvent {
  final int index;

  const PlayAtIndex({required this.index});

  @override
  List<Object> get props => [index];
}

class DeleteAudioFromPlaylist extends MusicPlayerEvent {
  final int index;

  const DeleteAudioFromPlaylist({required this.index});

  @override
  List<Object> get props => [index];
}

class SeekRequested extends MusicPlayerEvent {
  final Duration position;

  const SeekRequested({required this.position});

  @override
  List<Object> get props => [position];
}

class LayoutChanged extends MusicPlayerEvent {
  final ScreenLayout screenLayout;

  const LayoutChanged({required this.screenLayout});

  @override
  List<Object> get props => [screenLayout];
}
