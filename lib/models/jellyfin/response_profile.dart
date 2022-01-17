class ResponseProfile {
  ResponseProfile({
    required this.type,
    required this.container,
    required this.mimeType,
  });

  String type;
  String container;
  String mimeType;

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
