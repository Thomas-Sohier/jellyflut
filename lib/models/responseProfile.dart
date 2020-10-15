class ResponseProfile {
  ResponseProfile({
    this.type,
    this.container,
    this.mimeType,
  });

  Type type;
  String container;
  String mimeType;

  factory ResponseProfile.fromMap(Map<String, dynamic> json) => ResponseProfile(
        type: json["Type"] == null ? null : json["Type"],
        container: json["Container"] == null ? null : json["Container"],
        mimeType: json["MimeType"] == null ? null : json["MimeType"],
      );

  Map<String, dynamic> toMap() => {
        "Type": type == null ? null : type,
        "Container": container == null ? null : container,
        "MimeType": mimeType == null ? null : mimeType,
      };
}
