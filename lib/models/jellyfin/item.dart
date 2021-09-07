// To parse this JSON data, do
//
//     final media = itemFromMap(jsonString);

// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';

// import 'package:fereader/fereader.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dart_vlc/dart_vlc.dart' as vlc;
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jellyflut/database/database.dart' as db;
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/main.dart';
import 'package:jellyflut/models/enum/transcode_audio_codec.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/enum/image_type.dart' as image_type;
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/media_stream_type.dart';
import 'package:jellyflut/models/jellyfin/remote_trailer.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/epub/epub_reader.dart';
import 'package:jellyflut/screens/musicPlayer/commonPlayer/common_player.dart';
import 'package:jellyflut/screens/stream/init_stream.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'album_artists.dart';
import 'artist.dart';
import 'artist_items.dart';
import 'chapter.dart';
import 'external_url.dart';
import 'genre_item.dart';
import 'image_blur_hashes.dart';
import 'image_tag.dart';
import 'media_source.dart';
import 'media_stream.dart';
import 'person.dart';
import 'provider_ids.dart';
import 'user_data.dart';

Item itemFromMap(String str) => Item.fromMap(json.decode(str));

String itemToMap(Item data) => json.encode(data.toMap());

class Item {
  Item({
    required this.name,
    this.originalTitle,
    this.serverId,
    required this.id,
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
    required this.type,
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
    this.recursiveItemCount,
    this.videoType,
    this.imageTags,
    this.officialRating,
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
  String? originalTitle;
  String? serverId;
  String id;
  int? indexNumber;
  int? parentIndexNumber;
  String? etag;
  CollectionType? collectionType;
  DateTime? dateCreated;
  bool? canDelete;
  bool? canDownload;
  bool? hasSubtitles;
  String? container;
  String? sortName;
  DateTime? premiereDate;
  List<ExternalUrl>? externalUrls;
  List<MediaSource>? mediaSources;
  int? criticRating;
  List<String>? productionLocations;
  String? path;
  bool? enableMediaSourceDisplay;
  String? overview;
  List<String>? taglines;
  List<String>? genres;
  double? communityRating;
  int? runTimeTicks;
  String? playAccess;
  int? productionYear;
  List<RemoteTrailer>? remoteTrailers;
  Map<String, dynamic>? providerIds;
  bool? isHd;
  bool? isFolder;
  String? parentId;
  String? seriesId;
  String? seasonId;
  ItemType type;
  List<Artist>? artists;
  List<ArtistItems>? artistItems;
  String? album;
  String? albumId;
  String? albumPrimaryImageTag;
  String? albumArtist;
  List<AlbumArtists>? albumArtists;
  List<Person>? people;
  List<GenreItem>? studios;
  List<GenreItem>? genreItems;
  int? localTrailerCount;
  UserData? userData;
  int? specialFeatureCount;
  String? displayPreferencesId;
  List<dynamic>? tags;
  double? primaryImageAspectRatio;
  List<MediaStream>? mediaStreams;
  int? recursiveItemCount;
  String? videoType;
  List<ImageTag>? imageTags;
  String? officialRating;
  String? seriesPrimaryImageTag;
  String? seriesName;
  List<String>? backdropImageTags;
  List<dynamic>? screenshotImageTags;
  ImageBlurHashes? imageBlurHashes;
  List<Chapter>? chapters;
  String? locationType;
  MediaStreamType? mediaType;
  List<dynamic>? lockedFields;
  bool? lockData;
  int? width;
  int? height;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        name: json['Name'],
        originalTitle: json['OriginalTitle'],
        serverId: json['ServerId'],
        id: json['Id'],
        indexNumber: json['IndexNumber'],
        parentIndexNumber: json['ParentIndexNumber'],
        etag: json['Etag'],
        collectionType: json['CollectionType'] != null
            ? EnumFromString<CollectionType>(CollectionType.values)
                .get(json['CollectionType'])
            : null,
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
            : List<String>.from(json['Taglines'].map((x) => x)),
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
            : List<RemoteTrailer>.from(
                json['RemoteTrailers'].map((x) => RemoteTrailer.fromMap(x))),
        providerIds: json['ProviderIds'],
        isHd: json['IsHD'] == null ? null : json['isHd'],
        isFolder: json['IsFolder'],
        parentId: json['ParentId'],
        seriesId: json['SeriesId'],
        seasonId: json['SeasonId'],
        type: EnumFromString<ItemType>(ItemType.values).get(json['Type'])!,
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
        recursiveItemCount: json['RecursiveItemCount'],
        videoType: json['VideoType'],
        imageTags: List<ImageTag>.from(ImageTag.fromMap(json['ImageTags'])),
        officialRating: json['OfficialRating'],
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
        mediaType: mediaStreamType.map[json['MediaType']],
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
      'DateCreated': dateCreated?.toIso8601String(),
      'CanDelete': canDelete,
      'CanDownload': canDownload,
      'HasSubtitles': hasSubtitles,
      'Container': container,
      'SortName': sortName,
      'PremiereDate': premiereDate?.toIso8601String(),
      'ExternalUrls': externalUrls != null
          ? List<dynamic>.from(externalUrls!.map((x) => x.toMap()))
          : null,
      'MediaSources': mediaSources != null
          ? List<dynamic>.from(mediaSources!.map((x) => x.toMap()))
          : null,
      'CriticRating': criticRating,
      'ProductionLocations': productionLocations != null
          ? List<dynamic>.from(productionLocations!.map((x) => x))
          : null,
      'Path': path,
      'EnableMediaSourceDisplay': enableMediaSourceDisplay,
      'Overview': overview,
      'Taglines':
          taglines != null ? List<dynamic>.from(taglines!.map((x) => x)) : null,
      'Genres':
          genres != null ? List<dynamic>.from(genres!.map((x) => x)) : null,
      'CommunityRating': communityRating,
      'RunTimeTicks': runTimeTicks,
      'PlayAccess': playAccess,
      'ProductionYear': productionYear,
      'RemoteTrailers': remoteTrailers != null
          ? List<dynamic>.from(remoteTrailers!.map((x) => x.toMap()))
          : null,
      'ProviderIds': providerIds,
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
      'People': people != null
          ? List<dynamic>.from(people!.map((x) => x.toMap()))
          : null,
      'Studios': studios != null
          ? List<dynamic>.from(studios!.map((x) => x.toMap()))
          : null,
      'GenreItems': genreItems != null
          ? List<dynamic>.from(genreItems!.map((x) => x.toMap()))
          : null,
      'LocalTrailerCount': localTrailerCount,
      'UserData': userData?.toMap(),
      'SpecialFeatureCount': specialFeatureCount,
      'DisplayPreferencesId': displayPreferencesId,
      'Tags': tags != null ? List<dynamic>.from(tags!.map((x) => x)) : null,
      'PrimaryImageAspectRatio': primaryImageAspectRatio,
      'MediaStreams': mediaStreams != null
          ? List<dynamic>.from(mediaStreams!.map((x) => x.toMap()))
          : null,
      'RecursiveItemCount': recursiveItemCount,
      'VideoType': videoType,
      'ImageTags': imageTags,
      'OfficialRating': officialRating,
      'SeriesPrimaryImageTag': seriesPrimaryImageTag,
      'SeriesName': seriesName,
      'BackdropImageTags': backdropImageTags != null
          ? List<dynamic>.from(backdropImageTags!.map((x) => x))
          : null,
      'ScreenshotImageTags': screenshotImageTags != null
          ? List<dynamic>.from(screenshotImageTags!.map((x) => x))
          : null,
      'ImageBlurHashes': imageBlurHashes?.toMap(),
      'Chapters': chapters != null
          ? List<dynamic>.from(chapters!.map((x) => x.toMap()))
          : null,
      'LocationType': locationType,
      'MediaType': itemTypeValues.reverse[mediaType],
      'LockedFields': lockedFields != null
          ? List<dynamic>.from(lockedFields!.map((x) => x))
          : null,
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
    if (userData?.playbackPositionTicks != null &&
        userData!.playbackPositionTicks > 0) {
      return true;
    }
    return false;
  }

  bool hasGenres() {
    if (genres != null) return genres!.isNotEmpty;
    return false;
  }

  bool hasArtists() {
    if (artists != null) return artists!.isNotEmpty;
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
    if (people != null) return people!.isNotEmpty;
    return false;
  }

  bool isPlayable() {
    final playableItems = [
      ItemType.AUDIO,
      ItemType.MUSICALBUM,
      ItemType.MUSICVIDEO,
      ItemType.MOVIE,
      ItemType.SERIES,
      ItemType.SEASON,
      ItemType.EPISODE,
      ItemType.BOOK,
      ItemType.VIDEO
    ];
    return playableItems.contains(type);
  }

  bool hasTrailer() {
    if (remoteTrailers != null || localTrailerCount != null) {
      return remoteTrailers != null
          ? remoteTrailers!.isNotEmpty
          : localTrailerCount! > 0;
    }
    return false;
  }

  String getTrailer() {
    return remoteTrailers!.elementAt(0).url;
  }

  bool canBeViewed() {
    final playableItems = [
      ItemType.MOVIE,
      ItemType.SERIES,
      ItemType.SEASON,
      ItemType.EPISODE,
      ItemType.BOOK,
      ItemType.VIDEO
    ];
    return playableItems.contains(type);
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
    if (mediaStreams != null && mediaStreams!.isNotEmpty) {
      mediaStream = mediaStreams!
          .firstWhere((element) => element.type == MediaStreamType.VIDEO);

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
    var secondValue = double.parse(
        aspectRatio.substring(separatorIndex + 1, aspectRatio.length));
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
    if (showParent) return aspectRatio(type: type);
    if (primaryImageAspectRatio != null) {
      if (primaryImageAspectRatio! > 0.0) {
        return primaryImageAspectRatio!;
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
    if (type == ItemType.SEASON) {
      if (imageTags == null && imageTags!.isEmpty) return id;
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
    return name;
  }

  /// Get collection type such as requested by API
  ///
  /// Return [String]
  ///
  /// Return correct collection type based on item one
  /// If nothing found then return current one
  List<ItemType> getCollectionType() {
    if (collectionType == CollectionType.MOVIES) {
      return [ItemType.MOVIE];
    } else if (collectionType == CollectionType.TVSHOWS) {
      return [ItemType.SERIES];
    } else if (collectionType == CollectionType.MUSIC) {
      return [ItemType.MUSICALBUM, ItemType.AUDIO];
    } else if (collectionType == CollectionType.BOOKS) {
      return [ItemType.BOOK];
    } else if (collectionType == CollectionType.HOMEVIDEOS) {
      return [ItemType.VIDEO];
    } else if (collectionType == CollectionType.BOXSETS) {
      return [ItemType.BOXSET];
    } else if (collectionType == CollectionType.MIXED) {
      return [
        ItemType.FOLDER,
        ItemType.AUDIO,
        ItemType.VIDEO,
        ItemType.BOOK,
        ItemType.MUSICALBUM,
        ItemType.SERIES,
        ItemType.MOVIE
      ];
    } else if (collectionType == CollectionType.MUSICVIDEOS) {
      return [ItemType.MUSICVIDEO];
    } else {
      return [ItemType.FOLDER];
    }
  }

  /// Get correct image id based on searchType
  ///
  /// Return [String]
  ///
  /// Return id as [String] if found
  /// Else return item's id as [String]
  String correctImageId(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY}) {
    // If of type logo we return only parent logo
    if (searchType == image_type.ImageType.LOGO) {
      switch (type) {
        case ItemType.SEASON:
        case ItemType.EPISODE:
          return seriesId ?? id;
        case ItemType.MUSICALBUM:
          return albumId ?? id;
        default:
          return id;
      }
    }
    switch (type) {
      case ItemType.EPISODE:
        return id;
      case ItemType.SEASON:
        return seriesId ?? id;
      case ItemType.MUSICALBUM:
      case ItemType.AUDIO:
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
  String? correctImageTags(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY}) {
    // If of type logo we return only parent logo
    if (searchType == image_type.ImageType.LOGO) {
      switch (type) {
        case ItemType.SEASON:
        case ItemType.EPISODE:
          return seriesPrimaryImageTag;
        case ItemType.MUSICALBUM:
          return albumPrimaryImageTag;
        default:
          return null;
      }
    } else if (imageTags != null && imageTags!.isNotEmpty) {
      switch (type) {
        case ItemType.EPISODE:
          return imageTags != null && imageTags!.isNotEmpty
              ? imageTags!
                  .firstWhere((element) => element.imageType == searchType,
                      orElse: () => imageTags!.first)
                  .value
              : null;
        case ItemType.SEASON:
          return seriesPrimaryImageTag;
        case ItemType.MUSICALBUM:
        case ItemType.AUDIO:
          return albumPrimaryImageTag;
        default:
          return null;
      }
    }
    return null;
  }

  /// Get correct image tags based on searchType
  ///
  /// Return [String]
  ///
  /// Return imageTag as [String] if found
  /// Else return [null]
  image_type.ImageType correctImageType(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY}) {
    // If of type logo we return only parent logo
    if (imageTags != null && imageTags!.isNotEmpty) {
      return imageTags!
          .firstWhere((element) => element.imageType == searchType,
              orElse: () => imageTags!.firstWhere(
                  (element) =>
                      element.imageType == image_type.ImageType.PRIMARY,
                  orElse: () => imageTags!.first))
          .imageType;
    }
    return searchType;
  }

  /// Play current item given context
  ///
  /// If Book open Epub reader
  /// If Video open video player
  void playItem() async {
    var musicProvider = MusicProvider();
    if (type == ItemType.EPISODE ||
        type == ItemType.SEASON ||
        type == ItemType.SERIES ||
        type == ItemType.MOVIE ||
        type == ItemType.VIDEO) {
      // return InitStreamingItemUtil.initFromItem(item: this);
      await customRouter.push(StreamRoute(item: this));
    } else if (type == ItemType.AUDIO) {
      var commonPlayer;
      if (Platform.isLinux || Platform.isWindows) {
        final player = vlc.Player(id: audioPlayerId);
        commonPlayer = CommonPlayer.parseVlcComputerController(player: player);
      } else {
        final assetsAudioPlayer =
            AssetsAudioPlayer.withId(audioPlayerId.toString());
        commonPlayer = CommonPlayer.parseAssetsAudioPlayer(
            assetsAudioPlayer: assetsAudioPlayer);
      }
      musicProvider.setCommonPlayer(commonPlayer);
      return await musicProvider.getCommonPlayer!.playRemoteAudio(this);
    } else if (type == ItemType.MUSICALBUM) {
      var commonPlayer;
      if (Platform.isLinux || Platform.isWindows) {
        final player = vlc.Player(id: audioPlayerId);
        commonPlayer = CommonPlayer.parseVlcComputerController(player: player);
      } else {
        final assetsAudioPlayer =
            AssetsAudioPlayer.withId(audioPlayerId.toString());
        commonPlayer = CommonPlayer.parseAssetsAudioPlayer(
            assetsAudioPlayer: assetsAudioPlayer);
      }
      musicProvider.setCommonPlayer(commonPlayer);
      return await musicProvider.playPlaylist(this);
    } else if (type == ItemType.BOOK) {
      await customRouter.replace(EpubReaderPageRoute(item: this));
    }
  }

  Future<String> getItemURL({bool directPlay = false}) async {
    await StreamingService.bitrateTest(size: 500000);
    await StreamingService.bitrateTest(size: 1000000);
    await StreamingService.bitrateTest(size: 3000000);
    var item;

    if (type == ItemType.EPISODE ||
        type == ItemType.MOVIE ||
        type == ItemType.VIDEO ||
        type == ItemType.MUSICVIDEO ||
        type == ItemType.AUDIO) {
      item = this;
    } else if (type == ItemType.SEASON || type == ItemType.SERIES) {
      item = await getFirstUnplayedItem();
    } else {
      throw ('Cannot find the type of file');
    }

    if (type == ItemType.AUDIO) {
      return createMusicURL();
    }
    return getStreamURL(item, directPlay);
  }

  Future<Item> getPlayableItemOrLastUnplayed() async {
    var item;

    if (type == ItemType.EPISODE ||
        type == ItemType.MOVIE ||
        type == ItemType.VIDEO ||
        type == ItemType.MUSICVIDEO ||
        type == ItemType.AUDIO) {
      item = this;
    } else if (type == ItemType.SEASON || type == ItemType.SERIES) {
      item = await getFirstUnplayedItem();
    } else {
      throw ('Cannot find the type of file');
    }
    return item;
  }

  Future<Item> getFirstUnplayedItem() async {
    var category = await ItemService.getItems(
        parentId: id, filter: 'IsNotFolder', fields: 'MediaStreams');
    // remove all item without an index to avoid sort error
    category.items.removeWhere((element) => element.indexNumber == null);
    // sort by index to get the next item to stream
    category.items.sort((a, b) => a.indexNumber!.compareTo(b.indexNumber!));
    return category.items.firstWhere((element) => !element.userData!.played,
        orElse: () => category.items.first);
  }

  Future<String> getStreamURL(Item item, bool directPlay) async {
    var streamingProvider = StreamingProvider();
    var data = await StreamingService.isCodecSupported();
    var backInfos = await StreamingService.playbackInfos(data, item.id,
        startTimeTick: item.userData!.playbackPositionTicks);
    var completeTranscodeUrl;
    var finalUrl;

    // Check if we have a transcide url or we create it
    if (backInfos.isTranscoding() && !directPlay) {
      completeTranscodeUrl =
          '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
    }
    finalUrl = completeTranscodeUrl ??
        await StreamingService.createURL(item, backInfos,
            startTick: item.userData!.playbackPositionTicks);

    // Current item, playbackinfos, stream url and direct play bool
    streamingProvider
        .setIsDirectPlay(completeTranscodeUrl != null ? false : true);
    streamingProvider.setPlaybackInfos(backInfos);
    streamingProvider.setURL(finalUrl);
    return finalUrl;
  }

  String concatenateGenre({int? maxGenre}) {
    var max = genres!.length;
    if (maxGenre != null) {
      max = genres!.length > maxGenre ? maxGenre : genres!.length;
    }

    if (genres != null) {
      return genres!.getRange(0, max).join(', ').toString();
    }
    return '';
  }

  String concatenateArtists({int? maxArtists}) {
    var max = artists!.length;
    if (maxArtists != null) {
      max = artists!.length > maxArtists ? maxArtists : artists!.length;
    }

    if (artists != null) {
      return artists!.getRange(0, max).map((e) => e.name).join(', ').toString();
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
        .getSettingsById(userApp!.settingsId);
    var streamingSoftware = TranscodeAudioCodecName.values.firstWhere((e) =>
        e.toString() ==
        'TranscodeAudioCodecName.' +
            streamingSoftwareDB.preferredTranscodeAudioCodec);
    return '${server.url}/Audio/$id/stream.$streamingSoftware';
  }

  List<MediaStream> getMediaStreamFromType({required MediaStreamType type}) {
    return mediaStreams!.where((element) => element.type == type).toList();
  }

  Future<Uri> getYoutubeTrailerUrl() async {
    final youtubeUrl = getTrailer();
    final itemURi = Uri.parse(youtubeUrl);
    final videoId = itemURi.queryParameters['v'];
    final yt = YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final streamInfo = manifest.muxed.withHighestBitrate();
    yt.close();
    return streamInfo.url;
  }
}
