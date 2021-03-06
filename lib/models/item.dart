// To parse this JSON data, do
//
//     final media = itemFromMap(jsonString);

import 'dart:convert';

import 'package:fereader/fereader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/database/database.dart' as db;
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/TranscodeAudioCodec.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/stream/initStream.dart';
import 'package:jellyflut/shared/enums.dart';
import 'package:jellyflut/shared/shared.dart';

import '../globals.dart';
import 'albumArtists.dart';
import 'artist.dart';
import 'artistItems.dart';
import 'chapter.dart';
import 'externalUrl.dart';
import 'genreItem.dart';
import 'imageTags.dart';
import 'imageBlurHashes.dart';
import 'mediaSource.dart';
import 'mediaStream.dart';
import 'person.dart';
import 'providerIds.dart';
import 'userData.dart';

Item itemFromMap(String str) => Item.fromMap(json.decode(str));

String itemToMap(Item data) => json.encode(data.toMap());

class Item {
  Item({
    this.name,
    this.originalTitle,
    this.serverId,
    this.id,
    this.indexNumber,
    this.parentIndexNumber,
    this.etag,
    this.collectionType,
    this.dateCreated,
    this.canDelete,
    this.canDownload,
    this.hasSubtitles,
    this.container,
    this.sortName,
    this.premiereDate,
    this.externalUrls,
    this.mediaSources,
    this.criticRating,
    this.productionLocations,
    this.path,
    this.enableMediaSourceDisplay,
    this.overview,
    this.taglines,
    this.genres,
    this.communityRating,
    this.runTimeTicks,
    this.playAccess,
    this.productionYear,
    this.remoteTrailers,
    this.providerIds,
    this.isHd,
    this.isFolder,
    this.parentId,
    this.seriesId,
    this.seasonId,
    this.type,
    this.artists,
    this.artistItems,
    this.album,
    this.albumId,
    this.albumPrimaryImageTag,
    this.albumArtist,
    this.albumArtists,
    this.people,
    this.studios,
    this.genreItems,
    this.localTrailerCount,
    this.userData,
    this.specialFeatureCount,
    this.displayPreferencesId,
    this.tags,
    this.primaryImageAspectRatio,
    this.mediaStreams,
    this.videoType,
    this.imageTags,
    this.seriesPrimaryImageTag,
    this.seriesName,
    this.backdropImageTags,
    this.screenshotImageTags,
    this.imageBlurHashes,
    this.chapters,
    this.locationType,
    this.mediaType,
    this.lockedFields,
    this.lockData,
    this.width,
    this.height,
  });
  String name;
  String originalTitle;
  String serverId;
  String id;
  int indexNumber;
  int parentIndexNumber;
  String etag;
  String collectionType;
  DateTime dateCreated;
  bool canDelete;
  bool canDownload;
  bool hasSubtitles;
  String container;
  String sortName;
  DateTime premiereDate;
  List<ExternalUrl> externalUrls;
  List<MediaSource> mediaSources;
  int criticRating;
  List<String> productionLocations;
  String path;
  bool enableMediaSourceDisplay;
  String overview;
  List<dynamic> taglines;
  List<String> genres;
  double communityRating;
  int runTimeTicks;
  String playAccess;
  int productionYear;
  List<ExternalUrl> remoteTrailers;
  ProviderIds providerIds;
  bool isHd;
  bool isFolder;
  String parentId;
  String seriesId;
  String seasonId;
  String type;
  List<Artist> artists;
  List<ArtistItems> artistItems;
  String album;
  String albumId;
  String albumPrimaryImageTag;
  String albumArtist;
  List<AlbumArtists> albumArtists;
  List<Person> people;
  List<GenreItem> studios;
  List<GenreItem> genreItems;
  int localTrailerCount;
  UserData userData;
  int specialFeatureCount;
  String displayPreferencesId;
  List<dynamic> tags;
  double primaryImageAspectRatio;
  List<MediaStream> mediaStreams;
  String videoType;
  ImageTags imageTags;
  String seriesPrimaryImageTag;
  String seriesName;
  List<String> backdropImageTags;
  List<dynamic> screenshotImageTags;
  ImageBlurHashes imageBlurHashes;
  List<Chapter> chapters;
  String locationType;
  Type mediaType;
  List<dynamic> lockedFields;
  bool lockData;
  int width;
  int height;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        name: json['Name'],
        originalTitle: json['OriginalTitle'],
        serverId: json['ServerId'],
        id: json['Id'],
        indexNumber: json['IndexNumber'],
        parentIndexNumber: json['ParentIndexNumber'],
        etag: json['Etag'],
        collectionType: json['CollectionType'],
        dateCreated: json['DateCreated'] == null
            ? null
            : DateTime.parse(json['DateCreated']),
        canDelete: json['CanDelete'],
        canDownload: json['CanDownload'],
        hasSubtitles: json['HasSubtitles'],
        container: json['Container'],
        sortName: json['SortName'],
        premiereDate: json['PremiereDate'] == null
            ? null
            : DateTime.parse(json['PremiereDate']),
        externalUrls: json['ExternalUrls'] == null
            ? null
            : List<ExternalUrl>.from(
                json['ExternalUrls'].map((x) => ExternalUrl.fromMap(x))),
        mediaSources: json['MediaSources'] == null
            ? null
            : List<MediaSource>.from(
                json['MediaSources'].map((x) => MediaSource.fromMap(x))),
        criticRating: json['CriticRating'],
        productionLocations: json['ProductionLocations'] == null
            ? null
            : List<String>.from(json['ProductionLocations'].map((x) => x)),
        path: json['Path'],
        enableMediaSourceDisplay: json['EnableMediaSourceDisplay'],
        overview: json['Overview'],
        taglines: json['Taglines'] == null
            ? null
            : List<dynamic>.from(json['Taglines'].map((x) => x)),
        genres: json['Genres'] == null
            ? null
            : List<String>.from(json['Genres'].map((x) => x)),
        communityRating: json['CommunityRating'] == null
            ? null
            : json['CommunityRating'].toDouble(),
        runTimeTicks: json['RunTimeTicks'],
        playAccess: json['PlayAccess'],
        productionYear: json['ProductionYear'],
        remoteTrailers: json['RemoteTrailers'] == null
            ? null
            : List<ExternalUrl>.from(
                json['RemoteTrailers'].map((x) => ExternalUrl.fromMap(x))),
        providerIds: json['ProviderIds'] == null
            ? null
            : ProviderIds.fromMap(json['ProviderIds']),
        isHd: json['IsHD'] == null ? null : json['isHd'],
        isFolder: json['IsFolder'],
        parentId: json['ParentId'],
        seriesId: json['SeriesId'],
        seasonId: json['SeasonId'],
        type: json['Type'],
        artists: json['Artists'] == null
            ? null
            : List<Artist>.from(json['Artists'].map((x) => Artist.fromMap(x))),
        artistItems: json['ArtistItems'] == null
            ? null
            : List<ArtistItems>.from(
                json['ArtistItems'].map((x) => ArtistItems.fromMap(x))),
        album: json['Album'],
        albumId: json['AlbumId'],
        albumPrimaryImageTag: json['AlbumPrimaryImageTag'],
        albumArtist: json['AlbumArtist'],
        albumArtists: json['AlbumArtists'] == null
            ? null
            : List<AlbumArtists>.from(
                json['AlbumArtists'].map((x) => AlbumArtists.fromMap(x))),
        people: json['People'] == null
            ? null
            : List<Person>.from(json['People'].map((x) => Person.fromMap(x))),
        studios: json['Studios'] == null
            ? null
            : List<GenreItem>.from(
                json['Studios'].map((x) => GenreItem.fromMap(x))),
        genreItems: json['GenreItems'] == null
            ? null
            : List<GenreItem>.from(
                json['GenreItems'].map((x) => GenreItem.fromMap(x))),
        localTrailerCount: json['LocalTrailerCount'] == null
            ? null
            : json['localTrailerCount'],
        userData: json['UserData'] == null
            ? null
            : UserData.fromMap(json['UserData']),
        specialFeatureCount: json['SpecialFeatureCount'],
        displayPreferencesId: json['DisplayPreferencesId'],
        tags: json['Tags'] == null
            ? null
            : List<dynamic>.from(json['Tags'].map((x) => x)),
        primaryImageAspectRatio: json['PrimaryImageAspectRatio'] == null
            ? null
            : json['PrimaryImageAspectRatio'].toDouble(),
        mediaStreams: json['MediaStreams'] == null
            ? null
            : List<MediaStream>.from(
                json['MediaStreams'].map((x) => MediaStream.fromMap(x))),
        videoType: json['VideoType'],
        imageTags: json['ImageTags'] == null
            ? null
            : ImageTags.fromMap(json['ImageTags']),
        seriesPrimaryImageTag: json['SeriesPrimaryImageTag'],
        seriesName: json['SeriesName'],
        backdropImageTags: json['BackdropImageTags'] == null
            ? null
            : List<String>.from(json['BackdropImageTags'].map((x) => x)),
        screenshotImageTags: json['ScreenshotImageTags'] == null
            ? null
            : List<dynamic>.from(json['ScreenshotImageTags'].map((x) => x)),
        imageBlurHashes: json['ImageBlurHashes'] == null
            ? null
            : ImageBlurHashes.fromMap(json['ImageBlurHashes']),
        chapters: json['Chapters'] == null
            ? null
            : List<Chapter>.from(
                json['Chapters'].map((x) => Chapter.fromMap(x))),
        locationType: json['LocationType'],
        mediaType: typeValues.map[json['MediaType']],
        lockedFields: json['LockedFields'] == null
            ? null
            : List<dynamic>.from(json['LockedFields'].map((x) => x)),
        lockData: json['LockData'],
        width: json['Width'],
        height: json['Height'],
      );

  Map<String, dynamic> toMap() {
    var map = {
      'Name': name,
      'OriginalTitle': originalTitle,
      'ServerId': serverId,
      'Id': id,
      'IndexNumber': indexNumber,
      'ParentIndexNumber': parentIndexNumber,
      'Etag': etag,
      'CollectionType': collectionType,
      'DateCreated': dateCreated == null ?? dateCreated.toIso8601String(),
      'CanDelete': canDelete,
      'CanDownload': canDownload,
      'HasSubtitles': hasSubtitles,
      'Container': container,
      'SortName': sortName,
      'PremiereDate': premiereDate == null ?? premiereDate.toIso8601String(),
      'ExternalUrls': externalUrls == null ??
          List<dynamic>.from(externalUrls.map((x) => x.toMap())),
      'MediaSources': mediaSources == null ??
          List<dynamic>.from(mediaSources.map((x) => x.toMap())),
      'CriticRating': criticRating,
      'ProductionLocations': productionLocations == null ??
          List<dynamic>.from(productionLocations.map((x) => x)),
      'Path': path,
      'EnableMediaSourceDisplay': enableMediaSourceDisplay,
      'Overview': overview,
      'Taglines':
          taglines == null ?? List<dynamic>.from(taglines.map((x) => x)),
      'Genres': genres == null ?? List<dynamic>.from(genres.map((x) => x)),
      'CommunityRating': communityRating,
      'RunTimeTicks': runTimeTicks,
      'PlayAccess': playAccess,
      'ProductionYear': productionYear,
      'RemoteTrailers': remoteTrailers == null ??
          List<dynamic>.from(remoteTrailers.map((x) => x.toMap())),
      'ProviderIds': providerIds == null ?? providerIds.toMap(),
      'IsHD': isHd,
      'IsFolder': isFolder,
      'ParentId': parentId,
      'Type': type,
      'Artists': artists,
      'ArtistItems': artistItems,
      'Album': album,
      'AlbumId': albumId,
      'AlbumPrimaryImageTag': albumPrimaryImageTag,
      'AlbumArtist': albumArtist,
      'AlbumArtists': albumArtists,
      'People':
          people == null ?? List<dynamic>.from(people.map((x) => x.toMap())),
      'Studios':
          studios == null ?? List<dynamic>.from(studios.map((x) => x.toMap())),
      'GenreItems': genreItems == null ??
          List<dynamic>.from(genreItems.map((x) => x.toMap())),
      'LocalTrailerCount': localTrailerCount,
      'UserData': userData == null ?? userData.toMap(),
      'SpecialFeatureCount': specialFeatureCount,
      'DisplayPreferencesId': displayPreferencesId,
      'Tags': tags == null ?? List<dynamic>.from(tags.map((x) => x)),
      'PrimaryImageAspectRatio': primaryImageAspectRatio,
      'MediaStreams': mediaStreams == null ??
          List<dynamic>.from(mediaStreams.map((x) => x.toMap())),
      'VideoType': videoType,
      'ImageTags': imageTags == null ?? imageTags.toMap(),
      'SeriesPrimaryImageTag': seriesPrimaryImageTag,
      'SeriesName': seriesName,
      'BackdropImageTags': backdropImageTags == null ??
          List<dynamic>.from(backdropImageTags.map((x) => x)),
      'ScreenshotImageTags': screenshotImageTags == null ??
          List<dynamic>.from(screenshotImageTags.map((x) => x)),
      'ImageBlurHashes': imageBlurHashes.toMap(),
      'Chapters': chapters == null ??
          List<dynamic>.from(chapters.map((x) => x.toMap())),
      'LocationType': locationType,
      'MediaType': typeValues.reverse[mediaType],
      'LockedFields': lockedFields == null ??
          List<dynamic>.from(lockedFields.map((x) => x)),
      'LockData': lockData,
      'Width': width,
      'Height': height,
    };
    return map;
  }

  ///Check if item is new
  ///
  /// Return [true] if is less than 3 days old
  /// Return [false] if date of creation is null or if more than 3 days old
  bool isNew() {
    if (dateCreated == null) {
      return false;
    }
    var difference = dateCreated.difference(DateTime.now());
    return difference.inDays < -3 ? false : true;
  }

  ///Check if item has been played
  ///
  /// Return [true] if played
  /// Return [false] if is not played or [null]
  bool isPlayed() {
    if (userData != null) {
      return userData.played;
    }
    return false;
  }

  ///Check if item has been played
  ///
  /// Return [true] if favorite
  /// Return [false] if is not favorite or [null]
  bool isFavorite() {
    if (userData != null) {
      return userData.isFavorite;
    }
    return false;
  }

  ///Check if item has been played
  ///
  /// Return [true] if played
  /// Return [false] is is not played
  bool hasProgress() {
    if (userData.playbackPositionTicks != null &&
        userData.playbackPositionTicks > 0) {
      return true;
    }
    return false;
  }

  /// Duration in microseconds from the item
  ///
  /// Return the [duration] if known
  /// Return [0] if not known
  int getDuration() {
    return (runTimeTicks / 10).round();
  }

  /// Get item aspect ratio
  ///
  /// Return aspect ratio from video as [double] value
  /// If not specified return [16/9] as default value
  double getAspectRatio() {
    MediaStream mediaStream;
    if (mediaStreams != null && mediaStreams.isNotEmpty) {
      mediaStream = mediaStreams.firstWhere(
          (element) => element.type.trim().toLowerCase() == 'video');

      // If aspect ratio is specified then we use it
      // else we calculate it
      if (mediaStream.aspectRatio.isNotEmpty) {
        return calculateAspectRatio(mediaStream.aspectRatio);
      }
      return (mediaStream.width / mediaStream.height);
    }
    return 16 / 9;
  }

  /// Parse aspect ratio (jellyfin format) from string to double
  ///
  /// Return aspect ratio from video as [double] value
  /// If not specified return [null] as default value
  double calculateAspectRatio(String aspectRatio) {
    if (aspectRatio == null) return null;
    if (aspectRatio.isEmpty) return null;
    var separatorIndex = aspectRatio.indexOf(':');
    var firstValue = double.parse(aspectRatio.substring(0, separatorIndex));
    var secondValue = double.parse(
        aspectRatio.substring(separatorIndex + 1, aspectRatio.length));
    return firstValue / secondValue;
  }

  /// Playback position last time played
  ///
  /// Return playback position in microsecond as [int]
  /// Return [null] if not specified
  int getPlaybackPosition() {
    if (userData.playbackPositionTicks != null) {
      return (userData.playbackPositionTicks / 10).round();
    }
    return null;
  }

  /// Percent of time played
  ///
  /// Return percent og time played as [double]
  /// Return [null] if not specified
  double getPercentPlayed() {
    if (userData.playbackPositionTicks != null || runTimeTicks != null) {
      return userData.playbackPositionTicks / runTimeTicks;
    }
    return null;
  }

  /// Get primary image aspect ratio. Useful to show poster of item
  ///
  /// Return [double]
  ///
  /// Return [primaryImageAspectRatio] if defined
  /// Else return an aspect ratio based on type if not defined
  double getPrimaryAspectRatio() {
    if (primaryImageAspectRatio != null) {
      if (primaryImageAspectRatio > 0.0) {
        return primaryImageAspectRatio;
      }
      return aspectRatio(type: type);
    }
    return aspectRatio(type: type);
  }

  /// Get id or parentid if primary image is not defined
  ///
  /// Return [String]
  ///
  /// Return id if type do not have parent
  /// Return parent id if there is no primary image set
  String getIdBasedOnImage() {
    if (type == 'Season') {
      if (imageTags.primary != null) return id;
      return seriesId;
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
    var hasSerieParent = seriesName != null ? seriesName.isNotEmpty : false;
    var hasAlbumParent = albumId != null ? albumId.isNotEmpty : false;
    var hasSeasonParent = seasonId != null ? seasonId.isNotEmpty : false;
    return hasSerieParent || hasAlbumParent || hasSeasonParent;
  }

  String getParentId() {
    if (seriesId != null && seriesId.isNotEmpty) return seriesId;
    if (seasonId != null && seasonId.isNotEmpty) return seasonId;
    if (albumId != null && albumId.isNotEmpty) return albumId;
    return id;
  }

  /// Get parent name
  ///
  /// Return [String]
  ///
  /// Return parents name if not null
  /// ELse return empty string
  String parentName() {
    if (seriesName != null && seriesName.isNotEmpty) return seriesName;
    if (album != null && album.isNotEmpty) return album;
    return name;
  }

  /// Get collection type such as requested by API
  ///
  /// Return [String]
  ///
  /// Return correct collection type based on item one
  /// If nothing found then return current one
  String getCollectionType() {
    if (collectionType == 'movies') {
      return 'movie';
    } else if (collectionType == 'tvshows') {
      return 'Series';
    } else if (collectionType == 'music') {
      return 'MusicAlbum';
    } else if (collectionType == 'books') {
      return 'Book';
    } else if (collectionType == 'homevideos') {
      return 'Photo, Video';
    } else {
      return collectionType;
    }
  }

  /// Get correct image id based on searchType
  ///
  /// Return [String]
  ///
  /// Return id as [String] if found
  /// Else return item's id as [String]
  String correctImageId({String searchType = 'Primary'}) {
    if (searchType.toLowerCase().trim() == 'logo' &&
        (type == 'Season' || type == 'Episode' || type == 'Album')) {
      if (type == 'Season' || type == 'Episode') {
        return seriesId;
      } else if (type == 'Album') {
        return albumId;
      }
    } else if (imageTags.toMap().values.every((element) => element == null)) {
      if (type == 'Season') {
        return seriesId;
      } else if (type == 'Album' || type == 'Audio') {
        return albumId;
      } else {
        return id;
      }
    } else {
      return id;
    }
    return id;
  }

  /// Get correct image tags based on searchType
  ///
  /// Return [String]
  ///
  /// Return imageTag as [String] if found
  /// Else return [null]
  String correctImageTags({String searchType = 'Primary'}) {
    if (searchType.toLowerCase().trim() == 'logo' &&
        (type == 'Season' || type == 'Episode' || type == 'Album')) {
      if (type == 'Season' || type == 'Episode') {
        return seriesPrimaryImageTag;
      } else if (type == 'Album') {
        return albumPrimaryImageTag;
      }
    } else if (imageTags.toMap().values.every((element) => element == null)) {
      if (type == 'Season') {
        return seriesPrimaryImageTag;
      } else if (type == 'Album') {
        return albumPrimaryImageTag;
      } else {
        return null;
      }
    } else {
      return imageTags.primary;
    }
    return null;
  }

  /// Play current item given context
  ///
  /// If Book open Epub reader
  /// If Video open video player
  void playItem() async {
    var musicPlayer = MusicPlayer();
    if (type == 'Episode' ||
        type == 'Season' ||
        type == 'Series' ||
        type == 'Movie' ||
        type == 'Video') {
      automaticStreamingSoftwareChooser(item: this);
    } else if (type == 'Audio') {
      musicPlayer.playRemoteItem(this);
    } else if (type == 'MusicAlbum') {
      musicPlayer.playPlaylist(id);
    } else if (type == 'Book') {
      readBook();
    }
  }

  Future<String> getItemURL({bool directPlay = false}) async {
    await bitrateTest(size: 500000);
    await bitrateTest(size: 1000000);
    await bitrateTest(size: 3000000);

    if (type == 'Episode' || type == 'Movie' || type == 'Video') {
      return _getStreamURL(this, directPlay);
    } else if (type == 'Season' || type == 'Series') {
      return _getFirstUnplayedItemURL(directPlay);
    } else if (type == 'Audio') {
      return _getStreamURL(this, directPlay);
    } else {
      return null;
    }
  }

  Future<String> _getFirstUnplayedItemURL(bool directPlay) async {
    var category = await getItems(
        parentId: id, filter: 'IsNotFolder', fields: 'MediaStreams');
    // remove all item without an index to avoid sort error
    category.items.removeWhere((element) => element.indexNumber == null);
    // sort by index to get the next item to stream
    category.items.sort((a, b) => a.indexNumber.compareTo(b.indexNumber));
    var itemToPlay = category.items.firstWhere(
        (element) => !element.userData.played,
        orElse: () => category.items.first);
    return _getStreamURL(itemToPlay, directPlay);
  }

  Future<String> _getStreamURL(Item item, bool directPlay) async {
    var streamModel = StreamModel();
    var data = await isCodecSupported();
    var backInfos = await playbackInfos(data, item.id,
        startTimeTick: item.userData.playbackPositionTicks);
    var completeTranscodeUrl;
    var finalUrl;

    // Check if we have a transcide url or we create it
    if (backInfos.isTranscoding() && !directPlay) {
      completeTranscodeUrl =
          '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
    }
    finalUrl = completeTranscodeUrl ??
        await createURL(item, backInfos,
            startTick: item.userData.playbackPositionTicks);

    // Current item, playbackinfos, stream url and direct play bool
    streamModel.setIsDirectPlay(completeTranscodeUrl != null ? false : true);
    streamModel.setItem(item);
    streamModel.setPlaybackInfos(backInfos);
    streamModel.setURL(finalUrl);
    return finalUrl;
  }

  void readBook() async {
    var path = await getEbook(this);
    if (path != null) {
      //var sharedPreferences = await SharedPreferences.getInstance();

      Fereader.setConfig(
        themeColor: Theme.of(navigatorKey.currentContext).primaryColor,
        scrollDirection: EpubScrollDirection.VERTICAL,
        allowSharing: true,
        enableTts: true,
      );

      //TODO save locator
      /* dynamic book;
      if (sharedPreferences.getString(path) != null) {
        book = json.decode(sharedPreferences.getString(path));
      }

      // Get locator which you can save in your database
      Fereader.locatorStream.listen((locator) {
        print('prout: ' + locator);
        sharedPreferences.setString(path, locator);
      });
      */
      Fereader.open(
        path,
      );
    }
  }

  String concatenateGenre({int maxGenre}) {
    var max = genres.length;
    if (maxGenre != null) {
      max = genres.length > maxGenre ? maxGenre : genres.length;
    }

    if (genres != null) {
      return genres.getRange(0, max).join(', ').toString();
    }
    return '';
  }

  String concatenateArtists({int maxArtists}) {
    var max = artists.length;
    if (maxArtists != null) {
      max = artists.length > maxArtists ? maxArtists : artists.length;
    }

    if (artists != null) {
      return artists.getRange(0, max).map((e) => e.name).join(', ').toString();
    }
    return '';
  }

  bool hasRatings() {
    return communityRating != null || criticRating != null;
  }

  Future<String> createMusicURL() async {
    var streamingSoftwareDB = await db.AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp.settingsId);
    var streamingSoftware = TranscodeAudioCodecName.values.firstWhere((e) =>
        e.toString() ==
        'TranscodeAudioCodecName.' +
            streamingSoftwareDB.preferredTranscodeAudioCodec);
    return '${server.url}/Audio/$id/stream.$streamingSoftware';
  }

  List<MediaStream> getMediaStreamFromType({@required String type}) {
    return mediaStreams
        .where((element) => element.type.trim().toLowerCase() == type)
        .toList();
  }
}
