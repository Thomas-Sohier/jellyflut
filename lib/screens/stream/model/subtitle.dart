import 'media_type.dart';

class Subtitle {
  Subtitle(
      {required this.index,
      this.jellyfinSubtitleIndex,
      required this.mediaType,
      required this.name});

  int index;
  int? jellyfinSubtitleIndex;
  MediaType mediaType;
  String name;

  Map<String, dynamic> toMap() => {
        'Index': index,
        'JellyfinSubtitleIndex': jellyfinSubtitleIndex,
        'MediaType': mediaType,
        'Name': name,
      };
}
