class UserData {
  UserData({
    this.playbackPositionTicks,
    this.playCount,
    this.isFavorite,
    this.lastPlayedDate,
    this.played,
    this.key,
  });

  int playbackPositionTicks;
  int playCount;
  bool isFavorite;
  DateTime lastPlayedDate;
  bool played;
  String key;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        playbackPositionTicks: json['PlaybackPositionTicks'],
        playCount: json['PlayCount'],
        isFavorite: json['IsFavorite'],
        lastPlayedDate: json['LastPlayedDate'] == null
            ? null
            : DateTime.parse(json['LastPlayedDate']),
        played: json['Played'],
        key: json['Key'],
      );

  Map<String, dynamic> toMap() => {
        'PlaybackPositionTicks': playbackPositionTicks,
        'PlayCount': playCount,
        'IsFavorite': isFavorite,
        'LastPlayedDate': lastPlayedDate.toIso8601String(),
        'Played': played,
        'Key': key,
      };
}
