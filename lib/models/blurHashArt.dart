class BlurHashArt {
  BlurHashArt({
    required this.art,
  });

  Map<String, String> art;

  factory BlurHashArt.fromMap(Map<String, dynamic> json) => BlurHashArt(
        art: json['Art'],
      );

  Map<String, dynamic> toMap() => {
        'Art': art,
      };
}
