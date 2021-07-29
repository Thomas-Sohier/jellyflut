class BlurHashPrimary {
  BlurHashPrimary({
    required this.primary,
  });

  Map<String, String> primary;

  factory BlurHashPrimary.fromMap(Map<String, dynamic> json) => BlurHashPrimary(
        primary: json['Primary'],
      );

  Map<String, dynamic> toMap() => {
        'Primary': primary,
      };
}
