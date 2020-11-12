class DirectPlayProfile {
  DirectPlayProfile({
    this.container,
    this.type,
    this.videoCodec,
    this.audioCodec,
  });

  String container;
  String type;
  String videoCodec;
  String audioCodec;

  factory DirectPlayProfile.fromMap(Map<String, dynamic> json) =>
      DirectPlayProfile(
        container: json['Container'] == null ? null : json['Container'],
        type: json['Type'] == null ? null : json['Type'],
        videoCodec: json['VideoCodec'] == null ? null : json['VideoCodec'],
        audioCodec: json['AudioCodec'] == null ? null : json['AudioCodec'],
      );

  Map<String, dynamic> toMap() => {
        if (container != null)
          'Container': container == null ? null : container,
        if (type != null) 'Type': type == null ? null : type,
        if (videoCodec != null)
          'VideoCodec': videoCodec == null ? null : videoCodec,
        if (audioCodec != null)
          'AudioCodec': audioCodec == null ? null : audioCodec,
      };
}
