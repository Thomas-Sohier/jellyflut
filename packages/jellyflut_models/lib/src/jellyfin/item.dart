// To parse this JSON data, do
//
//     final media = itemFromMap(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';

import '../enum/index.dart';
import 'index.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@Freezed()
class Item with _$Item {
  const Item._();

  const factory Item(
      {required String id,
      String? name,
      String? originalTitle,
      String? serverId,
      String? etag,
      String? sourceType,
      String? playlistItemId,
      DateTime? dateCreated,
      DateTime? dateLastMediaAdded,
      String? extraType,
      int? airsBeforeSeasonNumber,
      int? airsAfterSeasonNumber,
      int? airsBeforeEpisodeNumber,
      bool? canDelete,
      bool? canDownload,
      bool? hasSubtitles,
      String? preferredMetadataLanguage,
      String? preferredMetadataCountryCode,
      bool? supportsSync,
      String? container,
      String? sortName,
      String? forcedSortName,
      Video3DFormat? video3DFormat,
      DateTime? premiereDate,
      @Default(<ExternalUrl>[]) List<ExternalUrl> externalUrls,
      @Default(<MediaSource>[]) List<MediaSource> mediaSources,
      int? criticRating,
      @Default(<String>[]) List<String> productionLocations,
      String? path,
      bool? enableMediaSourceDisplay,
      String? officialRating,
      String? customRating,
      String? channelId,
      String? channelName,
      String? overview,
      @Default(<String>[]) List<String> taglines,
      @Default(<String>[]) List<String> genres,
      double? communityRating,
      double? cumulativeRunTimeTicks,
      double? runTimeTicks,
      PlayAccess? playAccess,
      String? aspectRatio,
      int? productionYear,
      bool? isPlaceHolder,
      String? number,
      String? channelNumber,
      int? indexNumber,
      int? indexNumberEnd,
      int? parentIndexNumber,
      @Default(<MediaUrl>[]) List<MediaUrl> remoteTrailers,
      @Default(<String, String>{}) Map<String, String> providerIds,
      bool? isHD,
      bool? isFolder,
      String? parentId,
      required ItemType type,
      @Default(<People>[]) List<People> people,
      @Default(<NamedGuidPair>[]) List<NamedGuidPair> studios,
      @Default(<NamedGuidPair>[]) List<NamedGuidPair> genreItems,
      String? parentLogoItemId,
      String? parentBackdropItemId,
      @Default(<String>[]) List<String> parentBackdropImageTags,
      int? localTrailerCount,
      UserData? userData,
      int? recursiveItemCount,
      int? childCount,
      String? seriesName,
      String? seriesId,
      String? seasonId,
      int? specialFeatureCount,
      String? displayPreferencesId,
      String? status,
      String? airTime,
      @Default(<DayOfWeek>[]) List<DayOfWeek> airDays,
      @Default(<String>[]) List<String> tags,
      double? primaryImageAspectRatio,
      @Default(<String>[]) List<String> artists,
      @Default(<NamedGuidPair>[]) List<NamedGuidPair> artistItems,
      String? album,
      CollectionType? collectionType,
      String? displayOrder,
      String? albumId,
      String? albumPrimaryImageTag,
      String? seriesPrimaryImageTag,
      String? albumArtist,
      @Default(<NamedGuidPair>[]) List<NamedGuidPair> albumArtists,
      String? seasonName,
      @Default(<MediaStream>[]) List<MediaStream> mediaStreams,
      VideoType? videoType,
      int? partCount,
      int? mediaSourceCount,
      @Default(<String, String>{}) Map<String, String> imageTags,
      @Default(<String>[]) List<String> backdropImageTags,
      @Default(<String>[]) List<String> screenshotImageTags,
      String? parentLogoImageTag,
      String? parentArtItemId,
      String? parentArtImageTag,
      String? seriesThumbImageTag,
      ImageBlurHashes? imageBlurHashes,
      String? seriesStudio,
      String? parentThumbItemId,
      String? parentThumbImageTag,
      String? parentPrimaryImageItemId,
      String? parentPrimaryImageTag,
      @Default(<Chapter>[]) List<Chapter> chapters,
      LocationType? locationType,
      IsoType? isoType,
      String? mediaType,
      DateTime? endDate,
      @Default(<MetaDataField>[]) List<MetaDataField> lockedFields,
      int? trailerCount,
      int? movieCount,
      int? seriesCount,
      int? programCount,
      int? episodeCount,
      int? songCount,
      int? albumCount,
      int? artistCount,
      int? musicVideoCount,
      bool? lockData,
      int? width,
      int? height,
      String? cameraMake,
      String? cameraModel,
      String? software,
      int? exposureTime,
      int? focalLength,
      String? imageOrientation,
      int? aperture,
      int? shutterSpeed,
      int? latitude,
      int? longitude,
      int? altitude,
      int? isoSpeedRating,
      String? seriesTimerId,
      String? programId,
      String? channelPrimaryImageTag,
      DateTime? startDate,
      int? completionPercentage,
      bool? isRepeat,
      String? episodeTitle,
      ChannelType? channelType,
      Audio? audio,
      bool? isMovie,
      bool? isSports,
      bool? isSeries,
      bool? isLive,
      bool? isNews,
      bool? isKids,
      bool? isPremiere,
      String? timerId,
      String? currentProgram}) = _Item;

  factory Item.fromJson(Map<String, Object?> json) => _$ItemFromJson(json);

  ///Check if item is new
  ///
  /// Return [true] if is less than 3 days old
  /// Return [false] if date of creation is null or if more than 3 days old
  bool isNew() {
    if (dateCreated == null) {
      return false;
    }
    var difference = dateCreated!.difference(DateTime.now());
    return difference.inDays < -3 ? false : true;
  }

  ///Check if item has been played
  ///
  /// Return [true] if played
  /// Return [false] if is not played or [null]
  bool isPlayed() {
    if (userData != null) {
      return userData!.played;
    }
    return false;
  }

  ///Check if item has been played
  ///
  /// Return [true] if favorite
  /// Return [false] if is not favorite or [null]
  bool isFavorite() {
    if (userData != null) {
      return userData!.isFavorite;
    }
    return false;
  }

  ///Check if item has been played
  ///
  /// Return [true] if played
  /// Return [false] is is not played
  bool hasProgress() {
    if (userData?.playbackPositionTicks != null && userData!.playbackPositionTicks > 0) {
      return true;
    }
    return false;
  }

  bool hasGenres() {
    if (genres.isNotEmpty) return genres.isNotEmpty;
    return false;
  }

  bool hasArtists() {
    if (artists.isNotEmpty) return artists.isNotEmpty;
    return false;
  }

  bool hasOverview() {
    if (overview != null) return overview!.isNotEmpty;
    return false;
  }

  bool hasLogo() {
    if (imageBlurHashes?.logo != null) return imageBlurHashes!.logo!.isNotEmpty;
    return false;
  }

  bool hasPeople() {
    if (people.isNotEmpty) return people.isNotEmpty;
    return false;
  }

  /// Tell if current item is playable or can contains children which are playable
  /// Return [true] if item or children can be played
  /// Else return [false] if not playable
  bool isPlayableOrCanHavePlayableChilren() {
    final playableItems = [
      ItemType.Audio,
      ItemType.MusicAlbum,
      ItemType.MusicVideo,
      ItemType.TvChannel,
      ItemType.Movie,
      ItemType.Series,
      ItemType.Season,
      ItemType.Episode,
      ItemType.Book,
      ItemType.Video
    ];
    return playableItems.contains(type);
  }

  /// Tell if current item is playable (not like [isPlayableOrCanHavePlayableChilren()])
  /// Return [true] if item ocan be played
  /// Else return [false] if not playable
  bool isPlayable() {
    final playableItems = [
      ItemType.Movie,
      ItemType.Episode,
      ItemType.Photo,
      ItemType.Recording,
      ItemType.Video,
      ItemType.MusicVideo,
      ItemType.Audio,
      ItemType.Book,
      ItemType.Video
    ];
    return playableItems.contains(type);
  }

  bool isDownloable() {
    final playableItems = [
      ItemType.Audio,
      ItemType.MusicAlbum,
      ItemType.MusicVideo,
      ItemType.Movie,
      ItemType.Series,
      ItemType.Season,
      ItemType.Episode,
      ItemType.Book,
      ItemType.Video
    ];
    return playableItems.contains(type);
  }

  bool isCollectionPlayable() {
    final playableItems = [
      CollectionType.Books,
      CollectionType.HomeVideos,
      CollectionType.Movies,
      CollectionType.TvShows,
      CollectionType.MusicVideos,
      CollectionType.Music,
    ];
    return playableItems.contains(collectionType);
  }

  /// Tell if item have trailer available
  /// Check if remote trailers is not empty
  /// Do not call any remote API, only based on jellyfin datas
  ///
  /// Return [true] if have atleast one trailer
  /// Else return [false] if it doesn't have any trailers
  bool hasTrailer() {
    if (remoteTrailers.isNotEmpty || localTrailerCount != null) {
      return remoteTrailers.isNotEmpty ? remoteTrailers.isNotEmpty : localTrailerCount! > 0;
    }
    return false;
  }

  /// Tell if item can be viewed in sense of already played before
  /// Return [yes] if already seen (played)
  /// Else returl [false] if not seen (played)
  bool isViewable() {
    final playableItems = [
      ItemType.Movie,
      ItemType.Series,
      ItemType.Season,
      ItemType.Episode,
      ItemType.Book,
      ItemType.Video
    ];
    return playableItems.contains(type);
  }

  ///Check if original title is different from Localized title
  ///
  /// Return [true] if is different
  /// Return [false] if same
  bool haveDifferentOriginalTitle() {
    return originalTitle != null && originalTitle!.toLowerCase() != name?.toLowerCase();
  }

  /// Duration in microseconds from the item
  ///
  /// Return the [duration] if known
  /// Return [0] if not known
  int getDuration() {
    if (runTimeTicks == null) return 0;
    return (runTimeTicks! / 10).round();
  }

  /// Get item aspect ratio
  ///
  /// Return aspect ratio from video as [double] value
  /// If not specified return [16/9] as default value
  double getAspectRatio() {
    MediaStream mediaStream;
    if (mediaStreams.isNotEmpty && mediaStreams.isNotEmpty) {
      mediaStream = mediaStreams.firstWhere((element) => element.type == MediaStreamType.VIDEO);

      // If aspect ratio is specified then we use it
      // else we calculate it
      if (mediaStream.aspectRatio!.isNotEmpty) {
        return calculateAspectRatio(mediaStream.aspectRatio!);
      }
      return (mediaStream.width! / mediaStream.height!);
    }
    return 16 / 9;
  }

  /// Parse aspect ratio (jellyfin format) from string to double
  ///
  /// Return aspect ratio from video as [double] value
  /// If not specified return [0] as default value
  double calculateAspectRatio(String aspectRatio) {
    if (aspectRatio.isEmpty) return 0;
    var separatorIndex = aspectRatio.indexOf(':');
    var firstValue = double.parse(aspectRatio.substring(0, separatorIndex));
    var secondValue = double.parse(aspectRatio.substring(separatorIndex + 1, aspectRatio.length));
    return firstValue / secondValue;
  }

  /// Playback position last time played
  ///
  /// Return playback position in microsecond as [int]
  /// Return [0] if not specified
  int getPlaybackPosition() {
    if (userData != null) {
      return (userData!.playbackPositionTicks / 10).round();
    }
    return 0;
  }

  /// Percent of time played
  ///
  /// Return percent og time played as [double]
  /// Return [0] if not specified
  double getPercentPlayed() {
    if (userData != null || runTimeTicks != null) {
      return userData!.playbackPositionTicks / runTimeTicks!;
    }
    return 0;
  }

  /// Get primary image aspect ratio. Useful to show poster of item
  ///
  /// Return [double]
  ///
  /// Return [primaryImageAspectRatio] if defined
  /// Else return an aspect ratio based on type if not defined
  double getPrimaryAspectRatio({bool showParent = false}) {
    if (showParent) return parentAspectRatio(type: type);
    if (primaryImageAspectRatio != null) {
      if (primaryImageAspectRatio! > 0.0) {
        return primaryImageAspectRatio!;
      }
      return typeAspectRatio(type: type);
    }
    return typeAspectRatio(type: type);
  }

  double parentAspectRatio({ItemType? type}) {
    if (type == ItemType.MusicAlbum || type == ItemType.Audio) {
      return 1 / 1;
    } else if (type == ItemType.Photo) {
      return 4 / 3;
    } else if (type == ItemType.Episode) {
      return 2 / 3;
    } else if (type == ItemType.TvChannel || type == ItemType.TvProgram) {
      return 16 / 9;
    }
    return 2 / 3;
  }

  double typeAspectRatio({ItemType? type}) {
    if (type == ItemType.MusicAlbum || type == ItemType.Audio) {
      return 1 / 1;
    } else if (type == ItemType.Photo) {
      return 4 / 3;
    } else if (type == ItemType.Episode) {
      return 16 / 9;
    } else if (type == ItemType.TvChannel || type == ItemType.TvProgram) {
      return 16 / 9;
    }
    return 2 / 3;
  }

  /// Get id or parentid if primary image is not defined
  ///
  /// Return [String]
  ///
  /// Return id if type do not have parent
  /// Return parent id if there is no primary image set
  String getIdBasedOnImage() {
    if (type == ItemType.Season) {
      if (imageTags.isEmpty) return id;
      return seasonId ?? id;
    }
    return id;
  }

  /// Check if item have parents
  ///
  /// Return [bool]
  ///
  /// Return [true] if parents
  /// Return [false] is no parents found
  bool hasParent() {
    var hasSerieParent = seriesName != null ? seriesName!.isNotEmpty : false;
    var hasAlbumParent = albumId != null ? albumId!.isNotEmpty : false;
    var hasSeasonParent = seasonId != null ? seasonId!.isNotEmpty : false;
    return hasSerieParent || hasAlbumParent || hasSeasonParent;
  }

  String getParentId() {
    if (seriesId != null && seriesId!.isNotEmpty) return seriesId!;
    if (seasonId != null && seasonId!.isNotEmpty) return seasonId!;
    if (albumId != null && albumId!.isNotEmpty) return albumId!;
    return id;
  }

  /// Get parent name
  ///
  /// Return [String]
  ///
  /// Return parents name if not null
  /// ELse return empty string
  String parentName() {
    if (seriesName != null && seriesName!.isNotEmpty) return seriesName!;
    if (album != null && album!.isNotEmpty) return album!;
    return name ?? '';
  }

  /// Return the item file's extension
  /// Example : .cbz, .epub
  /// Can return [null]
  String getFileExtension() {
    if (path != null && path!.isNotEmpty) {
      final regexString = r'\.[0-9a-z]+$';
      final regExp = RegExp(regexString);
      final matches = regExp.allMatches(path ?? '');
      return matches.elementAt(0).group(0) ?? '';
    } else if (container != null && container!.isNotEmpty) {
      final fileExtension = container!.split(',').first;
      return '.$fileExtension';
    }
    throw 'Cannot find valid extension for current file';
  }

  /// Get collection type such as requested by API
  ///
  /// Return [String]
  ///
  /// Return correct collection type based on item one
  /// If nothing found then return current one
  List<ItemType> getCollectionType() {
    if (collectionType == CollectionType.Movies) {
      return [ItemType.Movie];
    } else if (collectionType == CollectionType.TvShows) {
      return [ItemType.Series];
    } else if (collectionType == CollectionType.Music) {
      return [ItemType.MusicAlbum, ItemType.Audio];
    } else if (collectionType == CollectionType.Books) {
      return [ItemType.Book];
    } else if (collectionType == CollectionType.HomeVideos) {
      return [ItemType.Video];
    } else if (collectionType == CollectionType.BoxSets) {
      return [ItemType.BoxSet];
    } else if (collectionType == CollectionType.Mixed) {
      return [
        ItemType.Folder,
        ItemType.Audio,
        ItemType.Video,
        ItemType.Book,
        ItemType.MusicAlbum,
        ItemType.Series,
        ItemType.Movie
      ];
    } else if (collectionType == CollectionType.MusicVideos) {
      return [ItemType.MusicVideo];
    } else {
      return [];
    }
  }

  /// Get correct image id based on searchType
  ///
  /// Return [String]
  ///
  /// Return id as [String] if found
  /// Else return item's id as [String]
  String correctImageId({ImageType searchType = ImageType.PRIMARY}) {
    // If of type logo we return only parent logo
    if (searchType == ImageType.LOGO) {
      switch (type) {
        case ItemType.Season:
        case ItemType.Episode:
          return seriesId ?? id;
        case ItemType.MusicAlbum:
          return albumId ?? id;
        default:
          return id;
      }
    }
    switch (type) {
      case ItemType.Episode:
        return id;
      case ItemType.Season:
        return seriesId ?? id;
      case ItemType.MusicAlbum:
      case ItemType.Audio:
        return albumId ?? id;
      default:
        return id;
    }
  }

  /// Get correct image tags based on searchType
  ///
  /// Return [String]
  ///
  /// Return imageTag as [String] if found
  /// Else return [null]
  String? correctImageTags({ImageType searchType = ImageType.PRIMARY}) {
    // If of type logo we return only parent logo
    if (searchType == ImageType.LOGO) {
      switch (type) {
        case ItemType.Season:
        case ItemType.Episode:
        case ItemType.Series:
          return seriesPrimaryImageTag;
        case ItemType.MusicAlbum:
          return albumPrimaryImageTag;
        default:
          return null;
      }
    } else if (imageTags.isNotEmpty) {
      switch (type) {
        case ItemType.Season:
          return seriesPrimaryImageTag;
        case ItemType.MusicAlbum:
        case ItemType.Audio:
          return albumPrimaryImageTag;
        default:
          return getImageTagBySearchType(searchType: searchType);
      }
    }
    return null;
  }

  String? getImageTagBySearchType({ImageType searchType = ImageType.PRIMARY}) {
    return imageTags.isNotEmpty ? imageTags[searchType] : null;
  }

  /// Get correct image tags based on searchType
  ///
  /// Return [String]
  ///
  /// Return imageTag as [String] if found
  /// Else return [null]
  ImageType correctImageType({ImageType searchType = ImageType.PRIMARY}) {
    // If we search correct image type for a logo that do not exist we still
    //return a logo tag and not a primary one as backup (or it will be ugly)
    late final backupSearchType;
    if (searchType == ImageType.LOGO) {
      backupSearchType = ImageType.LOGO;
    } else {
      backupSearchType = ImageType.PRIMARY;
    }

    // If of type logo we return only parent logo
    if (searchType == ImageType.BACKDROP && backdropImageTags.isNotEmpty) {
      return searchType;
    } else if (imageTags.isNotEmpty) {
      return getImageTypeBySearchTypeOrBackup(searchType: searchType, backupSearchType: backupSearchType);
    }
    return searchType;
  }

  ImageType getImageTypeBySearchTypeOrBackup(
      {ImageType searchType = ImageType.PRIMARY, required ImageType backupSearchType}) {
    if (imageTags.containsKey(searchType)) {
      return ImageType.fromString(searchType.name);
    }
    return backupSearchType;
  }

  /// Play current item given context
  ///
  /// If Book open Epub reader
  /// If Video open video player
  /// If music play it and show music button
  Future<void> playItem() {
    // var musicProvider = MusicProvider();
    // if (type == ItemType.EPISODE ||
    //     type == ItemType.SEASON ||
    //     type == ItemType.SERIES ||
    //     type == ItemType.MOVIE ||
    //     type == ItemType.TVCHANNEL ||
    //     type == ItemType.VIDEO) {
    //   return customRouter.push(StreamRoute(item: this));
    // } else if (type == ItemType.AUDIO) {
    //   return musicProvider.playRemoteAudio(this);
    // } else if (type == ItemType.MUSICALBUM) {
    //   return musicProvider.playPlaylist(this);
    // } else if (type == ItemType.BOOK) {
    //   return customRouter.push(EpubRoute(item: this));
    // } else {
    //   throw UnimplementedError('Item is not playable (type : $type');
    // }
    throw UnimplementedError('Item is not playable (type : $type');
  }

  Future<String> getItemURL({bool directPlay = false}) async {
    // if (directPlay == false && offlineMode == false) {
    //   await StreamingService.bitrateTest(size: 500000);
    //   await StreamingService.bitrateTest(size: 1000000);
    //   await StreamingService.bitrateTest(size: 3000000);
    // }
    // final settings = await db.AppDatabase()
    //     .getDatabase
    //     .settingsDao
    //     .getSettingsById(userApp!.settingsId);
    // final directPlaySettingsOverride = settings.directPlay;

    // // If direct play if forced by parameters or settings we direct play
    // directPlay = directPlaySettingsOverride || directPlay;

    // late final Item item;

    // if (type == ItemType.EPISODE ||
    //     type == ItemType.MOVIE ||
    //     type == ItemType.TVCHANNEL ||
    //     type == ItemType.VIDEO ||
    //     type == ItemType.MUSICVIDEO ||
    //     type == ItemType.AUDIO) {
    //   item = this;
    // } else if (type == ItemType.SEASON || type == ItemType.SERIES) {
    //   item = await getFirstUnplayedItem();
    // } else if (type == ItemType.AUDIO) {
    //   return createMusicURL();
    // } else {
    //   throw ('Cannot find the type of file');
    // }

    // return getStreamURL(item, directPlay);

    throw UnimplementedError('GetItemURL is not defined right now, TODO');
  }

  Future<Item> getPlayableItemOrLastUnplayed() async {
    var item;

    if (type == ItemType.Episode ||
        type == ItemType.Movie ||
        type == ItemType.TvChannel ||
        type == ItemType.Video ||
        type == ItemType.MusicVideo ||
        type == ItemType.Audio) {
      item = this;
    } else if (type == ItemType.Season || type == ItemType.Series) {
      item = await getFirstUnplayedItem();
    } else {
      throw ('Cannot find the type of file');
    }
    return item;
  }

  Future<Item> getFirstUnplayedItem() async {
    // var category = await ItemService.getItems(
    //     parentId: id, filter: 'IsNotFolder', fields: 'MediaStreams');
    // // remove all item without an index to avoid sort error
    // category.items.removeWhere((element) => element.indexNumber == null);
    // // sort by index to get the next item to stream
    // category.items.sort((a, b) => a.indexNumber!.compareTo(b.indexNumber!));
    // return category.items.firstWhere((element) => !element.userData!.played,
    //     orElse: () => category.items.first);

    throw UnimplementedError('getFirstUnplayedItem is not defined right now, TODO');
  }

  Future<String> getStreamURL(Item item, bool directPlay) async {
    // First we try to fetch item locally to play it
    // final database = db.AppDatabase().getDatabase;
    // final itemExist = await database.downloadsDao.doesExist(item.id);
    // if (itemExist) return await FileService.getStoragePathItem(item);

    // // If item do not exist locally the we fetch it from remote server
    // final streamingProvider = StreamingProvider();
    // final data = await StreamingService.isCodecSupported();
    // final backInfos = await StreamingService.playbackInfos(data, item.id,
    //     startTimeTick: item.userData!.playbackPositionTicks);
    // var completeTranscodeUrl;

    // // Check if we have a transcide url or we create it
    // if (backInfos.isTranscoding() && !directPlay) {
    //   completeTranscodeUrl =
    //       '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
    // }
    // final finalUrl = completeTranscodeUrl ??
    //     await StreamingService.createURL(item, backInfos,
    //         startTick: item.userData!.playbackPositionTicks);

    // // Current item, playbackinfos, stream url and direct play bool
    // streamingProvider
    //     .setIsDirectPlay(completeTranscodeUrl != null ? false : true);
    // streamingProvider.setPlaybackInfos(backInfos);
    // streamingProvider.setURL(finalUrl);
    // return finalUrl;

    throw UnimplementedError('getStreamURL is not defined right now, TODO');
  }

  String concatenateGenre({int? maxGenre}) {
    var max = genres.length;
    if (maxGenre != null) {
      max = genres.length > maxGenre ? maxGenre : genres.length;
    }

    if (genres.isNotEmpty) {
      return genres.getRange(0, max).join(', ').toString();
    }
    return '';
  }

  String concatenateArtists({int? maxArtists}) {
    var max = artists.length;
    if (maxArtists != null) {
      max = artists.length > maxArtists ? maxArtists : artists.length;
    }

    if (artists.isNotEmpty) {
      return artists.getRange(0, max).join(', ').toString();
    }
    return '';
  }

  bool hasRatings() {
    return communityRating != null || criticRating != null;
  }

  Future<String> createMusicURL() async {
    // final streamingSoftwareDB = await db.AppDatabase()
    //     .getDatabase
    //     .settingsDao
    //     .getSettingsById(userApp!.settingsId);
    // final streamingSoftware = TranscodeAudioCodec.fromString(
    //     streamingSoftwareDB.preferredTranscodeAudioCodec);

    // // First we try to fetch item locally to play it
    // final database = db.AppDatabase().getDatabase;
    // final itemExist = await database.downloadsDao.doesExist(id);
    // if (itemExist) return await FileService.getStoragePathItem(this);

    // return '${server.url}/Audio/$id/stream.$streamingSoftware';

    throw UnimplementedError('createMusicURL is not defined right now, TODO');
  }

  List<MediaStream> getMediaStreamFromType({required MediaStreamType type}) {
    return mediaStreams.where((element) => element.type == type).toList();
  }

  Future<Uri> getYoutubeTrailerUrl(MediaUrl trailer) async {
    // final youtubeUrl = trailer.url;
    // final itemURi = Uri.parse(youtubeUrl);
    // final videoId = itemURi.queryParameters['v'];
    // final yt = YoutubeExplode();
    // final manifest = await yt.videos.streamsClient.getManifest(videoId);
    // final streamInfo = manifest.muxed.withHighestBitrate();
    // yt.close();
    // return streamInfo.url;
    throw UnimplementedError('getYoutubeTrailerUrl is not defined right now, TODO');
  }
}
