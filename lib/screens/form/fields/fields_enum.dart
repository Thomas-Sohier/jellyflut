enum FieldsEnum {
  AIRDAYS('AirDays', 'Air days', true),
  AIRTIME('AirTime', 'Air time', true),
  AIRSAFTERSEASONNUMBER('AirsAfterSeasonNumber', 'airsAfterSeasonNumber', false),
  AIRSBEFOREEPISODENUMBER('AirsBeforeEpisodeNumber', 'airsBeforeEpisodeNumber', false),
  AIRSBEFORESEASONNUMBER('AirsBeforeSeasonNumber', 'airsBeforeSeasonNumber', false),
  ALBUM('Album', 'Album', true),
  ALBUMARTISTS('AlbumArtists', 'Alnum artists', false),
  ARTISTITEMS('ArtistItems', 'Artists', false),
  ASPECTRATIO('AspectRatio', 'Aspect ratio', false),
  BACKGROUNDCOLOR('BackgroundColor', 'Background color', false),
  COMMUNITYRATING('CommunityRating', 'Community rating', true),
  CRITICRATING('CriticRating', 'Critic rating', true),
  CUSTOMRATING('CustomRating', 'Custom rating', true),
  DATEADDED('DateAdded', 'Date added', true),
  DATECREATED('DateCreated', 'Date created', true),
  DISPLAYORDER('DisplayOrder', 'Display order', false),
  ENDDATE('EndDate', 'End date', true),
  FONTSIZE('FontSize', 'Font size', false),
  FONTCOLOR('FontColor', 'Font color', false),
  FORCEDSORTNAME('ForcedSortName', 'Forced sort name', false),
  GENRES('Genres', 'Genres', true),
  GENREITEMS('GenreItems', 'Genre items', false),
  ID('Id', 'Id', true),
  INDEXNUMBER('IndexNumber', 'Index number', false),
  LOCKDATA('LockData', 'Lock data', false),
  LOCKEDFIELDS('LockedFields', 'Locked fields', false),
  NAME('Name', 'Name', true),
  OFFICIALRATING('OfficialRating', 'Official rating', true),
  ORIGINALTITLE('OriginalTitle', 'Original title', false),
  OVERVIEW('Overview', 'Overview', false),
  PARENTINDEXNUMBER('ParentIndexNumber', 'Parent index number', false),
  PEOPLE('People', 'People', false),
  PREFERREDMETADATACOUNTRYCODE('PreferredMetadataCountryCode', 'Preferred metadata country code', false),
  PREFERREDMETADATALANGUAGE('PreferredMetadataLanguage', 'preferredMetadataLanguage', false),
  PREMIEREDATE('PremiereDate', 'Premiere date', true),
  PRODUCTIONYEAR('ProductionYear', 'Production year', true),
  PROVIDERIDS('ProviderIds', 'Provider Ids', false),
  STATUS('Status', 'Status', true),
  STUDIOS('Studios', 'Studios', false),
  TAGLINES('Taglines', 'Taglines', false),
  TAGS('Tags', 'Tags', false),
  VIDEO3DFORMAT('Video3DFormat', 'Video 3D format', false);

  final String fieldName;
  final String fullName;
  final bool sortable;

  const FieldsEnum(this.fieldName, this.fullName, this.sortable);

  static List<FieldsEnum> getSortable() {
    return FieldsEnum.values.where((field) => field.sortable).toList();
  }
}
