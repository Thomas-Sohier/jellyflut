class ImageTags {
  ImageTags({
    this.primary,
  });

  String? primary;

  factory ImageTags.fromMap(Map<String, dynamic> json) => ImageTags(
        primary: json['Primary'],
      );

  Map<String, dynamic> toMap() => {
        'Primary': primary,
      };
}
