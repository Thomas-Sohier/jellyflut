class ResponseProfile {
  const ResponseProfile({
    required this.type,
    required this.container,
    required this.mimeType,
  });

  final String type;
  final String container;
  final String mimeType;

  factory ResponseProfile.fromMap(Map<String, dynamic> json) => ResponseProfile(
        type: json['Type'],
        container: json['Container'],
        mimeType: json['MimeType'],
      );

  Map<String, dynamic> toMap() => {
        'Type': type,
        'Container': container,
        'MimeType': mimeType,
      };
}
