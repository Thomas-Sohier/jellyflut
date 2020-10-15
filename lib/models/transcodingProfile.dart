class TranscodingProfile {
  TranscodingProfile({
    this.container,
    this.type,
    this.audioCodec,
    this.context,
    this.protocol,
    this.maxAudioChannels,
    this.minSegments,
    this.breakOnNonKeyFrames,
    this.videoCodec,
  });

  String container;
  Type type;
  String audioCodec;
  String context;
  String protocol;
  String maxAudioChannels;
  String minSegments;
  bool breakOnNonKeyFrames;
  String videoCodec;

  factory TranscodingProfile.fromMap(Map<String, dynamic> json) =>
      TranscodingProfile(
        container: json["Container"] == null ? null : json["Container"],
        type: json["Type"] == null ? null : json["Type"],
        audioCodec: json["AudioCodec"] == null ? null : json["AudioCodec"],
        context: json["Context"] == null ? null : json["Context"],
        protocol: json["Protocol"] == null ? null : json["Protocol"],
        maxAudioChannels:
            json["MaxAudioChannels"] == null ? null : json["MaxAudioChannels"],
        minSegments: json["MinSegments"] == null ? null : json["MinSegments"],
        breakOnNonKeyFrames: json["BreakOnNonKeyFrames"] == null
            ? null
            : json["BreakOnNonKeyFrames"],
        videoCodec: json["VideoCodec"] == null ? null : json["VideoCodec"],
      );

  Map<String, dynamic> toMap() => {
        "Container": container == null ? null : container,
        "Type": type == null ? null : type,
        "AudioCodec": audioCodec == null ? null : audioCodec,
        "Context": context == null ? null : context,
        "Protocol": protocol == null ? null : protocol,
        "MaxAudioChannels": maxAudioChannels == null ? null : maxAudioChannels,
        "MinSegments": minSegments == null ? null : minSegments,
        "BreakOnNonKeyFrames":
            breakOnNonKeyFrames == null ? null : breakOnNonKeyFrames,
        "VideoCodec": videoCodec == null ? null : videoCodec,
      };
}
