// To parse this JSON data, do
//
//     final media = itemFromMap(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/api/items.dart';
import 'package:jellyflut/api/stream.dart';
import 'package:jellyflut/api/user.dart';
import 'package:jellyflut/models/deviceProfileParent.dart';
import 'package:jellyflut/provider/musicPlayer.dart';
import 'package:jellyflut/provider/streamModel.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:jellyflut/screens/stream/streamBP.dart' as StreamBP;
import 'package:jellyflut/shared/enums.dart';
import 'package:jellyflut/shared/exoplayer.dart';
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
        name: json['Name'] == null ? null : json['Name'],
        originalTitle:
            json['OriginalTitle'] == null ? null : json['OriginalTitle'],
        serverId: json['ServerId'] == null ? null : json['ServerId'],
        id: json['Id'] == null ? null : json['Id'],
        indexNumber: json['IndexNumber'] == null ? null : json['IndexNumber'],
        parentIndexNumber: json['ParentIndexNumber'] == null
            ? null
            : json['ParentIndexNumber'],
        etag: json['Etag'] == null ? null : json['Etag'],
        collectionType:
            json['CollectionType'] == null ? null : json['CollectionType'],
        dateCreated: json['DateCreated'] == null
            ? null
            : DateTime.parse(json['DateCreated']),
        canDelete: json['CanDelete'] == null ? null : json['CanDelete'],
        canDownload: json['CanDownload'] == null ? null : json['CanDownload'],
        hasSubtitles:
            json['HasSubtitles'] == null ? null : json['HasSubtitles'],
        container: json['Container'] == null ? null : json['Container'],
        sortName: json['SortName'] == null ? null : json['SortName'],
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
        criticRating:
            json['CriticRating'] == null ? null : json['CriticRating'],
        productionLocations: json['ProductionLocations'] == null
            ? null
            : List<String>.from(json['ProductionLocations'].map((x) => x)),
        path: json['Path'] == null ? null : json['Path'],
        enableMediaSourceDisplay: json['EnableMediaSourceDisplay'] == null
            ? null
            : json['EnableMediaSourceDisplay'],
        overview: json['Overview'] == null ? null : json['Overview'],
        taglines: json['Taglines'] == null
            ? null
            : List<dynamic>.from(json['Taglines'].map((x) => x)),
        genres: json['Genres'] == null
            ? null
            : List<String>.from(json['Genres'].map((x) => x)),
        communityRating: json['CommunityRating'] == null
            ? null
            : json['CommunityRating'].toDouble(),
        runTimeTicks:
            json['RunTimeTicks'] == null ? null : json['RunTimeTicks'],
        playAccess: json['PlayAccess'] == null ? null : json['PlayAccess'],
        productionYear:
            json['ProductionYear'] == null ? null : json['ProductionYear'],
        remoteTrailers: json['RemoteTrailers'] == null
            ? null
            : List<ExternalUrl>.from(
                json['RemoteTrailers'].map((x) => ExternalUrl.fromMap(x))),
        providerIds: json['ProviderIds'] == null
            ? null
            : ProviderIds.fromMap(json['ProviderIds']),
        isHd: json['IsHD'] == null ? null : json['isHd'],
        isFolder: json['IsFolder'] == null ? null : json['IsFolder'],
        parentId: json['ParentId'] == null ? null : json['ParentId'],
        seriesId: json['SeriesId'] == null ? null : json['SeriesId'],
        seasonId: json['SeasonId'] == null ? null : json['SeasonId'],
        type: json['Type'] == null ? null : json['Type'],
        artists: json['Artists'] == null
            ? null
            : List<Artist>.from(json['Artists'].map((x) => Artist.fromMap(x))),
        artistItems: json['ArtistItems'] == null
            ? null
            : List<ArtistItems>.from(
                json['ArtistItems'].map((x) => ArtistItems.fromMap(x))),
        album: json['Album'] == null ? null : json['Album'],
        albumId: json['AlbumId'] == null ? null : json['AlbumId'],
        albumPrimaryImageTag: json['AlbumPrimaryImageTag'] == null
            ? null
            : json['AlbumPrimaryImageTag'],
        albumArtist: json['AlbumArtist'] == null ? null : json['AlbumArtist'],
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
        specialFeatureCount: json['SpecialFeatureCount'] == null
            ? null
            : json['SpecialFeatureCount'],
        displayPreferencesId: json['DisplayPreferencesId'] == null
            ? null
            : json['DisplayPreferencesId'],
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
        videoType: json['VideoType'] == null ? null : json['VideoType'],
        imageTags: json['ImageTags'] == null
            ? null
            : ImageTags.fromMap(json['ImageTags']),
        seriesPrimaryImageTag: json['SeriesPrimaryImageTag'] == null
            ? null
            : json['SeriesPrimaryImageTag'],
        seriesName: json['SeriesName'] == null ? null : json['SeriesName'],
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
        locationType:
            json['LocationType'] == null ? null : json['LocationType'],
        mediaType: typeValues.map[json['MediaType']] == null
            ? null
            : typeValues.map[json['MediaType']],
        lockedFields: json['LockedFields'] == null
            ? null
            : List<dynamic>.from(json['LockedFields'].map((x) => x)),
        lockData: json['LockData'] == null ? null : json['LockData'],
        width: json['Width'] == null ? null : json['Width'],
        height: json['Height'] == null ? null : json['Height'],
      );

  Map<String, dynamic> toMap() {
    var map = {
      'Name': name,
      'OriginalTitle': originalTitle,
      'ServerId': serverId,
      'Id': id,
      'IndexNumber': indexNumber == null ? null : indexNumber,
      'ParentIndexNumber': parentIndexNumber == null ? null : parentIndexNumber,
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

  /**
   * Check if item is new
   * 
   * Return [true] is is less than 3 days old
   * Return [false] is date of creation is null or if more than 3 days old
  */
  bool isNew() {
    if (dateCreated == null) {
      return false;
    }
    var difference = dateCreated.difference(DateTime.now());
    return difference.inDays < -3 ? false : true;
  }

  /**
   * Duration in microseconds from the item
   * 
   * Return the [duration] if known
   * Return [0] if not known
   */
  int getDuration() {
    return (runTimeTicks / 10).round();
  }

  /**
   * Get item aspect ratio
   * 
   * Return aspect ratio from video as [double] value
   * If not specified return [16/9] as default value
   */
  double getAspectRatio() {
    MediaStream mediaStream;
    if (mediaStreams.isNotEmpty) {
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

  /**
   * Parse aspect ratio (jellyfin format) from string to double
   * 
   * Return aspect ratio from video as [double] value
   * If not specified return [null] as default value
   */
  double calculateAspectRatio(String aspectRatio) {
    if (aspectRatio == null) return null;
    if (aspectRatio.isEmpty) return null;
    var separatorIndex = aspectRatio.indexOf(':');
    var firstValue = double.parse(aspectRatio.substring(0, separatorIndex));
    var secondValue = double.parse(
        aspectRatio.substring(separatorIndex + 1, aspectRatio.length));
    return firstValue / secondValue;
  }

  /**
   * Playback position last time played
   * 
   * Return playback position in microsecond as [int]
   * Return [null] if not specified
   */
  int getPlaybackPosition() {
    if (userData.playbackPositionTicks != null) {
      return (userData.playbackPositionTicks / 10).round();
    }
    return null;
  }

  /**
   * Percent of time played
   * 
   * Return percent og time played as [double]
   * Return [null] if not specified
   */
  double getPercentPlayed() {
    if (userData.playbackPositionTicks != null || runTimeTicks != null) {
      return userData.playbackPositionTicks / runTimeTicks;
    }
    return null;
  }

  /**
   * Get primary image aspect ratio. Useful to show poster of item
   * 
   * Return [double]
   * 
   * Return [primaryImageAspectRatio] if defined
   * Else return an aspect ratio based on type if not defined
   */
  double getPrimaryAspectRatio() {
    if (primaryImageAspectRatio != null) {
      if (primaryImageAspectRatio > 0.0) {
        return primaryImageAspectRatio;
      }
      return aspectRatio(type: type);
    }
    return aspectRatio(type: type);
  }

  /**
   * Get id or parentid if primary image is not defined
   * 
   * Return [String]
   * 
   * Return id if type do not have parent
   * Return parent id if there is no primary image set
   */
  String getIdBasedOnImage() {
    if (type == 'Season') {
      if (imageTags.primary != null) return id;
      return seriesId;
    }
    return id;
  }

  /**
   * Check if item have parents
   * 
   * Return [bool]
   * 
   * Return [true] if parents
   * Return [false] is no parents found
   */
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

  /**
   * Get parent name
   * 
   * Return [String]
   * 
   * Return parents name if not null
   * ELse return empty string
   */
  String parentName() {
    if (seriesName != null && seriesName.isNotEmpty) return seriesName;
    if (album != null && album.isNotEmpty) return album;
    return name;
  }

  /**
   * Get collection type such as requested by API
   * 
   * Return [String]
   * 
   * Return correct collection type based on item one
   * If nothing found then return current one
   */
  String getCollectionType() {
    if (collectionType == 'movies') {
      return 'movie';
    } else if (collectionType == 'tvshows') {
      return 'Series';
    } else if (collectionType == 'music') {
      return 'MusicAlbum';
    } else if (collectionType == 'books') {
      return 'Book';
    } else {
      return collectionType;
    }
  }

  /**
   * Get correct image id based on searchType
   * 
   * Return [String]
   * 
   * Return id as [String] if found
   * Else return item's id as [String]
   */
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
      } else if (type == 'Album') {
        return albumId;
      } else {
        return id;
      }
    } else {
      return id;
    }
    return id;
  }

  /**
   * Get correct image tags based on searchType
   * 
   * Return [String]
   * 
   * Return imageTag as [String] if found
   * Else return [null]
   */
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

  /**
   * Play current item given context
   * 
   * If Book open Epub reader
   * If Video open video player
   */
  void playItem(BuildContext context) async {
    if (type == 'Episode' ||
        type == 'Season' ||
        type == 'Series' ||
        type == 'Movie') {
      var url = await getItemURL();
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StreamBP.Stream(
                item: this, streamUrl: url, playbackInfos: null)),
      );
    } else if (type == 'Audio') {
      MusicPlayer().playRemoteItem(this);
    } else if (type == 'Book') {
      readBook(context);
    }
  }

  Future<String> getItemURL() async {
    var streamModel = StreamModel();

    await bitrateTest(size: 500000);
    await bitrateTest(size: 1000000);
    await bitrateTest(size: 3000000);

    if (type == 'Episode' || type == 'Movie') {
      streamModel.setItem(this);
      return _getStreamURL(this);
    }
    return _getFirstUnplayedItemURL();
  }

  Future<String> _getFirstUnplayedItemURL() async {
    var category = await getItems(
        parentId: id, filter: 'IsNotFolder', fields: 'MediaStreams');
    // remove all item without an index to avoid sort error
    category.items.removeWhere((element) => element.indexNumber == null);
    // sort by index to get the next item to stream
    category.items.sort((a, b) => a.indexNumber.compareTo(b.indexNumber));
    var itemToPlay = category.items.firstWhere(
        (element) => !element.userData.played,
        orElse: () => category.items.first);
    return _getStreamURL(itemToPlay);
  }

  Future<String> _getStreamURL(Item item) async {
    var streamModel = StreamModel();
    var data = await isCodecSupported();
    var backInfos = await playbackInfos(data, item.id,
        startTimeTick: item.userData.playbackPositionTicks);
    var completeTranscodeUrl;
    var finalUrl;

    // Check if we have a transcide url or we create it
    if (backInfos.mediaSources.first.transcodingUrl != null) {
      completeTranscodeUrl =
          '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
    }
    finalUrl = completeTranscodeUrl ??
        await createURL(this, backInfos, startTick: runTimeTicks);
    // Current item, playbackinfos and stream url
    streamModel.setItem(this);
    streamModel.setPlaybackInfos(backInfos);
    streamModel.setURL(finalUrl);
    return finalUrl;
  }

  void readBook(BuildContext context) async {
    var path = await getEbook(this);
    if (path != null) {
      // var sharedPreferences = await SharedPreferences.getInstance();

      EpubViewer.setConfig(
        themeColor: Theme.of(context).primaryColor,
        scrollDirection: EpubScrollDirection.VERTICAL,
        allowSharing: true,
        enableTts: true,
      );

      //TODO save locator
      // dynamic book;
      // if (sharedPreferences.getString(path) != null) {
      //   book = json.decode(sharedPreferences.getString(path));
      // }

      // // Get locator which you can save in your database
      // EpubViewer.locatorStream.listen((locator) {
      //   sharedPreferences.setString(path, locator);
      // });

      EpubViewer.open(
        path,
      );
    }
  }
}
