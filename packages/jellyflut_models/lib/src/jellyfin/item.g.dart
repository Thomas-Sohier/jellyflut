// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Item _$$_ItemFromJson(Map<String, dynamic> json) => _$_Item(
      id: json['id'] as String,
      originalTitle: json['originalTitle'] as String?,
      name: json['name'] as String?,
      serverId: json['serverId'] as String?,
      etag: json['etag'] as String?,
      sourceType: json['sourceType'] as String?,
      playlistItemId: json['playlistItemId'] as String?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      dateLastMediaAdded: json['dateLastMediaAdded'] == null
          ? null
          : DateTime.parse(json['dateLastMediaAdded'] as String),
      extraType: json['extraType'] as String?,
      airsBeforeSeasonNumber: json['airsBeforeSeasonNumber'] as int?,
      airsAfterSeasonNumber: json['airsAfterSeasonNumber'] as int?,
      airsBeforeEpisodeNumber: json['airsBeforeEpisodeNumber'] as int?,
      canDelete: json['canDelete'] as bool?,
      canDownload: json['canDownload'] as bool?,
      hasSubtitles: json['hasSubtitles'] as bool?,
      preferredMetadataLanguage: json['preferredMetadataLanguage'] as String?,
      preferredMetadataCountryCode:
          json['preferredMetadataCountryCode'] as String?,
      supportsSync: json['supportsSync'] as bool?,
      container: json['container'] as String?,
      sortName: json['sortName'] as String?,
      forcedSortName: json['forcedSortName'] as String?,
      video3DFormat:
          $enumDecodeNullable(_$Video3DFormatEnumMap, json['video3DFormat']),
      premiereDate: json['premiereDate'] == null
          ? null
          : DateTime.parse(json['premiereDate'] as String),
      externalUrls: (json['externalUrls'] as List<dynamic>?)
              ?.map((e) => ExternalUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ExternalUrl>[],
      mediaSources: (json['mediaSources'] as List<dynamic>?)
              ?.map((e) => MediaSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaSource>[],
      criticRating: json['criticRating'] as int?,
      productionLocations: (json['productionLocations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      path: json['path'] as String?,
      enableMediaSourceDisplay: json['enableMediaSourceDisplay'] as bool?,
      officialRating: json['officialRating'] as String?,
      customRating: json['customRating'] as String?,
      channelId: json['channelId'] as String?,
      channelName: json['channelName'] as String?,
      overview: json['overview'] as String?,
      taglines: (json['taglines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      communityRating: (json['communityRating'] as num?)?.toDouble(),
      cumulativeRunTimeTicks:
          (json['cumulativeRunTimeTicks'] as num?)?.toDouble(),
      runTimeTicks: (json['runTimeTicks'] as num?)?.toDouble(),
      playAccess: $enumDecodeNullable(_$PlayAccessEnumMap, json['playAccess']),
      aspectRatio: json['aspectRatio'] as String?,
      productionYear: json['productionYear'] as int?,
      isPlaceHolder: json['isPlaceHolder'] as bool?,
      number: json['number'] as String?,
      channelNumber: json['channelNumber'] as String?,
      indexNumber: json['indexNumber'] as int?,
      indexNumberEnd: json['indexNumberEnd'] as int?,
      parentIndexNumber: json['parentIndexNumber'] as int?,
      remoteTrailers: (json['remoteTrailers'] as List<dynamic>?)
              ?.map((e) => MediaUrl.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaUrl>[],
      providerIds: (json['providerIds'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      isHD: json['isHD'] as bool?,
      isFolder: json['isFolder'] as bool?,
      parentId: json['parentId'] as String?,
      type: $enumDecode(_$ItemTypeEnumMap, json['type']),
      people: (json['people'] as List<dynamic>?)
              ?.map((e) => People.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <People>[],
      studios: (json['studios'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      genreItems: (json['genreItems'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      parentLogoItemId: json['parentLogoItemId'] as String?,
      parentBackdropItemId: json['parentBackdropItemId'] as String?,
      parentBackdropImageTags:
          (json['parentBackdropImageTags'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const <String>[],
      localTrailerCount: json['localTrailerCount'] as int?,
      userData: json['userData'] == null
          ? null
          : UserData.fromJson(json['userData'] as Map<String, dynamic>),
      recursiveItemCount: json['recursiveItemCount'] as int?,
      childCount: json['childCount'] as int?,
      seriesName: json['seriesName'] as String?,
      seriesId: json['seriesId'] as String?,
      seasonId: json['seasonId'] as String?,
      specialFeatureCount: json['specialFeatureCount'] as int?,
      displayPreferencesId: json['displayPreferencesId'] as String?,
      status: json['status'] as String?,
      airTime: json['airTime'] as String?,
      airDays: (json['airDays'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$DayOfWeekEnumMap, e))
              .toList() ??
          const <DayOfWeek>[],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      primaryImageAspectRatio:
          (json['primaryImageAspectRatio'] as num?)?.toDouble(),
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      artistItems: (json['artistItems'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      album: json['album'] as String?,
      collectionType:
          $enumDecodeNullable(_$CollectionTypeEnumMap, json['collectionType']),
      displayOrder: json['displayOrder'] as String?,
      albumId: json['albumId'] as String?,
      albumPrimaryImageTag: json['albumPrimaryImageTag'] as String?,
      seriesPrimaryImageTag: json['seriesPrimaryImageTag'] as String?,
      albumArtist: json['albumArtist'] as String?,
      albumArtists: (json['albumArtists'] as List<dynamic>?)
              ?.map((e) => NamedGuidPair.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <NamedGuidPair>[],
      seasonName: json['seasonName'] as String?,
      mediaStreams: (json['mediaStreams'] as List<dynamic>?)
              ?.map((e) => MediaStream.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaStream>[],
      videoType: $enumDecodeNullable(_$VideoTypeEnumMap, json['videoType']),
      partCount: json['partCount'] as int?,
      mediaSourceCount: json['mediaSourceCount'] as int?,
      imageTags: (json['imageTags'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      backdropImageTags: (json['backdropImageTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      screenshotImageTags: (json['screenshotImageTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      parentLogoImageTag: json['parentLogoImageTag'] as String?,
      parentArtItemId: json['parentArtItemId'] as String?,
      parentArtImageTag: json['parentArtImageTag'] as String?,
      seriesThumbImageTag: json['seriesThumbImageTag'] as String?,
      imageBlurHashes: json['imageBlurHashes'] == null
          ? null
          : ImageBlurHashes.fromJson(
              json['imageBlurHashes'] as Map<String, dynamic>),
      seriesStudio: json['seriesStudio'] as String?,
      parentThumbItemId: json['parentThumbItemId'] as String?,
      parentThumbImageTag: json['parentThumbImageTag'] as String?,
      parentPrimaryImageItemId: json['parentPrimaryImageItemId'] as String?,
      parentPrimaryImageTag: json['parentPrimaryImageTag'] as String?,
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => Chapter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Chapter>[],
      locationType:
          $enumDecodeNullable(_$LocationTypeEnumMap, json['locationType']),
      isoType: $enumDecodeNullable(_$IsoTypeEnumMap, json['isoType']),
      mediaType: json['mediaType'] as String?,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      lockedFields: (json['lockedFields'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MetaDataFieldEnumMap, e))
              .toList() ??
          const <MetaDataField>[],
      trailerCount: json['trailerCount'] as int?,
      movieCount: json['movieCount'] as int?,
      seriesCount: json['seriesCount'] as int?,
      programCount: json['programCount'] as int?,
      episodeCount: json['episodeCount'] as int?,
      songCount: json['songCount'] as int?,
      albumCount: json['albumCount'] as int?,
      artistCount: json['artistCount'] as int?,
      musicVideoCount: json['musicVideoCount'] as int?,
      lockData: json['lockData'] as bool?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      cameraMake: json['cameraMake'] as String?,
      cameraModel: json['cameraModel'] as String?,
      software: json['software'] as String?,
      exposureTime: json['exposureTime'] as int?,
      focalLength: json['focalLength'] as int?,
      imageOrientation: json['imageOrientation'] as String?,
      aperture: json['aperture'] as int?,
      shutterSpeed: json['shutterSpeed'] as int?,
      latitude: json['latitude'] as int?,
      longitude: json['longitude'] as int?,
      altitude: json['altitude'] as int?,
      isoSpeedRating: json['isoSpeedRating'] as int?,
      seriesTimerId: json['seriesTimerId'] as String?,
      programId: json['programId'] as String?,
      channelPrimaryImageTag: json['channelPrimaryImageTag'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      completionPercentage: json['completionPercentage'] as int?,
      isRepeat: json['isRepeat'] as bool?,
      episodeTitle: json['episodeTitle'] as String?,
      channelType:
          $enumDecodeNullable(_$ChannelTypeEnumMap, json['channelType']),
      audio: $enumDecodeNullable(_$AudioEnumMap, json['audio']),
      isMovie: json['isMovie'] as bool?,
      isSports: json['isSports'] as bool?,
      isSeries: json['isSeries'] as bool?,
      isLive: json['isLive'] as bool?,
      isNews: json['isNews'] as bool?,
      isKids: json['isKids'] as bool?,
      isPremiere: json['isPremiere'] as bool?,
      timerId: json['timerId'] as String?,
      currentProgram: json['currentProgram'] as String?,
    );

Map<String, dynamic> _$$_ItemToJson(_$_Item instance) => <String, dynamic>{
      'id': instance.id,
      'originalTitle': instance.originalTitle,
      'name': instance.name,
      'serverId': instance.serverId,
      'etag': instance.etag,
      'sourceType': instance.sourceType,
      'playlistItemId': instance.playlistItemId,
      'dateCreated': instance.dateCreated?.toIso8601String(),
      'dateLastMediaAdded': instance.dateLastMediaAdded?.toIso8601String(),
      'extraType': instance.extraType,
      'airsBeforeSeasonNumber': instance.airsBeforeSeasonNumber,
      'airsAfterSeasonNumber': instance.airsAfterSeasonNumber,
      'airsBeforeEpisodeNumber': instance.airsBeforeEpisodeNumber,
      'canDelete': instance.canDelete,
      'canDownload': instance.canDownload,
      'hasSubtitles': instance.hasSubtitles,
      'preferredMetadataLanguage': instance.preferredMetadataLanguage,
      'preferredMetadataCountryCode': instance.preferredMetadataCountryCode,
      'supportsSync': instance.supportsSync,
      'container': instance.container,
      'sortName': instance.sortName,
      'forcedSortName': instance.forcedSortName,
      'video3DFormat': _$Video3DFormatEnumMap[instance.video3DFormat],
      'premiereDate': instance.premiereDate?.toIso8601String(),
      'externalUrls': instance.externalUrls,
      'mediaSources': instance.mediaSources,
      'criticRating': instance.criticRating,
      'productionLocations': instance.productionLocations,
      'path': instance.path,
      'enableMediaSourceDisplay': instance.enableMediaSourceDisplay,
      'officialRating': instance.officialRating,
      'customRating': instance.customRating,
      'channelId': instance.channelId,
      'channelName': instance.channelName,
      'overview': instance.overview,
      'taglines': instance.taglines,
      'genres': instance.genres,
      'communityRating': instance.communityRating,
      'cumulativeRunTimeTicks': instance.cumulativeRunTimeTicks,
      'runTimeTicks': instance.runTimeTicks,
      'playAccess': _$PlayAccessEnumMap[instance.playAccess],
      'aspectRatio': instance.aspectRatio,
      'productionYear': instance.productionYear,
      'isPlaceHolder': instance.isPlaceHolder,
      'number': instance.number,
      'channelNumber': instance.channelNumber,
      'indexNumber': instance.indexNumber,
      'indexNumberEnd': instance.indexNumberEnd,
      'parentIndexNumber': instance.parentIndexNumber,
      'remoteTrailers': instance.remoteTrailers,
      'providerIds': instance.providerIds,
      'isHD': instance.isHD,
      'isFolder': instance.isFolder,
      'parentId': instance.parentId,
      'type': _$ItemTypeEnumMap[instance.type]!,
      'people': instance.people,
      'studios': instance.studios,
      'genreItems': instance.genreItems,
      'parentLogoItemId': instance.parentLogoItemId,
      'parentBackdropItemId': instance.parentBackdropItemId,
      'parentBackdropImageTags': instance.parentBackdropImageTags,
      'localTrailerCount': instance.localTrailerCount,
      'userData': instance.userData,
      'recursiveItemCount': instance.recursiveItemCount,
      'childCount': instance.childCount,
      'seriesName': instance.seriesName,
      'seriesId': instance.seriesId,
      'seasonId': instance.seasonId,
      'specialFeatureCount': instance.specialFeatureCount,
      'displayPreferencesId': instance.displayPreferencesId,
      'status': instance.status,
      'airTime': instance.airTime,
      'airDays': instance.airDays.map((e) => _$DayOfWeekEnumMap[e]!).toList(),
      'tags': instance.tags,
      'primaryImageAspectRatio': instance.primaryImageAspectRatio,
      'artists': instance.artists,
      'artistItems': instance.artistItems,
      'album': instance.album,
      'collectionType': _$CollectionTypeEnumMap[instance.collectionType],
      'displayOrder': instance.displayOrder,
      'albumId': instance.albumId,
      'albumPrimaryImageTag': instance.albumPrimaryImageTag,
      'seriesPrimaryImageTag': instance.seriesPrimaryImageTag,
      'albumArtist': instance.albumArtist,
      'albumArtists': instance.albumArtists,
      'seasonName': instance.seasonName,
      'mediaStreams': instance.mediaStreams,
      'videoType': _$VideoTypeEnumMap[instance.videoType],
      'partCount': instance.partCount,
      'mediaSourceCount': instance.mediaSourceCount,
      'imageTags': instance.imageTags,
      'backdropImageTags': instance.backdropImageTags,
      'screenshotImageTags': instance.screenshotImageTags,
      'parentLogoImageTag': instance.parentLogoImageTag,
      'parentArtItemId': instance.parentArtItemId,
      'parentArtImageTag': instance.parentArtImageTag,
      'seriesThumbImageTag': instance.seriesThumbImageTag,
      'imageBlurHashes': instance.imageBlurHashes,
      'seriesStudio': instance.seriesStudio,
      'parentThumbItemId': instance.parentThumbItemId,
      'parentThumbImageTag': instance.parentThumbImageTag,
      'parentPrimaryImageItemId': instance.parentPrimaryImageItemId,
      'parentPrimaryImageTag': instance.parentPrimaryImageTag,
      'chapters': instance.chapters,
      'locationType': _$LocationTypeEnumMap[instance.locationType],
      'isoType': _$IsoTypeEnumMap[instance.isoType],
      'mediaType': instance.mediaType,
      'endDate': instance.endDate?.toIso8601String(),
      'lockedFields':
          instance.lockedFields.map((e) => _$MetaDataFieldEnumMap[e]!).toList(),
      'trailerCount': instance.trailerCount,
      'movieCount': instance.movieCount,
      'seriesCount': instance.seriesCount,
      'programCount': instance.programCount,
      'episodeCount': instance.episodeCount,
      'songCount': instance.songCount,
      'albumCount': instance.albumCount,
      'artistCount': instance.artistCount,
      'musicVideoCount': instance.musicVideoCount,
      'lockData': instance.lockData,
      'width': instance.width,
      'height': instance.height,
      'cameraMake': instance.cameraMake,
      'cameraModel': instance.cameraModel,
      'software': instance.software,
      'exposureTime': instance.exposureTime,
      'focalLength': instance.focalLength,
      'imageOrientation': instance.imageOrientation,
      'aperture': instance.aperture,
      'shutterSpeed': instance.shutterSpeed,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'isoSpeedRating': instance.isoSpeedRating,
      'seriesTimerId': instance.seriesTimerId,
      'programId': instance.programId,
      'channelPrimaryImageTag': instance.channelPrimaryImageTag,
      'startDate': instance.startDate?.toIso8601String(),
      'completionPercentage': instance.completionPercentage,
      'isRepeat': instance.isRepeat,
      'episodeTitle': instance.episodeTitle,
      'channelType': _$ChannelTypeEnumMap[instance.channelType],
      'audio': _$AudioEnumMap[instance.audio],
      'isMovie': instance.isMovie,
      'isSports': instance.isSports,
      'isSeries': instance.isSeries,
      'isLive': instance.isLive,
      'isNews': instance.isNews,
      'isKids': instance.isKids,
      'isPremiere': instance.isPremiere,
      'timerId': instance.timerId,
      'currentProgram': instance.currentProgram,
    };

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
