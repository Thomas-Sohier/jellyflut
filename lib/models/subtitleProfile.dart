class SubtitleProfile {
  SubtitleProfile({
    this.format,
    this.method,
  });

  String format;
  String method;

  factory SubtitleProfile.fromMap(Map<String, dynamic> json) => SubtitleProfile(
        format: json['Format'],
        method: json['Method'],
      );

  Map<String, dynamic> toMap() => {
        'Format': format,
        'Method': method,
      };
}
