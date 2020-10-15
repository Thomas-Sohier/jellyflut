class DirectPlayProfile {
  DirectPlayProfile({
    this.container,
    this.type,
    this.videoCodec,
    this.audioCodec,
  });

  String container;
  Type type;
  String videoCodec;
  String audioCodec;

  factory DirectPlayProfile.fromMap(Map<String, dynamic> json) =>
      DirectPlayProfile(
        container: json["Container"] == null ? null : json["Container"],
        type: json["Type"] == null ? null : json["Type"],
        videoCodec: json["VideoCodec"] == null ? null : json["VideoCodec"],
        audioCodec: json["AudioCodec"] == null ? null : json["AudioCodec"],
      );

  Map<String, dynamic> toMap() => {
        "Container": container == null ? null : container,
        "Type": type == null ? null : type,
        "VideoCodec": videoCodec == null ? null : videoCodec,
        "AudioCodec": audioCodec == null ? null : audioCodec,
      };
}
