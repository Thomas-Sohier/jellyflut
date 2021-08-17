class BlurHashLogo {
  BlurHashLogo({
    required this.logo,
  });

  Map<String, String> logo;

  factory BlurHashLogo.fromMap(Map<String, dynamic> json) => BlurHashLogo(
        logo: json['Logo'],
      );

  Map<String, dynamic> toMap() => {
        'Logo': logo,
      };
}
