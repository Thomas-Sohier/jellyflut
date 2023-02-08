class TranscodingProfile {
  const TranscodingProfile({
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

  final String? container;
  final String? type;
  final String? audioCodec;
  final String? context;
  final String? protocol;
  final String? maxAudioChannels;
  final int? minSegments;
  final bool? breakOnNonKeyFrames;
  final String? videoCodec;

  factory TranscodingProfile.fromMap(Map<String, dynamic> json) => TranscodingProfile(
        container: json['Container'],
        type: json['Type'],
        audioCodec: json['AudioCodec'],
        context: json['Context'],
        protocol: json['Protocol'],
        maxAudioChannels: json['MaxAudioChannels'],
        minSegments: json['MinSegments'],
        breakOnNonKeyFrames: json['BreakOnNonKeyFrames'],
        videoCodec: json['VideoCodec'],
      );

  Map<String, dynamic> toMap() => {
        if (container != null) 'Container': container,
        if (type != null) 'Type': type,
        if (audioCodec != null) 'AudioCodec': audioCodec,
        if (context != null) 'Context': context,
        if (protocol != null) 'Protocol': protocol,
        if (maxAudioChannels != null) 'MaxAudioChannels': maxAudioChannels,
        if (minSegments != null) 'MinSegments': minSegments,
        if (breakOnNonKeyFrames != null) 'BreakOnNonKeyFrames': breakOnNonKeyFrames,
        if (videoCodec != null) 'VideoCodec': videoCodec,
      };
}
