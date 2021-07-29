class BlurHashBanner {
  BlurHashBanner({
    required this.banner,
  });

  Map<String, String> banner;

  factory BlurHashBanner.fromMap(Map<String, dynamic> json) => BlurHashBanner(
        banner: json['Banner'],
      );

  Map<String, dynamic> toMap() => {
        'Banner': banner,
      };
}
