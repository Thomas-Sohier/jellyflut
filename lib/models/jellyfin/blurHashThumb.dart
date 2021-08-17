class BlurHashThumb {
  BlurHashThumb({
    required this.thumb,
  });

  Map<String, String> thumb;

  factory BlurHashThumb.fromMap(Map<String, dynamic> json) => BlurHashThumb(
        thumb: json['Thumb'],
      );

  Map<String, dynamic> toMap() => {
        'Thumb': thumb,
      };
}
