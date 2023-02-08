class BlurHashBackdrop {
  BlurHashBackdrop({
    required this.backdrop,
  });

  Map<String, String> backdrop;

  factory BlurHashBackdrop.fromMap(Map<String, dynamic> json) => BlurHashBackdrop(
        backdrop: json['Backdrop'],
      );

  Map<String, dynamic> toMap() => {
        'Backdrop': backdrop,
      };
}
