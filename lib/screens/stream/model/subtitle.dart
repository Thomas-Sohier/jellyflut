class Subtitle {
  Subtitle(
      {required this.index, this.jellyfinSubtitleIndex, required this.name});

  int index;
  int? jellyfinSubtitleIndex;
  String name;

  Map<String, dynamic> toMap() => {
        'Index': index,
        'JellyfinSubtitleIndex': jellyfinSubtitleIndex,
        'Name': name,
      };
}
