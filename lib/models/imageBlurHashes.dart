class ImageBlurHashes {
  ImageBlurHashes({
    this.backdrop,
    this.primary,
    this.art,
    this.banner,
    this.logo,
    this.thumb,
  });

  Map<String, dynamic> backdrop;
  Map<String, dynamic> primary;
  Map<String, dynamic> art;
  Map<String, dynamic> banner;
  Map<String, dynamic> logo;
  Map<String, dynamic> thumb;

  factory ImageBlurHashes.fromMap(Map<String, dynamic> json) => ImageBlurHashes(
        backdrop: json["Backdrop"] == null ? null : json["Backdrop"],
        primary: json["Primary"] == null ? null : json["Primary"],
        art: json["Art"] == null ? null : json["Art"],
        banner: json["Banner"] == null ? null : json["Banner"],
        logo: json["Logo"] == null ? null : json["Logo"],
        thumb: json["Thumb"] == null ? null : json["Thumb"],
      );

  Map<String, dynamic> toMap() => {
        "Backdrop": backdrop,
        "Primary": primary,
        "Art": art,
        "Banner": banner,
        "Logo": logo,
        "Thumb": thumb
      };
}
