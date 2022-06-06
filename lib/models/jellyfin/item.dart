// To parse this JSON data, do
//
//     final media = itemFromMap(jsonString);

import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:jellyflut/database/database.dart' as db;
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/collection_type.dart';
import 'package:jellyflut/models/enum/image_type.dart' as image_type;
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/enum/item_type.dart';
import 'package:jellyflut/models/enum/media_stream_type.dart';
import 'package:jellyflut/models/enum/transcode_audio_codec.dart';
import 'package:jellyflut/models/jellyfin/remote_trailer.dart';
import 'package:jellyflut/models/jellyfin/studio.dart';
import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/providers/streaming/streaming_provider.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/services/file/file_service.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/services/streaming/streaming_service.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:just_audio/just_audio.dart';
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
    required this.id,
    required this.type,
    this.serverId,
    this.originalTitle,
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
    this.externalUrls = const <ExternalUrl>[],
    this.mediaSources = const <MediaSource>[],
    this.criticRating,
    this.productionLocations = const <String>[],
    this.path,
    this.enableMediaSourceDisplay,
    this.overview,
    this.taglines = const <String>[],
    this.genres = const <String>[],
    this.number,
    this.channelNumber,
    this.channelType,
    this.channelId,
    this.currentProgram,
    this.startDate,
    this.endDate,
    this.communityRating,
    this.runTimeTicks,
    this.playAccess,
    this.productionYear,
    this.childCount,
    this.remoteTrailers = const <RemoteTrailer>[],
    this.providerIds = const <String, dynamic>{},
    this.isHd,
    this.isFolder,
    this.parentId,
    this.seriesId,
    this.seasonId,
    this.artists = const <Artist>[],
    this.artistItems = const <ArtistItems>[],
    this.album,
    this.albumId,
    this.albumPrimaryImageTag,
    this.albumArtist,
    this.albumArtists = const <AlbumArtists>[],
    this.people = const <Person>[],
    this.studios = const <Studio>[],
    this.genreItems = const <GenreItem>[],
    this.localTrailerCount,
    this.userData,
    this.specialFeatureCount,
    this.displayPreferencesId,
    this.tags = const <dynamic>[],
    this.primaryImageAspectRatio,
    this.mediaStreams = const <MediaStream>[],
    this.recursiveItemCount,
    this.videoType,
    this.imageTags = const <ImageTag>[],
    this.officialRating,
    this.seriesPrimaryImageTag,
    this.seriesName,
    this.backdropImageTags = const <String>[],
    this.screenshotImageTags = const <dynamic>[],
    this.imageBlurHashes,
    this.chapters = const <Chapter>[],
    this.locationType,
    this.mediaType,
    this.lockedFields = const <dynamic>[],
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
  String? number;
  String? channelNumber;
  String? channelId;
  String? channelType;
  Item? currentProgram;
  DateTime? startDate;
  DateTime? endDate;
  List<ExternalUrl> externalUrls;
  List<MediaSource> mediaSources;
  int? criticRating;
  List<String> productionLocations;
  String? path;
  bool? enableMediaSourceDisplay;
  String? overview;
  List<String> taglines;
  List<String> genres;
  double? communityRating;
  int? runTimeTicks;
  String? playAccess;
  int? productionYear;
  int? childCount;
  List<RemoteTrailer> remoteTrailers;
  Map<String, dynamic> providerIds;
  bool? isHd;
  bool? isFolder;
  String? parentId;
  String? seriesId;
  String? seasonId;
  ItemType type;
  List<Artist> artists;
  List<ArtistItems> artistItems;
  String? album;
  String? albumId;
  String? albumPrimaryImageTag;
  String? albumArtist;
  List<AlbumArtists> albumArtists;
  List<Person> people;
  List<Studio> studios;
  List<GenreItem> genreItems;
  int? localTrailerCount;
  UserData? userData;
  int? specialFeatureCount;
  String? displayPreferencesId;
  List<dynamic> tags;
  double? primaryImageAspectRatio;
  List<MediaStream> mediaStreams;
  int? recursiveItemCount;
  String? videoType;
  List<ImageTag> imageTags;
  String? officialRating;
  String? seriesPrimaryImageTag;
  String? seriesName;
  List<String> backdropImageTags;
  List<dynamic> screenshotImageTags;
  ImageBlurHashes? imageBlurHashes;
  List<Chapter> chapters;
  String? locationType;
  MediaStreamType? mediaType;
  List<dynamic> lockedFields;
  bool? lockData;
  int? width;
  int? height;

  factory Item.fromMap(Map<String, dynamic> json) => Item(
        name: json['Name'] ?? '',
        originalTitle: json['OriginalTitle'],
        serverId: json['ServerId'],
        id: json['Id'],
        indexNumber: json['IndexNumber'],
        parentIndexNumber: json['ParentIndexNumber'],
        etag: json['Etag'],
        collectionType: json['CollectionType'] != null
            ? CollectionType.fromString(json['CollectionType'])
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
            ? <ExternalUrl>[]
            : List<ExternalUrl>.from(
                json['ExternalUrls'].map((x) => ExternalUrl.fromMap(x))),
        mediaSources: json['MediaSources'] == null
            ? <MediaSource>[]
            : List<MediaSource>.from(
                json['MediaSources'].map((x) => MediaSource.fromMap(x))),
        criticRating: json['CriticRating'],
        productionLocations: json['ProductionLocations'] == null
            ? <String>[]
            : List<String>.from(json['ProductionLocations'].map((x) => x)),
        path: json['Path'],
        enableMediaSourceDisplay: json['EnableMediaSourceDisplay'],
        overview: json['Overview'],
        taglines: json['Taglines'] == null
            ? <String>[]
            : List<String>.from(json['Taglines'].map((x) => x)),
        genres: json['Genres'] == null
            ? <String>[]
            : List<String>.from(json['Genres'].map((x) => x)),
        communityRating: json['CommunityRating']?.toDouble(),
        runTimeTicks: json['RunTimeTicks'],
        playAccess: json['PlayAccess'],
        productionYear: json['ProductionYear'],
        childCount: json['ChildCount'],
        remoteTrailers: json['RemoteTrailers'] == null
            ? <RemoteTrailer>[]
            : List<RemoteTrailer>.from(
                json['RemoteTrailers'].map((x) => RemoteTrailer.fromMap(x))),
        providerIds: json['ProviderIds'] ?? <String, dynamic>{},
        isHd: json['IsHD'] == null ? null : json['isHd'],
        isFolder: json['IsFolder'],
        parentId: json['ParentId'],
        seriesId: json['SeriesId'],
        seasonId: json['SeasonId'],
        type: ItemType.fromString(json['Type']),
        artists: json['Artists'] == null
            ? <Artist>[]
            : List<Artist>.from(json['Artists'].map((x) => Artist.fromMap(x))),
        artistItems: json['ArtistItems'] == null
            ? <ArtistItems>[]
            : List<ArtistItems>.from(
                json['ArtistItems'].map((x) => ArtistItems.fromMap(x))),
        album: json['Album'],
        albumId: json['AlbumId'],
        albumPrimaryImageTag: json['AlbumPrimaryImageTag'],
        albumArtist: json['AlbumArtist'],
        albumArtists: json['AlbumArtists'] == null
            ? <AlbumArtists>[]
            : List<AlbumArtists>.from(
                json['AlbumArtists'].map((x) => AlbumArtists.fromMap(x))),
        people: json['People'] == null
            ? <Person>[]
            : List<Person>.from(json['People'].map((x) => Person.fromMap(x))),
        studios: json['Studios'] == null
            ? <Studio>[]
            : List<Studio>.from(json['Studios'].map((x) => Studio.fromMap(x))),
        genreItems: json['GenreItems'] == null
            ? <GenreItem>[]
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
            ? <dynamic>[]
            : List<dynamic>.from(json['Tags'].map((x) => x)),
        primaryImageAspectRatio: json['PrimaryImageAspectRatio']?.toDouble(),
        mediaStreams: json['MediaStreams'] == null
            ? <MediaStream>[]
            : List<MediaStream>.from(
                json['MediaStreams'].map((x) => MediaStream.fromMap(x))),
        recursiveItemCount: json['RecursiveItemCount'],
        videoType: json['VideoType'],
        imageTags: List<ImageTag>.from(ImageTag.fromMap(json['ImageTags'])),
        officialRating: json['OfficialRating'],
        seriesPrimaryImageTag: json['SeriesPrimaryImageTag'],
        seriesName: json['SeriesName'],
        number: json['Number'],
        channelNumber: json['ChannelNumber'],
        channelId: json['ChannelId'],
        channelType: json['ChannelType'],
        startDate: json['StartDate'] == null
            ? null
            : DateTime.parse(json['StartDate']),
        endDate:
            json['EndDate'] == null ? null : DateTime.parse(json['EndDate']),
        currentProgram: json['CurrentProgram'] == null
            ? null
            : Item.fromMap(json['CurrentProgram']),
        backdropImageTags: json['BackdropImageTags'] == null
            ? <String>[]
            : List<String>.from(json['BackdropImageTags'].map((x) => x)),
        screenshotImageTags: json['ScreenshotImageTags'] == null
            ? <dynamic>[]
            : List<dynamic>.from(json['ScreenshotImageTags'].map((x) => x)),
        imageBlurHashes: json['ImageBlurHashes'] == null
            ? null
            : ImageBlurHashes.fromMap(json['ImageBlurHashes']),
        chapters: json['Chapters'] == null
            ? <Chapter>[]
            : List<Chapter>.from(
                json['Chapters'].map((x) => Chapter.fromMap(x))),
        locationType: json['LocationType'],
        mediaType: json['MediaType'] != null
            ? MediaStreamType.fromString(json['MediaType'])
            : null,
        lockedFields: json['LockedFields'] == null
            ? <dynamic>[]
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
      'ExternalUrls': externalUrls.isNotEmpty
          ? List<dynamic>.from(externalUrls.map((x) => x.toMap()))
          : null,
      'MediaSources': mediaSources.isNotEmpty
          ? List<dynamic>.from(mediaSources.map((x) => x.toMap()))
          : null,
      'CriticRating': criticRating,
      'ProductionLocations': productionLocations.isNotEmpty
          ? List<dynamic>.from(productionLocations.map((x) => x))
          : null,
      'Path': path,
      'EnableMediaSourceDisplay': enableMediaSourceDisplay,
      'Overview': overview,
      'Taglines': taglines.isNotEmpty
          ? List<dynamic>.from(taglines.map((x) => x))
          : null,
      'Genres':
          genres.isNotEmpty ? List<dynamic>.from(genres.map((x) => x)) : null,
      'CommunityRating': communityRating,
      'RunTimeTicks': runTimeTicks,
      'PlayAccess': playAccess,
      'ProductionYear': productionYear,
      'ChildCount': childCount,
      'RemoteTrailers': remoteTrailers.isNotEmpty
          ? List<dynamic>.from(remoteTrailers.map((x) => x.toMap()))
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
      'People': people.isNotEmpty
          ? List<dynamic>.from(people.map((x) => x.toMap()))
          : null,
      'Studios': studios.isNotEmpty
          ? List<dynamic>.from(studios.map((x) => x.toMap()))
          : null,
      'GenreItems': genreItems.isNotEmpty
          ? List<dynamic>.from(genreItems.map((x) => x.toMap()))
          : null,
      'LocalTrailerCount': localTrailerCount,
      'UserData': userData?.toMap(),
      'SpecialFeatureCount': specialFeatureCount,
      'DisplayPreferencesId': displayPreferencesId,
      'Tags': tags.isNotEmpty ? List<dynamic>.from(tags.map((x) => x)) : null,
      'PrimaryImageAspectRatio': primaryImageAspectRatio,
      'MediaStreams': mediaStreams.isNotEmpty
          ? List<dynamic>.from(mediaStreams.map((x) => x.toMap()))
          : null,
      'RecursiveItemCount': recursiveItemCount,
      'VideoType': videoType,
      'ImageTags': imageTags,
      'Number': number,
      'channelNumber': channelNumber,
      'channelType': channelType,
      'ChannelId': channelId,
      'CurrentProgram': currentProgram,
      'StartDate': startDate,
      'EndDate': endDate,
      'OfficialRating': officialRating,
      'SeriesPrimaryImageTag': seriesPrimaryImageTag,
      'SeriesName': seriesName,
      'BackdropImageTags': backdropImageTags.isNotEmpty
          ? List<dynamic>.from(backdropImageTags.map((x) => x))
          : null,
      'ScreenshotImageTags': screenshotImageTags.isNotEmpty
          ? List<dynamic>.from(screenshotImageTags.map((x) => x))
          : null,
      'ImageBlurHashes': imageBlurHashes?.toMap(),
      'Chapters': chapters.isNotEmpty
          ? List<dynamic>.from(chapters.map((x) => x.toMap()))
          : null,
      'LocationType': locationType,
      'MediaType': mediaType?.value,
      'LockedFields': lockedFields.isNotEmpty
          ? List<dynamic>.from(lockedFields.map((x) => x))
          : null,
      'LockData': lockData,
      'Width': width,
      'Height': height,
    };
    return map;
  }

  dynamic operator [](String key) {
    if (key == 'name') return name;
    if (key == 'id') return id;
    if (key == 'type') return type;
    if (key == 'originalTitle') return originalTitle;
    if (key == 'indexNumber') return indexNumber;
    if (key == 'parentIndexNumber') return parentIndexNumber;
    if (key == 'etag') return etag;
    if (key == 'collectionType') return collectionType;
    if (key == 'dateCreated') return dateCreated;
    if (key == 'canDelete') return canDelete;
    if (key == 'canDownload') return canDownload;
    if (key == 'hasSubtitles') return hasSubtitles;
    if (key == 'container') return container;
    if (key == 'sortName') return sortName;
    if (key == 'premiereDate') return premiereDate;
    if (key == 'externalUrls') return externalUrls;
    if (key == 'mediaSources') return mediaSources;
    if (key == 'criticRating') return criticRating;
    if (key == 'productionLocations') return productionLocations;
    if (key == 'path') return path;
    if (key == 'enableMediaSourceDisplay') return enableMediaSourceDisplay;
    if (key == 'overview') return overview;
    if (key == 'taglines') return taglines;
    if (key == 'genres') return genres;
    if (key == 'number') return number;
    if (key == 'channelNumber') return channelNumber;
    if (key == 'channelType') return channelType;
    if (key == 'channelId') return channelId;
    if (key == 'currentProgram') return currentProgram;
    if (key == 'startDate') return startDate;
    if (key == 'endDate') return endDate;
    if (key == 'communityRating') return communityRating;
    if (key == 'runTimeTicks') return runTimeTicks;
    if (key == 'playAccess') return playAccess;
    if (key == 'productionYear') return productionYear;
    if (key == 'childCount') return childCount;
    if (key == 'remoteTrailers') return remoteTrailers;
    if (key == 'providerIds') return providerIds;
    if (key == 'isHd') return isHd;
    if (key == 'isFolder') return isFolder;
    if (key == 'parentId') return parentId;
    if (key == 'seriesId') return seriesId;
    if (key == 'seasonId') return seasonId;
    if (key == 'artists') return artists;
    if (key == 'artistItems') return artistItems;
    if (key == 'album') return album;
    if (key == 'albumId') return albumId;
    if (key == 'albumPrimaryImageTag') return albumPrimaryImageTag;
    if (key == 'albumArtist') return albumArtist;
    if (key == 'albumArtists') return albumArtists;
    if (key == 'people') return people;
    if (key == 'studios') return studios;
    if (key == 'genreItems') return genreItems;
    if (key == 'localTrailerCount') return localTrailerCount;
    if (key == 'userData') return userData;
    if (key == 'specialFeatureCount') return specialFeatureCount;
    if (key == 'displayPreferencesId') return displayPreferencesId;
    if (key == 'tags') return tags;
    if (key == 'primaryImageAspectRatio') return primaryImageAspectRatio;
    if (key == 'mediaStreams') return mediaStreams;
    if (key == 'recursiveItemCount') return recursiveItemCount;
    if (key == 'videoType') return videoType;
    if (key == 'imageTags') return imageTags;
    if (key == 'officialRating') return officialRating;
    if (key == 'seriesPrimaryImageTag') return seriesPrimaryImageTag;
    if (key == 'seriesName') return seriesName;
    if (key == 'backdropImageTags') return backdropImageTags;
    if (key == 'screenshotImageTags') return screenshotImageTags;
    if (key == 'imageBlurHashes') return imageBlurHashes;
    if (key == 'chapters') return chapters;
    if (key == 'locationType') return locationType;
    if (key == 'mediaType') return mediaType;
    if (key == 'lockedFields') return lockedFields;
    if (key == 'lockData') return lockData;
    if (key == 'width') return width;
    if (key == 'height') return height;
  }

  void operator []=(String key, dynamic value) {
    if (key == 'id') id = value;
    if (key == 'name') name = value;
    if (key == 'type') type = value;
    if (key == 'originalTitle') originalTitle = value;
    if (key == 'indexNumber') indexNumber = value;
    if (key == 'parentIndexNumber') parentIndexNumber = value;
    if (key == 'etag') etag = value;
    if (key == 'collectionType') collectionType = value;
    if (key == 'dateCreated') dateCreated = value;
    if (key == 'canDelete') canDelete = value;
    if (key == 'canDownload') canDownload = value;
    if (key == 'hasSubtitles') hasSubtitles = value;
    if (key == 'container') container = value;
    if (key == 'sortName') sortName = value;
    if (key == 'premiereDate') premiereDate = value;
    if (key == 'externalUrls') externalUrls = value;
    if (key == 'mediaSources') mediaSources = value;
    if (key == 'criticRating') criticRating = value;
    if (key == 'productionLocations') productionLocations = value;
    if (key == 'path') path = value;
    if (key == 'enableMediaSourceDisplay') enableMediaSourceDisplay = value;
    if (key == 'overview') overview = value;
    if (key == 'taglines') taglines = value;
    if (key == 'genres') genres = value;
    if (key == 'number') number = value;
    if (key == 'channelNumber') channelNumber = value;
    if (key == 'channelType') channelType = value;
    if (key == 'channelId') channelId = value;
    if (key == 'currentProgram') currentProgram = value;
    if (key == 'startDate') startDate = value;
    if (key == 'endDate') endDate = value;
    if (key == 'communityRating') communityRating = value;
    if (key == 'runTimeTicks') runTimeTicks = value;
    if (key == 'playAccess') playAccess = value;
    if (key == 'productionYear') productionYear = value;
    if (key == 'childCount') childCount = value;
    if (key == 'remoteTrailers') remoteTrailers = value;
    if (key == 'providerIds') providerIds = value;
    if (key == 'isHd') isHd = value;
    if (key == 'isFolder') isFolder = value;
    if (key == 'parentId') parentId = value;
    if (key == 'seriesId') seriesId = value;
    if (key == 'seasonId') seasonId = value;
    if (key == 'artists') artists = value;
    if (key == 'artistItems') artistItems = value;
    if (key == 'album') album = value;
    if (key == 'albumId') albumId = value;
    if (key == 'albumPrimaryImageTag') albumPrimaryImageTag = value;
    if (key == 'albumArtist') albumArtist = value;
    if (key == 'albumArtists') albumArtists = value;
    if (key == 'people') people = value;
    if (key == 'studios') studios = value;
    if (key == 'genreItems') genreItems = value;
    if (key == 'localTrailerCount') localTrailerCount = value;
    if (key == 'userData') userData = value;
    if (key == 'specialFeatureCount') specialFeatureCount = value;
    if (key == 'displayPreferencesId') displayPreferencesId = value;
    if (key == 'tags') tags = value;
    if (key == 'primaryImageAspectRatio') primaryImageAspectRatio = value;
    if (key == 'mediaStreams') mediaStreams = value;
    if (key == 'recursiveItemCount') recursiveItemCount = value;
    if (key == 'videoType') videoType = value;
    if (key == 'imageTags') imageTags = value;
    if (key == 'officialRating') officialRating = value;
    if (key == 'seriesPrimaryImageTag') seriesPrimaryImageTag = value;
    if (key == 'seriesName') seriesName = value;
    if (key == 'backdropImageTags') backdropImageTags = value;
    if (key == 'screenshotImageTags') screenshotImageTags = value;
    if (key == 'imageBlurHashes') imageBlurHashes = value;
    if (key == 'chapters') chapters = value;
    if (key == 'locationType') locationType = value;
    if (key == 'mediaType') mediaType = value;
    if (key == 'lockedFields') lockedFields = value;
    if (key == 'lockData') lockData = value;
    if (key == 'width') width = value;
    if (key == 'height') height = value;
  }

  Item copyWith(
      {required String name,
      required String id,
      required ItemType type,
      String? originalTitle,
      String? serverId,
      int? indexNumber,
      int? parentIndexNumber,
      String? etag,
      CollectionType? collectionType,
      DateTime? dateCreated,
      bool? canDelete,
      bool? canDownload,
      bool? hasSubtitles,
      String? container,
      String? sortName,
      DateTime? premiereDate,
      List<ExternalUrl>? externalUrls,
      List<MediaSource>? mediaSources,
      int? criticRating,
      List<String>? productionLocations,
      String? path,
      bool? enableMediaSourceDisplay,
      String? overview,
      List<String>? taglines,
      List<String>? genres,
      double? communityRating,
      int? runTimeTicks,
      String? playAccess,
      int? productionYear,
      List<RemoteTrailer>? remoteTrailers,
      Map<String, dynamic>? providerIds,
      bool? isHd,
      bool? isFolder,
      String? parentId,
      String? seriesId,
      String? seasonId,
      List<Artist>? artists,
      List<ArtistItems>? artistItems,
      String? album,
      String? albumId,
      String? albumPrimaryImageTag,
      String? albumArtist,
      List<AlbumArtists>? albumArtists,
      List<Person>? people,
      List<Studio>? studios,
      List<GenreItem>? genreItems,
      int? localTrailerCount,
      UserData? userData,
      int? specialFeatureCount,
      String? displayPreferencesId,
      List<dynamic>? tags,
      double? primaryImageAspectRatio,
      List<MediaStream>? mediaStreams,
      int? recursiveItemCount,
      String? videoType,
      List<ImageTag>? imageTags,
      String? officialRating,
      String? seriesPrimaryImageTag,
      String? seriesName,
      List<String>? backdropImageTags,
      List<dynamic>? screenshotImageTags,
      ImageBlurHashes? imageBlurHashes,
      List<Chapter>? chapters,
      String? locationType,
      MediaStreamType? mediaType,
      List<dynamic>? lockedFields,
      bool? lockData,
      int? width,
      int? height}) {
    return Item(
        name: name,
        originalTitle: originalTitle ?? this.originalTitle,
        serverId: serverId ?? this.serverId,
        id: id,
        indexNumber: indexNumber ?? this.indexNumber,
        parentIndexNumber: parentIndexNumber ?? this.parentIndexNumber,
        etag: etag ?? this.etag,
        collectionType: collectionType ?? this.collectionType,
        dateCreated: dateCreated ?? this.dateCreated,
        canDelete: canDelete ?? this.canDelete,
        canDownload: canDownload ?? this.canDownload,
        hasSubtitles: hasSubtitles ?? this.hasSubtitles,
        container: container ?? this.container,
        sortName: sortName ?? this.sortName,
        premiereDate: premiereDate ?? this.premiereDate,
        externalUrls: externalUrls ?? this.externalUrls,
        mediaSources: mediaSources ?? this.mediaSources,
        criticRating: criticRating ?? this.criticRating,
        productionLocations: productionLocations ?? this.productionLocations,
        path: path ?? this.path,
        enableMediaSourceDisplay:
            enableMediaSourceDisplay ?? this.enableMediaSourceDisplay,
        overview: overview ?? this.overview,
        taglines: taglines ?? this.taglines,
        genres: genres ?? this.genres,
        communityRating: communityRating ?? this.communityRating,
        runTimeTicks: runTimeTicks ?? this.runTimeTicks,
        playAccess: playAccess ?? this.playAccess,
        productionYear: productionYear ?? this.productionYear,
        remoteTrailers: remoteTrailers ?? this.remoteTrailers,
        providerIds: providerIds ?? this.providerIds,
        isHd: isHd ?? this.isHd,
        isFolder: isFolder ?? this.isFolder,
        parentId: parentId ?? this.parentId,
        seriesId: seriesId ?? this.seriesId,
        seasonId: seasonId ?? this.seasonId,
        type: type,
        artists: artists ?? this.artists,
        artistItems: artistItems ?? this.artistItems,
        album: album ?? this.album,
        albumId: albumId ?? this.albumId,
        albumPrimaryImageTag: albumPrimaryImageTag ?? this.albumPrimaryImageTag,
        albumArtist: albumArtist ?? this.albumArtist,
        albumArtists: albumArtists ?? this.albumArtists,
        people: people ?? this.people,
        studios: studios ?? this.studios,
        genreItems: genreItems ?? this.genreItems,
        localTrailerCount: localTrailerCount ?? this.localTrailerCount,
        userData: userData ?? this.userData,
        specialFeatureCount: specialFeatureCount ?? this.specialFeatureCount,
        displayPreferencesId: displayPreferencesId ?? this.displayPreferencesId,
        tags: tags ?? this.tags,
        primaryImageAspectRatio:
            primaryImageAspectRatio ?? this.primaryImageAspectRatio,
        mediaStreams: mediaStreams ?? this.mediaStreams,
        recursiveItemCount: recursiveItemCount ?? this.recursiveItemCount,
        videoType: videoType ?? this.videoType,
        imageTags: imageTags ?? this.imageTags,
        officialRating: officialRating ?? this.officialRating,
        seriesPrimaryImageTag:
            seriesPrimaryImageTag ?? this.seriesPrimaryImageTag,
        seriesName: seriesName ?? this.seriesName,
        backdropImageTags: backdropImageTags ?? this.backdropImageTags,
        screenshotImageTags: screenshotImageTags ?? this.screenshotImageTags,
        imageBlurHashes: imageBlurHashes ?? this.imageBlurHashes,
        chapters: chapters ?? this.chapters,
        locationType: locationType ?? this.locationType,
        mediaType: mediaType ?? this.mediaType,
        lockedFields: lockedFields ?? this.lockedFields,
        lockData: lockData ?? this.lockData,
        width: width ?? this.width,
        height: height ?? this.height);
  }

  Item copyWithItem({required Item item}) {
    return Item(
        name: item.name,
        originalTitle: item.originalTitle ?? originalTitle,
        serverId: item.serverId ?? serverId,
        id: item.id,
        indexNumber: item.indexNumber ?? indexNumber,
        parentIndexNumber: item.parentIndexNumber ?? parentIndexNumber,
        etag: item.etag ?? etag,
        collectionType: item.collectionType ?? collectionType,
        dateCreated: item.dateCreated ?? dateCreated,
        canDelete: item.canDelete ?? canDelete,
        canDownload: item.canDownload ?? canDownload,
        hasSubtitles: item.hasSubtitles ?? hasSubtitles,
        container: item.container ?? container,
        sortName: item.sortName ?? sortName,
        premiereDate: item.premiereDate ?? premiereDate,
        externalUrls: item.externalUrls,
        mediaSources: item.mediaSources,
        criticRating: item.criticRating ?? criticRating,
        productionLocations: item.productionLocations,
        path: item.path ?? path,
        enableMediaSourceDisplay:
            item.enableMediaSourceDisplay ?? enableMediaSourceDisplay,
        overview: item.overview ?? overview,
        taglines: item.taglines,
        genres: item.genres,
        communityRating: item.communityRating ?? communityRating,
        runTimeTicks: item.runTimeTicks ?? runTimeTicks,
        playAccess: item.playAccess ?? playAccess,
        productionYear: item.productionYear ?? productionYear,
        remoteTrailers: item.remoteTrailers,
        providerIds: item.providerIds,
        isHd: item.isHd ?? isHd,
        isFolder: item.isFolder ?? isFolder,
        parentId: item.parentId ?? parentId,
        seriesId: item.seriesId ?? seriesId,
        seasonId: item.seasonId ?? seasonId,
        type: item.type,
        artists: item.artists,
        artistItems: item.artistItems,
        album: item.album ?? album,
        albumId: item.albumId ?? albumId,
        albumPrimaryImageTag: item.albumPrimaryImageTag ?? albumPrimaryImageTag,
        albumArtist: item.albumArtist ?? albumArtist,
        albumArtists: item.albumArtists,
        people: item.people,
        studios: item.studios,
        genreItems: item.genreItems,
        localTrailerCount: item.localTrailerCount ?? localTrailerCount,
        userData: item.userData ?? userData,
        specialFeatureCount: item.specialFeatureCount ?? specialFeatureCount,
        displayPreferencesId: item.displayPreferencesId ?? displayPreferencesId,
        tags: item.tags,
        primaryImageAspectRatio:
            item.primaryImageAspectRatio ?? primaryImageAspectRatio,
        mediaStreams: item.mediaStreams,
        recursiveItemCount: item.recursiveItemCount ?? recursiveItemCount,
        videoType: item.videoType ?? videoType,
        imageTags: item.imageTags,
        officialRating: item.officialRating ?? officialRating,
        seriesPrimaryImageTag:
            item.seriesPrimaryImageTag ?? seriesPrimaryImageTag,
        seriesName: item.seriesName ?? seriesName,
        backdropImageTags: item.backdropImageTags,
        screenshotImageTags: item.screenshotImageTags,
        imageBlurHashes: item.imageBlurHashes ?? imageBlurHashes,
        chapters: item.chapters,
        locationType: item.locationType ?? locationType,
        mediaType: item.mediaType ?? mediaType,
        lockedFields: item.lockedFields,
        lockData: item.lockData ?? lockData,
        width: item.width ?? width,
        height: item.height ?? height);
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
      ItemType.AUDIO,
      ItemType.MUSICALBUM,
      ItemType.MUSICVIDEO,
      ItemType.TVCHANNEL,
      ItemType.MOVIE,
      ItemType.SERIES,
      ItemType.SEASON,
      ItemType.EPISODE,
      ItemType.BOOK,
      ItemType.VIDEO
    ];
    return playableItems.contains(type);
  }

  /// Tell if current item is playable (not like [isPlayableOrCanHavePlayableChilren()])
  /// Return [true] if item ocan be played
  /// Else return [false] if not playable
  bool isPlayable() {
    final playableItems = [
      ItemType.MOVIE,
      ItemType.EPISODE,
      ItemType.PHOTO,
      ItemType.RECORDING,
      ItemType.VIDEO,
      ItemType.MUSICVIDEO,
      ItemType.AUDIO,
      ItemType.BOOK,
      ItemType.VIDEO
    ];
    return playableItems.contains(type);
  }

  bool isDownloable() {
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

  bool isCollectionPlayable() {
    final playableItems = [
      CollectionType.BOOKS,
      CollectionType.HOMEVIDEOS,
      CollectionType.LIVETV,
      CollectionType.MOVIES,
      CollectionType.TVSHOWS,
      CollectionType.MUSICVIDEOS,
      CollectionType.MUSIC,
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
      return remoteTrailers.isNotEmpty
          ? remoteTrailers.isNotEmpty
          : localTrailerCount! > 0;
    }
    return false;
  }

  /// Tell if item can be viewed in sense of already played before
  /// Return [yes] if already seen (played)
  /// Else returl [false] if not seen (played)
  bool isViewable() {
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

  /// Method to get trailer
  /// WIP
  /// Return only he first of item of collection for nom
  String getTrailer() {
    // TODO add a possibility to choose remote trailer
    return remoteTrailers.elementAt(0).url;
  }

  ///Check if original title is different from Localized title
  ///
  /// Return [true] if is different
  /// Return [false] if same
  bool haveDifferentOriginalTitle() {
    return originalTitle != null &&
        originalTitle!.toLowerCase() != name.toLowerCase();
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
      mediaStream = mediaStreams
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
    if (showParent) return parentAspectRatio(type: type);
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
    return name;
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
      return [];
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
        case ItemType.SERIES:
          return seriesPrimaryImageTag;
        case ItemType.MUSICALBUM:
          return albumPrimaryImageTag;
        default:
          return null;
      }
    } else if (imageTags.isNotEmpty) {
      switch (type) {
        case ItemType.SEASON:
          return seriesPrimaryImageTag;
        case ItemType.MUSICALBUM:
        case ItemType.AUDIO:
          return albumPrimaryImageTag;
        default:
          return getImageTagBySearchTypeOrFirstOne(searchType: searchType)
              ?.value;
      }
    }
    return null;
  }

  ImageTag? getImageTagBySearchTypeOrFirstOne(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY}) {
    return imageTags.isNotEmpty
        ? imageTags.firstWhere((element) => element.imageType == searchType,
            orElse: () => imageTags.first)
        : null;
  }

  ImageTag? getImageTagBySearchTypeOrNull(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY}) {
    return imageTags.isNotEmpty
        ? imageTags
            .firstWhereOrNull((element) => element.imageType == searchType)
        : null;
  }

  /// Get correct image tags based on searchType
  ///
  /// Return [String]
  ///
  /// Return imageTag as [String] if found
  /// Else return [null]
  image_type.ImageType correctImageType(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY}) {
    // If we search correct image type for a logo that do not exist we still
    //return a logo tag and not a primary one as backup (or it will be ugly)
    late final backupSearchType;
    if (searchType == image_type.ImageType.LOGO) {
      backupSearchType = image_type.ImageType.LOGO;
    } else {
      backupSearchType = image_type.ImageType.PRIMARY;
    }

    // If of type logo we return only parent logo
    if (searchType == image_type.ImageType.BACKDROP &&
        backdropImageTags.isNotEmpty) {
      return searchType;
    } else if (imageTags.isNotEmpty) {
      return getImageTypeBySearchTypeOrBackup(
          searchType: searchType, backupSearchType: backupSearchType);
    }
    return searchType;
  }

  ImageType getImageTypeBySearchTypeOrBackup(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY,
      required image_type.ImageType backupSearchType}) {
    return imageTags
        .firstWhere((element) => element.imageType == searchType,
            orElse: () => ImageTag(imageType: backupSearchType, value: ''))
        .imageType;
  }

  ImageType? getImageTypeBySearchTypeOrNull(
      {image_type.ImageType searchType = image_type.ImageType.PRIMARY}) {
    return imageTags
        .firstWhereOrNull((element) => element.imageType == searchType)
        ?.imageType;
  }

  /// Play current item given context
  ///
  /// If Book open Epub reader
  /// If Video open video player
  /// If music play it and show music button
  Future<void> playItem() {
    var musicProvider = MusicProvider();
    if (type == ItemType.EPISODE ||
        type == ItemType.SEASON ||
        type == ItemType.SERIES ||
        type == ItemType.MOVIE ||
        type == ItemType.TVCHANNEL ||
        type == ItemType.VIDEO) {
      return customRouter.push(StreamRoute(item: this));
    } else if (type == ItemType.AUDIO) {
      if (musicProvider.getAudioPlayer == null) {
        final audioPlayer = AudioPlayer();
        musicProvider.setAudioPlayer(audioPlayer);
      }
      return musicProvider.playRemoteAudio(this);
    } else if (type == ItemType.MUSICALBUM) {
      if (musicProvider.getAudioPlayer == null) {
        final audioPlayer = AudioPlayer();
        musicProvider.setAudioPlayer(audioPlayer);
      }
      return musicProvider.playPlaylist(this);
    } else if (type == ItemType.BOOK) {
      return customRouter.push(EpubRoute(item: this));
    } else {
      throw UnimplementedError('Item is not playable (type : $type');
    }
  }

  Future<String> getItemURL({bool directPlay = false}) async {
    // if (directPlay == false && offlineMode == false) {
    //   await StreamingService.bitrateTest(size: 500000);
    //   await StreamingService.bitrateTest(size: 1000000);
    //   await StreamingService.bitrateTest(size: 3000000);
    // }

    late final Item item;

    if (type == ItemType.EPISODE ||
        type == ItemType.MOVIE ||
        type == ItemType.TVCHANNEL ||
        type == ItemType.VIDEO ||
        type == ItemType.MUSICVIDEO ||
        type == ItemType.AUDIO) {
      item = this;
    } else if (type == ItemType.SEASON || type == ItemType.SERIES) {
      item = await getFirstUnplayedItem();
    } else if (type == ItemType.AUDIO) {
      return createMusicURL();
    } else {
      throw ('Cannot find the type of file');
    }

    return getStreamURL(item, directPlay);
  }

  Future<Item> getPlayableItemOrLastUnplayed() async {
    var item;

    if (type == ItemType.EPISODE ||
        type == ItemType.MOVIE ||
        type == ItemType.TVCHANNEL ||
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
    // First we try to fetch item locally to play it
    final database = db.AppDatabase().getDatabase;
    final itemExist = await database.downloadsDao.doesExist(item.id);
    if (itemExist) return await FileService.getStoragePathItem(item);

    // If item do not exist locally the we fetch it from remote server
    final streamingProvider = StreamingProvider();
    final data = await StreamingService.isCodecSupported();
    final backInfos = await StreamingService.playbackInfos(data, item.id,
        startTimeTick: item.userData!.playbackPositionTicks);
    var completeTranscodeUrl;

    // Check if we have a transcide url or we create it
    if (backInfos.isTranscoding() && !directPlay) {
      completeTranscodeUrl =
          '${server.url}${backInfos.mediaSources.first.transcodingUrl}';
    }
    final finalUrl = completeTranscodeUrl ??
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
      return artists.getRange(0, max).map((e) => e.name).join(', ').toString();
    }
    return '';
  }

  bool hasRatings() {
    return communityRating != null || criticRating != null;
  }

  Future<String> createMusicURL() async {
    final streamingSoftwareDB = await db.AppDatabase()
        .getDatabase
        .settingsDao
        .getSettingsById(userApp!.settingsId);
    final streamingSoftware = TranscodeAudioCodec.fromString(
        streamingSoftwareDB.preferredTranscodeAudioCodec);

    // First we try to fetch item locally to play it
    final database = db.AppDatabase().getDatabase;
    final itemExist = await database.downloadsDao.doesExist(id);
    if (itemExist) return await FileService.getStoragePathItem(this);

    return '${server.url}/Audio/$id/stream.$streamingSoftware';
  }

  List<MediaStream> getMediaStreamFromType({required MediaStreamType type}) {
    return mediaStreams.where((element) => element.type == type).toList();
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
