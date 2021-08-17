class Backdrop {
  Backdrop({
    required this.backdrop,
  });

  Map<String, String> backdrop;

  factory Backdrop.fromMap(Map<String, String> json) => Backdrop(
        backdrop: json,
      );
}
