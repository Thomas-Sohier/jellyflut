// To parse this JSON data, do
//
//     final media = itemFromMap(jsonString);

import 'dart:convert';

import 'package:jellyflut/shared/enums.dart';

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
        name: json["Name"] == null ? null : json["Name"],
        originalTitle:
            json["OriginalTitle"] == null ? null : json["OriginalTitle"],
        serverId: json["ServerId"] == null ? null : json["ServerId"],
        id: json["Id"] == null ? null : json["Id"],
        indexNumber: json["IndexNumber"] == null ? null : json["IndexNumber"],
        parentIndexNumber: json["ParentIndexNumber"] == null
            ? null
            : json["ParentIndexNumber"],
        etag: json["Etag"] == null ? null : json["Etag"],
        collectionType:
            json["CollectionType"] == null ? null : json["CollectionType"],
        dateCreated: json["DateCreated"] == null
            ? null
            : DateTime.parse(json["DateCreated"]),
        canDelete: json["CanDelete"] == null ? null : json["CanDelete"],
        canDownload: json["CanDownload"] == null ? null : json["CanDownload"],
        hasSubtitles:
            json["HasSubtitles"] == null ? null : json["HasSubtitles"],
        container: json["Container"] == null ? null : json["Container"],
        sortName: json["SortName"] == null ? null : json["SortName"],
        premiereDate: json["PremiereDate"] == null
            ? null
            : DateTime.parse(json["PremiereDate"]),
        externalUrls: json["ExternalUrls"] == null
            ? null
            : List<ExternalUrl>.from(
                json["ExternalUrls"].map((x) => ExternalUrl.fromMap(x))),
        mediaSources: json["MediaSources"] == null
            ? null
            : List<MediaSource>.from(
                json["MediaSources"].map((x) => MediaSource.fromMap(x))),
        criticRating:
            json["CriticRating"] == null ? null : json["CriticRating"],
        productionLocations: json["ProductionLocations"] == null
            ? null
            : List<String>.from(json["ProductionLocations"].map((x) => x)),
        path: json["Path"] == null ? null : json["Path"],
        enableMediaSourceDisplay: json["EnableMediaSourceDisplay"] == null
            ? null
            : json["EnableMediaSourceDisplay"],
        overview: json["Overview"] == null ? null : json["Overview"],
        taglines: json["Taglines"] == null
            ? null
            : List<dynamic>.from(json["Taglines"].map((x) => x)),
        genres: json["Genres"] == null
            ? null
            : List<String>.from(json["Genres"].map((x) => x)),
        communityRating: json["CommunityRating"] == null
            ? null
            : json["CommunityRating"].toDouble(),
        runTimeTicks:
            json["RunTimeTicks"] == null ? null : json["RunTimeTicks"],
        playAccess: json["PlayAccess"] == null ? null : json["PlayAccess"],
        productionYear:
            json["ProductionYear"] == null ? null : json["ProductionYear"],
        remoteTrailers: json["RemoteTrailers"] == null
            ? null
            : List<ExternalUrl>.from(
                json["RemoteTrailers"].map((x) => ExternalUrl.fromMap(x))),
        providerIds: json["ProviderIds"] == null
            ? null
            : ProviderIds.fromMap(json["ProviderIds"]),
        isHd: json["IsHD"] == null ? null : json["isHd"],
        isFolder: json["IsFolder"] == null ? null : json["IsFolder"],
        parentId: json["ParentId"] == null ? null : json["ParentId"],
        seriesId: json["SeriesId"] == null ? null : json["SeriesId"],
        seasonId: json["SeasonId"] == null ? null : json["SeasonId"],
        type: json["Type"] == null ? null : json["Type"],
        artists: json["Artists"] == null
            ? null
            : List<Artist>.from(json["Artists"].map((x) => Artist.fromMap(x))),
        artistItems: json["ArtistItems"] == null
            ? null
            : List<ArtistItems>.from(
                json["ArtistItems"].map((x) => ArtistItems.fromMap(x))),
        album: json["Album"] == null ? null : json["Album"],
        albumId: json["AlbumId"] == null ? null : json["AlbumId"],
        albumPrimaryImageTag: json["AlbumPrimaryImageTag"] == null
            ? null
            : json["AlbumPrimaryImageTag"],
        albumArtist: json["AlbumArtist"] == null ? null : json["AlbumArtist"],
        albumArtists: json["AlbumArtists"] == null
            ? null
            : List<AlbumArtists>.from(
                json["AlbumArtists"].map((x) => AlbumArtists.fromMap(x))),
        people: json["people"] == null
            ? null
            : List<Person>.from(json["People"].map((x) => Person.fromMap(x))),
        studios: json["studios"] == null
            ? null
            : List<GenreItem>.from(
                json["Studios"].map((x) => GenreItem.fromMap(x))),
        genreItems: json["genreItems"] == null
            ? null
            : List<GenreItem>.from(
                json["GenreItems"].map((x) => GenreItem.fromMap(x))),
        localTrailerCount: json["LocalTrailerCount"] == null
            ? null
            : json["localTrailerCount"],
        userData: json["UserData"] == null
            ? null
            : UserData.fromMap(json["UserData"]),
        specialFeatureCount: json["SpecialFeatureCount"] == null
            ? null
            : json["SpecialFeatureCount"],
        displayPreferencesId: json["DisplayPreferencesId"] == null
            ? null
            : json["DisplayPreferencesId"],
        tags: json["Tags"] == null
            ? null
            : List<dynamic>.from(json["Tags"].map((x) => x)),
        primaryImageAspectRatio: json["PrimaryImageAspectRatio"] == null
            ? null
            : json["PrimaryImageAspectRatio"].toDouble(),
        mediaStreams: json["MediaStreams"] == null
            ? null
            : List<MediaStream>.from(
                json["MediaStreams"].map((x) => MediaStream.fromMap(x))),
        videoType: json["VideoType"] == null ? null : json["VideoType"],
        imageTags: json["ImageTags"] == null
            ? null
            : ImageTags.fromMap(json["ImageTags"]),
        backdropImageTags: json["BackdropImageTags"] == null
            ? null
            : List<String>.from(json["BackdropImageTags"].map((x) => x)),
        screenshotImageTags: json["ScreenshotImageTags"] == null
            ? null
            : List<dynamic>.from(json["ScreenshotImageTags"].map((x) => x)),
        imageBlurHashes: json["ImageBlurHashes"] == null
            ? null
            : ImageBlurHashes.fromMap(json["ImageBlurHashes"]),
        chapters: json["Chapters"] == null
            ? null
            : List<Chapter>.from(
                json["Chapters"].map((x) => Chapter.fromMap(x))),
        locationType:
            json["LocationType"] == null ? null : json["LocationType"],
        mediaType: typeValues.map[json["MediaType"]] == null
            ? null
            : typeValues.map[json["MediaType"]],
        lockedFields: json["LockedFields"] == null
            ? null
            : List<dynamic>.from(json["LockedFields"].map((x) => x)),
        lockData: json["LockData"] == null ? null : json["LockData"],
        width: json["Width"] == null ? null : json["Width"],
        height: json["Height"] == null ? null : json["Height"],
      );

  Map<String, dynamic> toMap() => {
        "Name": name,
        "OriginalTitle": originalTitle,
        "ServerId": serverId,
        "Id": id,
        "IndexNumber": indexNumber == null ? null : indexNumber,
        "ParentIndexNumber":
            parentIndexNumber == null ? null : parentIndexNumber,
        "Etag": etag,
        "CollectionType": collectionType,
        "DateCreated": dateCreated == null ?? dateCreated.toIso8601String(),
        "CanDelete": canDelete,
        "CanDownload": canDownload,
        "HasSubtitles": hasSubtitles,
        "Container": container,
        "SortName": sortName,
        "PremiereDate": premiereDate == null ?? premiereDate.toIso8601String(),
        "ExternalUrls": externalUrls == null ??
            List<dynamic>.from(externalUrls.map((x) => x.toMap())),
        "MediaSources": mediaSources == null ??
            List<dynamic>.from(mediaSources.map((x) => x.toMap())),
        "CriticRating": criticRating,
        "ProductionLocations": productionLocations == null ??
            List<dynamic>.from(productionLocations.map((x) => x)),
        "Path": path,
        "EnableMediaSourceDisplay": enableMediaSourceDisplay,
        "Overview": overview,
        "Taglines":
            taglines == null ?? List<dynamic>.from(taglines.map((x) => x)),
        "Genres": genres == null ?? List<dynamic>.from(genres.map((x) => x)),
        "CommunityRating": communityRating,
        "RunTimeTicks": runTimeTicks,
        "PlayAccess": playAccess,
        "ProductionYear": productionYear,
        "RemoteTrailers": remoteTrailers == null ??
            List<dynamic>.from(remoteTrailers.map((x) => x.toMap())),
        "ProviderIds": providerIds == null ?? providerIds.toMap(),
        "IsHD": isHd,
        "IsFolder": isFolder,
        "ParentId": parentId,
        "Type": type,
        "Artists": artists,
        "ArtistItems": artistItems,
        "Album": album,
        "AlbumId": albumId,
        "AlbumPrimaryImageTag": albumPrimaryImageTag,
        "AlbumArtist": albumArtist,
        "AlbumArtists": albumArtists,
        "People":
            people == null ?? List<dynamic>.from(people.map((x) => x.toMap())),
        "Studios": studios == null ??
            List<dynamic>.from(studios.map((x) => x.toMap())),
        "GenreItems": genreItems == null ??
            List<dynamic>.from(genreItems.map((x) => x.toMap())),
        "LocalTrailerCount": localTrailerCount,
        "UserData": userData == null ?? userData.toMap(),
        "SpecialFeatureCount": specialFeatureCount,
        "DisplayPreferencesId": displayPreferencesId,
        "Tags": tags == null ?? List<dynamic>.from(tags.map((x) => x)),
        "PrimaryImageAspectRatio": primaryImageAspectRatio,
        "MediaStreams": mediaStreams == null ??
            List<dynamic>.from(mediaStreams.map((x) => x.toMap())),
        "VideoType": videoType,
        "ImageTags": imageTags == null ?? imageTags.toMap(),
        "BackdropImageTags": backdropImageTags == null ??
            List<dynamic>.from(backdropImageTags.map((x) => x)),
        "ScreenshotImageTags": screenshotImageTags == null ??
            List<dynamic>.from(screenshotImageTags.map((x) => x)),
        "ImageBlurHashes": imageBlurHashes.toMap(),
        "Chapters": chapters == null ??
            List<dynamic>.from(chapters.map((x) => x.toMap())),
        "LocationType": locationType,
        "MediaType": typeValues.reverse[mediaType],
        "LockedFields": lockedFields == null ??
            List<dynamic>.from(lockedFields.map((x) => x)),
        "LockData": lockData,
        "Width": width,
        "Height": height,
      };
}
