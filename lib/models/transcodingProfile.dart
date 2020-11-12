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
  String type;
  String audioCodec;
  String context;
  String protocol;
  String maxAudioChannels;
  int minSegments;
  bool breakOnNonKeyFrames;
  String videoCodec;

  factory TranscodingProfile.fromMap(Map<String, dynamic> json) =>
      TranscodingProfile(
        container: json['Container'] == null ? null : json['Container'],
        type: json['Type'] == null ? null : json['Type'],
        audioCodec: json['AudioCodec'] == null ? null : json['AudioCodec'],
        context: json['Context'] == null ? null : json['Context'],
        protocol: json['Protocol'] == null ? null : json['Protocol'],
        maxAudioChannels:
            json['MaxAudioChannels'] == null ? null : json['MaxAudioChannels'],
        minSegments: json['MinSegments'] == null ? null : json['MinSegments'],
        breakOnNonKeyFrames: json['BreakOnNonKeyFrames'] == null
            ? null
            : json['BreakOnNonKeyFrames'],
        videoCodec: json['VideoCodec'] == null ? null : json['VideoCodec'],
      );

  Map<String, dynamic> toMap() => {
        if (container != null)
          'Container': container == null ? null : container,
        if (type != null) 'Type': type == null ? null : type,
        if (audioCodec != null)
          'AudioCodec': audioCodec == null ? null : audioCodec,
        if (context != null) 'Context': context == null ? null : context,
        if (protocol != null) 'Protocol': protocol == null ? null : protocol,
        if (maxAudioChannels != null)
          'MaxAudioChannels':
              maxAudioChannels == null ? null : maxAudioChannels,
        if (minSegments != null)
          'MinSegments': minSegments == null ? null : minSegments,
        if (breakOnNonKeyFrames != null)
          'BreakOnNonKeyFrames': breakOnNonKeyFrames,
        if (videoCodec != null)
          'VideoCodec': videoCodec == null ? null : videoCodec,
      };
}
