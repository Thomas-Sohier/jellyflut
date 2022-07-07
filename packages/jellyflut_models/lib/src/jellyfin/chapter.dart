class Chapter {
  Chapter({
    required this.startPositionTicks,
    required this.name,
    required this.imageDateModified,
  });

  int startPositionTicks;
  String name;
  DateTime imageDateModified;

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        startPositionTicks: json['StartPositionTicks'],
        name: json['Name'],
        imageDateModified: DateTime.parse(json['ImageDateModified']),
      );

  Map<String, dynamic> toJson() => {
        'StartPositionTicks': startPositionTicks,
        'Name': name,
        'ImageDateModified': imageDateModified.toIso8601String(),
      };
}
