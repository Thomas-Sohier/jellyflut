part of 'music_player_bloc.dart';

enum PlayingState {
  play,
  pause;

  static PlayingState fromBool(bool value) => value ? PlayingState.play : PlayingState.pause;
}

enum MusicPlayerStatus { stopped, loading, playing, failure }

@immutable
class MusicPlayerState extends Equatable {
  final ThemeData theme;
  final ScreenLayout screenLayout;
  final List<AudioSource> playlist;
  final AudioSource? currentlyPlaying;
  final PlayingState playingState;
  final Duration duration;
  final BehaviorSubject<Duration?> postionStream;
  final MusicPlayerStatus status;

  const MusicPlayerState(
      {required this.theme,
      required this.postionStream,
      this.duration = Duration.zero,
      this.currentlyPlaying,
      this.screenLayout = ScreenLayout.desktop,
      this.playlist = const <AudioSource>[],
      this.playingState = PlayingState.pause,
      this.status = MusicPlayerStatus.stopped});

  MusicPlayerState copyWith(
      {ThemeData? theme,
      ScreenLayout? screenLayout,
      Duration? duration,
      BehaviorSubject<Duration?>? postionStream,
      List<AudioSource>? playlist,
      AudioSource? currentlyPlaying,
      PlayingState? playingState,
      MusicPlayerStatus? status}) {
    return MusicPlayerState(
      theme: theme ?? this.theme,
      screenLayout: screenLayout ?? this.screenLayout,
      duration: duration ?? this.duration,
      postionStream: postionStream ?? this.postionStream,
      playlist: playlist ?? this.playlist,
      currentlyPlaying: currentlyPlaying ?? this.currentlyPlaying,
      playingState: playingState ?? this.playingState,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [theme, postionStream, duration, currentlyPlaying, screenLayout, playlist, playingState, status];
}
