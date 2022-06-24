class Codec {
  Codec({
    required this.mimeType,
    required this.codec,
    required this.isAudio,
    required this.profiles,
    required this.levels,
    required this.maxBitrate,
    required this.maxChannels,
    required this.maxSampleRate,
  });

  String mimeType;
  String codec;
  bool isAudio;
  List<String> profiles;
  List<int> levels;
  int maxBitrate;
  int? maxChannels;
  int? maxSampleRate;

  factory Codec.fromMap(Map<String, dynamic> json) => Codec(
        mimeType: json['mimeType'],
        codec: json['codec'],
        isAudio: json['isAudio'],
        profiles: List<String>.from(json['profiles'].map((x) => x)),
        levels: List<int>.from(json['levels'].map((x) => x)),
        maxBitrate: json['maxBitrate'],
        maxChannels: json['maxChannels'],
        maxSampleRate: json['maxSampleRate'],
      );

  Map<String, dynamic> toMap() => {
        'mimeType': mimeType,
        'codec': codec,
        'isAudio': isAudio,
        'profiles': List<dynamic>.from(profiles.map((x) => x)),
        'levels': List<dynamic>.from(levels.map((x) => x)),
        'maxBitrate': maxBitrate,
        'maxChannels': maxChannels,
        'maxSampleRate': maxSampleRate,
      };
}
