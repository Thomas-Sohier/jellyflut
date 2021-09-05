import 'enum_values.dart';

enum CollectionType {
  BOOKS,
  BOXSETS,
  HOMEVIDEOS,
  MIXED,
  MOVIES,
  MUSIC,
  MUSICVIDEOS,
  TVSHOWS
}

final collectionType = EnumValues({
  'Books': CollectionType.BOOKS,
  'BoxSets': CollectionType.BOXSETS,
  'HomeVideos': CollectionType.HOMEVIDEOS,
  'Mixed': CollectionType.MIXED,
  'Movies': CollectionType.MOVIES,
  'Music': CollectionType.MUSIC,
  'MusicVideos': CollectionType.MUSICVIDEOS,
  'TvShows': CollectionType.TVSHOWS,
});
