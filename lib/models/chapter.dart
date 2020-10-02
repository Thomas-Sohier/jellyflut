class Chapter {
  Chapter({
    this.startPositionTicks,
    this.name,
    this.imageDateModified,
  });

  int startPositionTicks;
  String name;
  DateTime imageDateModified;

  factory Chapter.fromMap(Map<String, dynamic> json) => Chapter(
        startPositionTicks: json["StartPositionTicks"],
        name: json["Name"],
        imageDateModified: DateTime.parse(json["ImageDateModified"]),
      );

  Map<String, dynamic> toMap() => {
        "StartPositionTicks": startPositionTicks,
        "Name": name,
        "ImageDateModified": imageDateModified.toIso8601String(),
      };
}
