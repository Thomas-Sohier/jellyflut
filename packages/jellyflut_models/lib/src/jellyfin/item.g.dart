// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Item _$$_ItemFromJson(Map<String, dynamic> json) => _$_Item(
      id: json['Id'] as String,
      originalTitle: json['OriginalTitle'] as String?,
      name: json['Name'] as String?,
      serverId: json['ServerId'] as String?,
      etag: json['Etag'] as String?,
      sourceType: json['SourceType'] as String?,
      playlistItemId: json['PlaylistItemId'] as String?,
      dateCreated: json['DateCreated'] == null
          ? null
          : DateTime.parse(json['DateCreated'] as String),
      dateLastMediaAdded: json['DateLastMediaAdded'] == null
          ? null
          : DateTime.parse(json['DateLastMediaAdded'] as String),
      extraType: json['ExtraType'] as String?,
      airsBeforeSeasonNumber: json['AirsBeforeSeasonNumber'] as int?,
      airsAfterSeasonNumber: json['AirsAfterSeasonNumber'] as int?,
      airsBeforeEpisodeNumber: json['AirsBeforeEpisodeNumber'] as int?,
      canDelete: json['CanDelete'] as bool?,
      canDownload: json['CanDownload'] as bool?,
      hasSubtitles: json['HasSubtitles'] as bool?,
      preferredMetadataLanguage: json['PreferredMetadataLanguage'] as String?,
      preferredMetadataCountryCode:
          json['PreferredMetadataCountryCode'] as String?,
      supportsSync: json['SupportsSync'] as bool?,
      container: json['Container'] as String?,
      sortName: json['SortName'] as String?,
      forcedSortName: json['ForcedSortName'] as String?,
      video3DFormat:
          $enumDecodeNullable(_$Video3DFormatEnumMap, json['Video3DFormat']),
      premiereDate: json['PremiereDate'] == null
          ? null
          : DateTime.parse(json['PremiereDate'] as String),
      externalUrls: (json['ExternalUrls'] as List<dynamic>?)
              ?.map((e) => ExternalUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ExternalUrl>[],
      mediaSources: (json['MediaSources'] as List<dynamic>?)
              ?.map((e) => MediaSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaSource>[],
      criticRating: json['CriticRating'] as int?,
      productionLocations: (json['ProductionLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      path: json['Path'] as String?,
      enableMediaSourceDisplay: json['EnableMediaSourceDisplay'] as bool?,
      officialRating: json['OfficialRating'] as String?,
      customRating: json['CustomRating'] as String?,
      channelId: json['ChannelId'] as String?,
      channelName: json['ChannelName'] as String?,
      overview: json['Overview'] as String?,
      taglines: (json['Taglines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      genres: (json['Genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      communityRating: (json['CommunityRating'] as num?)?.toDouble(),
      cumulativeRunTimeTicks:
          (json['CumulativeRunTimeTicks'] as num?)?.toDouble(),
      runTimeTicks: (json['RunTimeTicks'] as num?)?.toDouble(),
      playAccess: $enumDecodeNullable(_$PlayAccessEnumMap, json['PlayAccess']),
      aspectRatio: json['AspectRatio'] as String?,
      productionYear: json['ProductionYear'] as int?,
      isPlaceHolder: json['IsPlaceHolder'] as bool?,
      number: json['Number'] as String?,
      channelNumber: json['ChannelNumber'] as String?,
      indexNumber: json['IndexNumber'] as int?,
      indexNumberEnd: json['IndexNumberEnd'] as int?,
      parentIndexNumber: json['ParentIndexNumber'] as int?,
      remoteTrailers: (json['RemoteTrailers'] as List<dynamic>?)
              ?.map((e) => MediaUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaUrl>[],
      providerIds: (json['ProviderIds'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      isHD: json['IsHD'] as bool?,
      isFolder: json['IsFolder'] as bool?,
      parentId: json['ParentId'] as String?,
      type: $enumDecode(_$ItemTypeEnumMap, json['Type']),
      people: (json['People'] as List<dynamic>?)
              ?.map((e) => People.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <People>[],
      studios: (json['Studios'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      genreItems: (json['GenreItems'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      parentLogoItemId: json['ParentLogoItemId'] as String?,
      parentBackdropItemId: json['ParentBackdropItemId'] as String?,
      parentBackdropImageTags:
          (json['ParentBackdropImageTags'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const <String>[],
      localTrailerCount: json['LocalTrailerCount'] as int?,
      userData: json['UserData'] == null
          ? null
          : UserData.fromJson(json['UserData'] as Map<String, dynamic>),
      recursiveItemCount: json['RecursiveItemCount'] as int?,
      childCount: json['ChildCount'] as int?,
      seriesName: json['SeriesName'] as String?,
      seriesId: json['SeriesId'] as String?,
      seasonId: json['SeasonId'] as String?,
      specialFeatureCount: json['SpecialFeatureCount'] as int?,
      displayPreferencesId: json['DisplayPreferencesId'] as String?,
      status: json['Status'] as String?,
      airTime: json['AirTime'] as String?,
      airDays: (json['AirDays'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DayOfWeekEnumMap, e))
              .toList() ??
          const <DayOfWeek>[],
      tags:
          (json['Tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      primaryImageAspectRatio:
          (json['PrimaryImageAspectRatio'] as num?)?.toDouble(),
      artists: (json['Artists'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      artistItems: (json['ArtistItems'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      album: json['Album'] as String?,
      collectionType:
          $enumDecodeNullable(_$CollectionTypeEnumMap, json['CollectionType']),
      displayOrder: json['DisplayOrder'] as String?,
      albumId: json['AlbumId'] as String?,
      albumPrimaryImageTag: json['AlbumPrimaryImageTag'] as String?,
      seriesPrimaryImageTag: json['SeriesPrimaryImageTag'] as String?,
      albumArtist: json['AlbumArtist'] as String?,
      albumArtists: (json['AlbumArtists'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      seasonName: json['SeasonName'] as String?,
      mediaStreams: (json['MediaStreams'] as List<dynamic>?)
              ?.map((e) => MediaStream.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaStream>[],
      videoType: $enumDecodeNullable(_$VideoTypeEnumMap, json['VideoType']),
      partCount: json['PartCount'] as int?,
      mediaSourceCount: json['MediaSourceCount'] as int?,
      imageTags: (json['ImageTags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      backdropImageTags: (json['BackdropImageTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      screenshotImageTags: (json['ScreenshotImageTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      parentLogoImageTag: json['ParentLogoImageTag'] as String?,
      parentArtItemId: json['ParentArtItemId'] as String?,
      parentArtImageTag: json['ParentArtImageTag'] as String?,
      seriesThumbImageTag: json['SeriesThumbImageTag'] as String?,
      imageBlurHashes: json['ImageBlurHashes'] == null
          ? null
          : ImageBlurHashes.fromJson(
              json['ImageBlurHashes'] as Map<String, dynamic>),
      seriesStudio: json['SeriesStudio'] as String?,
      parentThumbItemId: json['ParentThumbItemId'] as String?,
      parentThumbImageTag: json['ParentThumbImageTag'] as String?,
      parentPrimaryImageItemId: json['ParentPrimaryImageItemId'] as String?,
      parentPrimaryImageTag: json['ParentPrimaryImageTag'] as String?,
      chapters: (json['Chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Chapter>[],
      locationType:
          $enumDecodeNullable(_$LocationTypeEnumMap, json['LocationType']),
      isoType: $enumDecodeNullable(_$IsoTypeEnumMap, json['IsoType']),
      mediaType: json['MediaType'] as String?,
      endDate: json['EndDate'] == null
          ? null
          : DateTime.parse(json['EndDate'] as String),
      lockedFields: (json['LockedFields'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MetaDataFieldEnumMap, e))
              .toList() ??
          const <MetaDataField>[],
      trailerCount: json['TrailerCount'] as int?,
      movieCount: json['MovieCount'] as int?,
      seriesCount: json['SeriesCount'] as int?,
      programCount: json['ProgramCount'] as int?,
      episodeCount: json['EpisodeCount'] as int?,
      songCount: json['SongCount'] as int?,
      albumCount: json['AlbumCount'] as int?,
      artistCount: json['ArtistCount'] as int?,
      musicVideoCount: json['MusicVideoCount'] as int?,
      lockData: json['LockData'] as bool?,
      width: json['Width'] as int?,
      height: json['Height'] as int?,
      cameraMake: json['CameraMake'] as String?,
      cameraModel: json['CameraModel'] as String?,
      software: json['Software'] as String?,
      exposureTime: json['ExposureTime'] as int?,
      focalLength: json['FocalLength'] as int?,
      imageOrientation: json['ImageOrientation'] as String?,
      aperture: json['Aperture'] as int?,
      shutterSpeed: json['ShutterSpeed'] as int?,
      latitude: json['Latitude'] as int?,
      longitude: json['Longitude'] as int?,
      altitude: json['Altitude'] as int?,
      isoSpeedRating: json['IsoSpeedRating'] as int?,
      seriesTimerId: json['SeriesTimerId'] as String?,
      programId: json['ProgramId'] as String?,
      channelPrimaryImageTag: json['ChannelPrimaryImageTag'] as String?,
      startDate: json['StartDate'] == null
          ? null
          : DateTime.parse(json['StartDate'] as String),
      completionPercentage: json['CompletionPercentage'] as int?,
      isRepeat: json['IsRepeat'] as bool?,
      episodeTitle: json['EpisodeTitle'] as String?,
      channelType:
          $enumDecodeNullable(_$ChannelTypeEnumMap, json['ChannelType']),
      audio: $enumDecodeNullable(_$AudioEnumMap, json['Audio']),
      isMovie: json['IsMovie'] as bool?,
      isSports: json['IsSports'] as bool?,
      isSeries: json['IsSeries'] as bool?,
      isLive: json['IsLive'] as bool?,
      isNews: json['IsNews'] as bool?,
      isKids: json['IsKids'] as bool?,
      isPremiere: json['IsPremiere'] as bool?,
      timerId: json['TimerId'] as String?,
      currentProgram: json['CurrentProgram'] as String?,
    );

Map<String, dynamic> _$$_ItemToJson(_$_Item instance) {
  final val = <String, dynamic>{
    'Id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('OriginalTitle', instance.originalTitle);
  writeNotNull('Name', instance.name);
  writeNotNull('ServerId', instance.serverId);
  writeNotNull('Etag', instance.etag);
  writeNotNull('SourceType', instance.sourceType);
  writeNotNull('PlaylistItemId', instance.playlistItemId);
  writeNotNull('DateCreated', instance.dateCreated?.toIso8601String());
  writeNotNull(
      'DateLastMediaAdded', instance.dateLastMediaAdded?.toIso8601String());
  writeNotNull('ExtraType', instance.extraType);
  writeNotNull('AirsBeforeSeasonNumber', instance.airsBeforeSeasonNumber);
  writeNotNull('AirsAfterSeasonNumber', instance.airsAfterSeasonNumber);
  writeNotNull('AirsBeforeEpisodeNumber', instance.airsBeforeEpisodeNumber);
  writeNotNull('CanDelete', instance.canDelete);
  writeNotNull('CanDownload', instance.canDownload);
  writeNotNull('HasSubtitles', instance.hasSubtitles);
  writeNotNull('PreferredMetadataLanguage', instance.preferredMetadataLanguage);
  writeNotNull(
      'PreferredMetadataCountryCode', instance.preferredMetadataCountryCode);
  writeNotNull('SupportsSync', instance.supportsSync);
  writeNotNull('Container', instance.container);
  writeNotNull('SortName', instance.sortName);
  writeNotNull('ForcedSortName', instance.forcedSortName);
  writeNotNull('Video3DFormat', _$Video3DFormatEnumMap[instance.video3DFormat]);
  writeNotNull('PremiereDate', instance.premiereDate?.toIso8601String());
  val['ExternalUrls'] = instance.externalUrls;
  val['MediaSources'] = instance.mediaSources;
  writeNotNull('CriticRating', instance.criticRating);
  val['ProductionLocations'] = instance.productionLocations;
  writeNotNull('Path', instance.path);
  writeNotNull('EnableMediaSourceDisplay', instance.enableMediaSourceDisplay);
  writeNotNull('OfficialRating', instance.officialRating);
  writeNotNull('CustomRating', instance.customRating);
  writeNotNull('ChannelId', instance.channelId);
  writeNotNull('ChannelName', instance.channelName);
  writeNotNull('Overview', instance.overview);
  val['Taglines'] = instance.taglines;
  val['Genres'] = instance.genres;
  writeNotNull('CommunityRating', instance.communityRating);
  writeNotNull('CumulativeRunTimeTicks', instance.cumulativeRunTimeTicks);
  writeNotNull('RunTimeTicks', instance.runTimeTicks);
  writeNotNull('PlayAccess', _$PlayAccessEnumMap[instance.playAccess]);
  writeNotNull('AspectRatio', instance.aspectRatio);
  writeNotNull('ProductionYear', instance.productionYear);
  writeNotNull('IsPlaceHolder', instance.isPlaceHolder);
  writeNotNull('Number', instance.number);
  writeNotNull('ChannelNumber', instance.channelNumber);
  writeNotNull('IndexNumber', instance.indexNumber);
  writeNotNull('IndexNumberEnd', instance.indexNumberEnd);
  writeNotNull('ParentIndexNumber', instance.parentIndexNumber);
  val['RemoteTrailers'] = instance.remoteTrailers;
  val['ProviderIds'] = instance.providerIds;
  writeNotNull('IsHD', instance.isHD);
  writeNotNull('IsFolder', instance.isFolder);
  writeNotNull('ParentId', instance.parentId);
  val['Type'] = _$ItemTypeEnumMap[instance.type]!;
  val['People'] = instance.people;
  val['Studios'] = instance.studios;
  val['GenreItems'] = instance.genreItems;
  writeNotNull('ParentLogoItemId', instance.parentLogoItemId);
  writeNotNull('ParentBackdropItemId', instance.parentBackdropItemId);
  val['ParentBackdropImageTags'] = instance.parentBackdropImageTags;
  writeNotNull('LocalTrailerCount', instance.localTrailerCount);
  writeNotNull('UserData', instance.userData);
  writeNotNull('RecursiveItemCount', instance.recursiveItemCount);
  writeNotNull('ChildCount', instance.childCount);
  writeNotNull('SeriesName', instance.seriesName);
  writeNotNull('SeriesId', instance.seriesId);
  writeNotNull('SeasonId', instance.seasonId);
  writeNotNull('SpecialFeatureCount', instance.specialFeatureCount);
  writeNotNull('DisplayPreferencesId', instance.displayPreferencesId);
  writeNotNull('Status', instance.status);
  writeNotNull('AirTime', instance.airTime);
  val['AirDays'] = instance.airDays.map((e) => _$DayOfWeekEnumMap[e]!).toList();
  val['Tags'] = instance.tags;
  writeNotNull('PrimaryImageAspectRatio', instance.primaryImageAspectRatio);
  val['Artists'] = instance.artists;
  val['ArtistItems'] = instance.artistItems;
  writeNotNull('Album', instance.album);
  writeNotNull(
      'CollectionType', _$CollectionTypeEnumMap[instance.collectionType]);
  writeNotNull('DisplayOrder', instance.displayOrder);
  writeNotNull('AlbumId', instance.albumId);
  writeNotNull('AlbumPrimaryImageTag', instance.albumPrimaryImageTag);
  writeNotNull('SeriesPrimaryImageTag', instance.seriesPrimaryImageTag);
  writeNotNull('AlbumArtist', instance.albumArtist);
  val['AlbumArtists'] = instance.albumArtists;
  writeNotNull('SeasonName', instance.seasonName);
  val['MediaStreams'] = instance.mediaStreams;
  writeNotNull('VideoType', _$VideoTypeEnumMap[instance.videoType]);
  writeNotNull('PartCount', instance.partCount);
  writeNotNull('MediaSourceCount', instance.mediaSourceCount);
  val['ImageTags'] = instance.imageTags;
  val['BackdropImageTags'] = instance.backdropImageTags;
  val['ScreenshotImageTags'] = instance.screenshotImageTags;
  writeNotNull('ParentLogoImageTag', instance.parentLogoImageTag);
  writeNotNull('ParentArtItemId', instance.parentArtItemId);
  writeNotNull('ParentArtImageTag', instance.parentArtImageTag);
  writeNotNull('SeriesThumbImageTag', instance.seriesThumbImageTag);
  writeNotNull('ImageBlurHashes', instance.imageBlurHashes);
  writeNotNull('SeriesStudio', instance.seriesStudio);
  writeNotNull('ParentThumbItemId', instance.parentThumbItemId);
  writeNotNull('ParentThumbImageTag', instance.parentThumbImageTag);
  writeNotNull('ParentPrimaryImageItemId', instance.parentPrimaryImageItemId);
  writeNotNull('ParentPrimaryImageTag', instance.parentPrimaryImageTag);
  val['Chapters'] = instance.chapters;
  writeNotNull('LocationType', _$LocationTypeEnumMap[instance.locationType]);
  writeNotNull('IsoType', _$IsoTypeEnumMap[instance.isoType]);
  writeNotNull('MediaType', instance.mediaType);
  writeNotNull('EndDate', instance.endDate?.toIso8601String());
  val['LockedFields'] =
      instance.lockedFields.map((e) => _$MetaDataFieldEnumMap[e]!).toList();
  writeNotNull('TrailerCount', instance.trailerCount);
  writeNotNull('MovieCount', instance.movieCount);
  writeNotNull('SeriesCount', instance.seriesCount);
  writeNotNull('ProgramCount', instance.programCount);
  writeNotNull('EpisodeCount', instance.episodeCount);
  writeNotNull('SongCount', instance.songCount);
  writeNotNull('AlbumCount', instance.albumCount);
  writeNotNull('ArtistCount', instance.artistCount);
  writeNotNull('MusicVideoCount', instance.musicVideoCount);
  writeNotNull('LockData', instance.lockData);
  writeNotNull('Width', instance.width);
  writeNotNull('Height', instance.height);
  writeNotNull('CameraMake', instance.cameraMake);
  writeNotNull('CameraModel', instance.cameraModel);
  writeNotNull('Software', instance.software);
  writeNotNull('ExposureTime', instance.exposureTime);
  writeNotNull('FocalLength', instance.focalLength);
  writeNotNull('ImageOrientation', instance.imageOrientation);
  writeNotNull('Aperture', instance.aperture);
  writeNotNull('ShutterSpeed', instance.shutterSpeed);
  writeNotNull('Latitude', instance.latitude);
  writeNotNull('Longitude', instance.longitude);
  writeNotNull('Altitude', instance.altitude);
  writeNotNull('IsoSpeedRating', instance.isoSpeedRating);
  writeNotNull('SeriesTimerId', instance.seriesTimerId);
  writeNotNull('ProgramId', instance.programId);
  writeNotNull('ChannelPrimaryImageTag', instance.channelPrimaryImageTag);
  writeNotNull('StartDate', instance.startDate?.toIso8601String());
  writeNotNull('CompletionPercentage', instance.completionPercentage);
  writeNotNull('IsRepeat', instance.isRepeat);
  writeNotNull('EpisodeTitle', instance.episodeTitle);
  writeNotNull('ChannelType', _$ChannelTypeEnumMap[instance.channelType]);
  writeNotNull('Audio', _$AudioEnumMap[instance.audio]);
  writeNotNull('IsMovie', instance.isMovie);
  writeNotNull('IsSports', instance.isSports);
  writeNotNull('IsSeries', instance.isSeries);
  writeNotNull('IsLive', instance.isLive);
  writeNotNull('IsNews', instance.isNews);
  writeNotNull('IsKids', instance.isKids);
  writeNotNull('IsPremiere', instance.isPremiere);
  writeNotNull('TimerId', instance.timerId);
  writeNotNull('CurrentProgram', instance.currentProgram);
  return val;
}

const _$Video3DFormatEnumMap = {
  Video3DFormat.HalfSideBySide: 'HalfSideBySide',
  Video3DFormat.FullSideBySide: 'FullSideBySide',
  Video3DFormat.FullTopAndBottom: 'FullTopAndBottom',
  Video3DFormat.HalfTopAndBottom: 'HalfTopAndBottom',
  Video3DFormat.MVC: 'MVC',
};

const _$PlayAccessEnumMap = {
  PlayAccess.Full: 'Full',
  PlayAccess.None: 'None',
};

const _$ItemTypeEnumMap = {
  ItemType.AggregateFolder: 'AggregateFolder',
  ItemType.Audio: 'Audio',
  ItemType.AudioBook: 'AudioBook',
  ItemType.BasePluginFolder: 'BasePluginFolder',
  ItemType.Book: 'Book',
  ItemType.BoxSet: 'BoxSet',
  ItemType.Channel: 'Channel',
  ItemType.ChannelFolderItem: 'ChannelFolderItem',
  ItemType.CollectionFolder: 'CollectionFolder',
  ItemType.Episode: 'Episode',
  ItemType.Folder: 'Folder',
  ItemType.Genre: 'Genre',
  ItemType.ManualPlaylistsFolder: 'ManualPlaylistsFolder',
  ItemType.Movie: 'Movie',
  ItemType.LiveTvChannel: 'LiveTvChannel',
  ItemType.LiveTvProgram: 'LiveTvProgram',
  ItemType.MusicAlbum: 'MusicAlbum',
  ItemType.MusicArtist: 'MusicArtist',
  ItemType.MusicGenre: 'MusicGenre',
  ItemType.MusicVideo: 'MusicVideo',
  ItemType.Person: 'Person',
  ItemType.Photo: 'Photo',
  ItemType.PhotoAlbum: 'PhotoAlbum',
  ItemType.Playlist: 'Playlist',
  ItemType.PlaylistsFolder: 'PlaylistsFolder',
  ItemType.Program: 'Program',
  ItemType.Recording: 'Recording',
  ItemType.Season: 'Season',
  ItemType.Series: 'Series',
  ItemType.Studio: 'Studio',
  ItemType.Trailer: 'Trailer',
  ItemType.TvChannel: 'TvChannel',
  ItemType.TvProgram: 'TvProgram',
  ItemType.UserRootFolder: 'UserRootFolder',
  ItemType.UserView: 'UserView',
  ItemType.Video: 'Video',
  ItemType.Year: 'Year',
};

const _$DayOfWeekEnumMap = {
  DayOfWeek.Sunday: 'Sunday',
  DayOfWeek.Monday: 'Monday',
  DayOfWeek.Tuesday: 'Tuesday',
  DayOfWeek.Wednesday: 'Wednesday',
  DayOfWeek.Thursday: 'Thursday',
  DayOfWeek.Friday: 'Friday',
  DayOfWeek.Saturday: 'Saturday',
};

const _$CollectionTypeEnumMap = {
  CollectionType.movies: 'movies',
  CollectionType.tvshows: 'tvshows',
  CollectionType.music: 'music',
  CollectionType.musicvideos: 'musicvideos',
  CollectionType.livetv: 'livetv',
  CollectionType.homevideos: 'homevideos',
  CollectionType.boxsets: 'boxsets',
  CollectionType.books: 'books',
  CollectionType.mixed: 'mixed',
};

const _$VideoTypeEnumMap = {
  VideoType.VideoFile: 'VideoFile',
  VideoType.Iso: 'Iso',
  VideoType.Dvd: 'Dvd',
  VideoType.BluRay: 'BluRay',
};

const _$LocationTypeEnumMap = {
  LocationType.FileSystem: 'FileSystem',
  LocationType.Remote: 'Remote',
  LocationType.Virtual: 'Virtual',
  LocationType.Offline: 'Offline',
};

const _$IsoTypeEnumMap = {
  IsoType.Dvd: 'Dvd',
  IsoType.BluRay: 'BluRay',
};

const _$MetaDataFieldEnumMap = {
  MetaDataField.Cast: 'Cast',
  MetaDataField.Genres: 'Genres',
  MetaDataField.ProductionLocations: 'ProductionLocations',
  MetaDataField.Studios: 'Studios',
  MetaDataField.Tags: 'Tags',
  MetaDataField.Name: 'Name',
  MetaDataField.Overview: 'Overview',
  MetaDataField.Runtime: 'Runtime',
  MetaDataField.OfficialRating: 'OfficialRating',
};

const _$ChannelTypeEnumMap = {
  ChannelType.TV: 'TV',
  ChannelType.Radio: 'Radio',
};

const _$AudioEnumMap = {
  Audio.Mono: 'Mono',
  Audio.Stereo: 'Stereo',
  Audio.Dolby: 'Dolby',
  Audio.DolbyDigital: 'DolbyDigital',
  Audio.Thx: 'Thx',
  Audio.Atmos: 'Atmos',
};
