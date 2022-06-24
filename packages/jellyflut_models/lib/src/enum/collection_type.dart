enum CollectionType {
  BOOKS('Books'),
  BOXSETS('BoxSets'),
  HOMEVIDEOS('HomeVideos'),
  MIXED('Mixed'),
  MOVIES('Movies'),
  MUSIC('Music'),
  MUSICVIDEOS('MusicVideos'),
  TVSHOWS('TvShows'),
  LIVETV('LiveTv');

  final String value;
  const CollectionType(this.value);

  static CollectionType fromString(String value) {
    return CollectionType.values
        .firstWhere((type) => type.value.toLowerCase() == value.toLowerCase());
  }
}
