class SubtitleProfile {
  const SubtitleProfile({
    required this.format,
    required this.method,
  });

  final String format;
  final String method;

  factory SubtitleProfile.fromMap(Map<String, dynamic> json) => SubtitleProfile(
        format: json['Format'],
        method: json['Method'],
      );

  Map<String, dynamic> toMap() => {
        'Format': format,
        'Method': method,
      };
}
