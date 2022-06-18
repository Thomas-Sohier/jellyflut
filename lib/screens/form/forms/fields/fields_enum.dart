enum FieldsEnum {
  AIRDAYS('airDays', 'Air days', true),
  AIRTIME('airTime', 'Air time', true),
  AIRSAFTERSEASONNUMBER(
      'airsAfterSeasonNumber', 'airsAfterSeasonNumber', false),
  AIRSBEFOREEPISODENUMBER(
      'airsBeforeEpisodeNumber', 'airsBeforeEpisodeNumber', false),
  AIRSBEFORESEASONNUMBER(
      'airsBeforeSeasonNumber', 'airsBeforeSeasonNumber', false),
  ALBUM('album', 'Album', true),
  ALBUMARTISTS('albumArtists', 'Alnum artists', false),
  ARTISTITEMS('artistItems', 'Artists', false),
  ASPECTRATIO('aspectRatio', 'Aspect ratio', false),
  BACKGROUNDCOLOR('backgroundColor', 'Background color', false),
  COMMUNITYRATING('communityRating', 'Community rating', true),
  CRITICRATING('criticRating', 'Critic rating', true),
  CUSTOMRATING('customRating', 'Custom rating', true),
  DATEADDED('dateAdded', 'Date added', true),
  DATECREATED('dateCreated', 'Date created', true),
  DISPLAYORDER('displayOrder', 'Display order', false),
  ENDDATE('endDate', 'End date', true),
  FONTSIZE('fontSize', 'Font size', false),
  FONTCOLOR('fontColor', 'Font color', false),
  FORCEDSORTNAME('forcedSortName', 'Forced sort name', false),
  GENRES('genres', 'Genres', true),
  GENREITEMS('genreItems', 'Genre items', false),
  ID('id', 'Id', true),
  INDEXNUMBER('indexNumber', 'Index number', false),
  LOCKDATA('lockData', 'Lock data', false),
  LOCKEDFIELDS('lockedFields', 'Locked fields', false),
  NAME('name', 'Name', true),
  OFFICIALRATING('officialRating', 'Official rating', true),
  ORIGINALTITLE('originalTitle', 'Original title', false),
  OVERVIEW('overview', 'Overview', false),
  PARENTINDEXNUMBER('parentIndexNumber', 'Parent index number', false),
  PEOPLE('people', 'People', false),
  PREFERREDMETADATACOUNTRYCODE(
      'preferredMetadataCountryCode', 'Preferred metadata country code', false),
  PREFERREDMETADATALANGUAGE(
      'preferredMetadataLanguage', 'preferredMetadataLanguage', false),
  PREMIEREDATE('premiereDate', 'Premiere date', true),
  PRODUCTIONYEAR('productionYear', 'Production year', true),
  PROVIDERIDS('providerIds', 'Provider Ids', false),
  STATUS('status', 'Status', true),
  STUDIOS('studios', 'Studios', false),
  TAGLINES('taglines', 'Taglines', false),
  TAGS('tags', 'Tags', false),
  VIDEO3DFORMAT('video3DFormat', 'Video 3D format', false);

  final String fieldName;
  final String fullName;
  final bool sortable;

  const FieldsEnum(this.fieldName, this.fullName, this.sortable);

  static List<FieldsEnum> getSortable() {
    return FieldsEnum.values.where((field) => field.sortable).toList();
  }
}
