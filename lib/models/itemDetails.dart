// To parse this JSON data, do
//
//     final media = mediaFromMap(jsonString);

import 'dart:convert';

import 'package:jellyflut/shared/enums.dart';

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

List<ItemDetail> mediaFromList(String str) =>
    List<ItemDetail>.from(json.decode(str).map((x) => ItemDetail.fromMap(x)));

ItemDetail mediaFromMap(String str) => ItemDetail.fromMap(json.decode(str));

String mediaToMap(ItemDetail data) => json.encode(data.toMap());

class ItemDetail {
  ItemDetail({
    this.name,
    this.originalTitle,
    this.serverId,
    this.id,
    this.indexNumber,
    this.parentIndexNumber,
    this.etag,
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
    this.type,
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
  String type;
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

  factory ItemDetail.fromMap(Map<String, dynamic> json) => ItemDetail(
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
        type: json["Type"] == null ? null : json["Type"],
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
        userData: json["userData"] == null
            ? null
            : UserData.fromMap(json["UserData"]),
        specialFeatureCount: json["SpecialFeatureCount"] == null
            ? null
            : json["specialFeatureCount"],
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
        "DateCreated": dateCreated.toIso8601String(),
        "CanDelete": canDelete,
        "CanDownload": canDownload,
        "HasSubtitles": hasSubtitles,
        "Container": container,
        "SortName": sortName,
        "PremiereDate": premiereDate.toIso8601String(),
        "ExternalUrls": List<dynamic>.from(externalUrls.map((x) => x.toMap())),
        "MediaSources": List<dynamic>.from(mediaSources.map((x) => x.toMap())),
        "CriticRating": criticRating,
        "ProductionLocations":
            List<dynamic>.from(productionLocations.map((x) => x)),
        "Path": path,
        "EnableMediaSourceDisplay": enableMediaSourceDisplay,
        "Overview": overview,
        "Taglines": List<dynamic>.from(taglines.map((x) => x)),
        "Genres": List<dynamic>.from(genres.map((x) => x)),
        "CommunityRating": communityRating,
        "RunTimeTicks": runTimeTicks,
        "PlayAccess": playAccess,
        "ProductionYear": productionYear,
        "RemoteTrailers":
            List<dynamic>.from(remoteTrailers.map((x) => x.toMap())),
        "ProviderIds": providerIds.toMap(),
        "IsHD": isHd,
        "IsFolder": isFolder,
        "ParentId": parentId,
        "Type": type,
        "People": List<dynamic>.from(people.map((x) => x.toMap())),
        "Studios": List<dynamic>.from(studios.map((x) => x.toMap())),
        "GenreItems": List<dynamic>.from(genreItems.map((x) => x.toMap())),
        "LocalTrailerCount": localTrailerCount,
        "UserData": userData.toMap(),
        "SpecialFeatureCount": specialFeatureCount,
        "DisplayPreferencesId": displayPreferencesId,
        "Tags": List<dynamic>.from(tags.map((x) => x)),
        "PrimaryImageAspectRatio": primaryImageAspectRatio,
        "MediaStreams": List<dynamic>.from(mediaStreams.map((x) => x.toMap())),
        "VideoType": videoType,
        "ImageTags": imageTags.toMap(),
        "BackdropImageTags":
            List<dynamic>.from(backdropImageTags.map((x) => x)),
        "ScreenshotImageTags":
            List<dynamic>.from(screenshotImageTags.map((x) => x)),
        "ImageBlurHashes": imageBlurHashes.toMap(),
        "Chapters": List<dynamic>.from(chapters.map((x) => x.toMap())),
        "LocationType": locationType,
        "MediaType": typeValues.reverse[mediaType],
        "LockedFields": List<dynamic>.from(lockedFields.map((x) => x)),
        "LockData": lockData,
        "Width": width,
        "Height": height,
      };
}
