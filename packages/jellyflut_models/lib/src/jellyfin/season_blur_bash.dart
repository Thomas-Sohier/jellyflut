class SeasonImageBlurHashes {
  SeasonImageBlurHashes({
    this.backdrop,
    this.primary,
    this.art,
    this.banner,
    this.logo,
    this.thumb,
  });

  Map<String, dynamic>? backdrop;
  Map<String, dynamic>? primary;
  Map<String, dynamic>? art;
  Map<String, dynamic>? banner;
  Map<String, dynamic>? logo;
  Map<String, dynamic>? thumb;

  factory SeasonImageBlurHashes.fromMap(Map<String, dynamic> json) => SeasonImageBlurHashes(
        backdrop: json['Backdrop'],
        primary: json['Primary'],
        art: json['Art'],
        banner: json['Banner'],
        logo: json['Logo'],
        thumb: json['Thumb'],
      );

  Map<String, dynamic> toMap() =>
      {'Backdrop': backdrop, 'Primary': primary, 'Art': art, 'Banner': banner, 'Logo': logo, 'Thumb': thumb};
}
