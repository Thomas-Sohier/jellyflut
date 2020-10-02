class PlayState {
  PlayState({
    this.canSeek,
    this.isPaused,
    this.isMuted,
    this.repeatMode,
  });

  bool canSeek;
  bool isPaused;
  bool isMuted;
  String repeatMode;

  factory PlayState.fromMap(Map<String, dynamic> json) => PlayState(
        canSeek: json["CanSeek"],
        isPaused: json["IsPaused"],
        isMuted: json["IsMuted"],
        repeatMode: json["RepeatMode"],
      );

  Map<String, dynamic> toMap() => {
        "CanSeek": canSeek,
        "IsPaused": isPaused,
        "IsMuted": isMuted,
        "RepeatMode": repeatMode,
      };
}
