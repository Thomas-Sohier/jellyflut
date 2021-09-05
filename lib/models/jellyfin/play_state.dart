class PlayState {
  PlayState({
    required this.canSeek,
    required this.isPaused,
    required this.isMuted,
    required this.repeatMode,
  });

  bool canSeek;
  bool isPaused;
  bool isMuted;
  String repeatMode;

  factory PlayState.fromMap(Map<String, dynamic> json) => PlayState(
        canSeek: json['CanSeek'],
        isPaused: json['IsPaused'],
        isMuted: json['IsMuted'],
        repeatMode: json['RepeatMode'],
      );

  Map<String, dynamic> toMap() => {
        'CanSeek': canSeek,
        'IsPaused': isPaused,
        'IsMuted': isMuted,
        'RepeatMode': repeatMode,
      };
}
