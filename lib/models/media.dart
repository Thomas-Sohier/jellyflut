// To parse this JSON data, do
//
//     final media = mediaFromMap(jsonString);

import 'dart:collection';
import 'dart:convert';

import 'package:jellyflut/models/category.dart';

List<Media> mediaFromMap(String str) =>
    List<Media>.from(json.decode(str).map((x) => Media.fromMap(x)));

String mediaToMap(List<Media> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Media {
  Media({
    this.name,
    this.serverId,
    this.id,
    this.hasSubtitles,
    this.container,
    this.premiereDate,
    this.runTimeTicks,
    this.productionYear,
    this.indexNumber,
    this.parentIndexNumber,
    this.isFolder,
    this.type,
    this.parentLogoItemId,
    this.parentBackdropItemId,
    this.parentBackdropImageTags,
    this.userData,
    this.childCount,
    this.seriesName,
    this.seriesId,
    this.seasonId,
    this.seriesPrimaryImageTag,
    this.seasonName,
    this.videoType,
    this.imageTags,
    this.backdropImageTags,
    this.parentLogoImageTag,
    this.imageBlurHashes,
    this.parentThumbItemId,
    this.parentThumbImageTag,
    this.locationType,
    this.mediaType,
    this.communityRating,
    this.airTime,
    this.airDays,
    this.displayOrder,
    this.status,
    this.endDate,
  });

  String name;
  String serverId;
  String id;
  bool hasSubtitles;
  String container;
  DateTime premiereDate;
  int runTimeTicks;
  int productionYear;
  int indexNumber;
  int parentIndexNumber;
  bool isFolder;
  String type;
  String parentLogoItemId;
  String parentBackdropItemId;
  List<String> parentBackdropImageTags;
  UserData userData;
  int childCount;
  String seriesName;
  String seriesId;
  String seasonId;
  String seriesPrimaryImageTag;
  String seasonName;
  String videoType;
  ImageTags imageTags;
  List<String> backdropImageTags;
  String parentLogoImageTag;
  ImageBlurHashes imageBlurHashes;
  String parentThumbItemId;
  String parentThumbImageTag;
  String locationType;
  String mediaType;
  double communityRating;
  String airTime;
  List<String> airDays;
  String displayOrder;
  String status;
  DateTime endDate;

  factory Media.fromMap(Map<String, dynamic> json) => Media(
        name: json["Name"],
        serverId: json["ServerId"],
        id: json["Id"],
        hasSubtitles:
            json["HasSubtitles"] == null ? null : json["HasSubtitles"],
        container: json["Container"] == null ? null : json["Container"],
        premiereDate: json["PremiereDate"] == null
            ? null
            : DateTime.parse(json["PremiereDate"]),
        runTimeTicks:
            json["RunTimeTicks"] == null ? null : json["RunTimeTicks"],
        productionYear: json["ProductionYear"],
        indexNumber: json["IndexNumber"] == null ? null : json["IndexNumber"],
        parentIndexNumber: json["ParentIndexNumber"] == null
            ? null
            : json["ParentIndexNumber"],
        isFolder: json["IsFolder"],
        type: json["Type"],
        parentLogoItemId:
            json["ParentLogoItemId"] == null ? null : json["ParentLogoItemId"],
        parentBackdropItemId: json["ParentBackdropItemId"] == null
            ? null
            : json["ParentBackdropItemId"],
        parentBackdropImageTags: json["ParentBackdropImageTags"] == null
            ? null
            : List<String>.from(json["ParentBackdropImageTags"].map((x) => x)),
        userData: UserData.fromMap(json["UserData"]),
        childCount: json["ChildCount"],
        seriesName: json["SeriesName"] == null ? null : json["SeriesName"],
        seriesId: json["SeriesId"] == null ? null : json["SeriesId"],
        seasonId: json["SeasonId"] == null ? null : json["SeasonId"],
        seriesPrimaryImageTag: json["SeriesPrimaryImageTag"] == null
            ? null
            : json["SeriesPrimaryImageTag"],
        seasonName: json["SeasonName"] == null ? null : json["SeasonName"],
        videoType: json["VideoType"] == null ? null : json["VideoType"],
        imageTags: ImageTags.fromMap(json["ImageTags"]),
        backdropImageTags:
            List<String>.from(json["BackdropImageTags"].map((x) => x)),
        parentLogoImageTag: json["ParentLogoImageTag"] == null
            ? null
            : json["ParentLogoImageTag"],
        imageBlurHashes: ImageBlurHashes.fromMap(json["ImageBlurHashes"]),
        parentThumbItemId: json["ParentThumbItemId"] == null
            ? null
            : json["ParentThumbItemId"],
        parentThumbImageTag: json["ParentThumbImageTag"] == null
            ? null
            : json["ParentThumbImageTag"],
        locationType: json["LocationType"],
        mediaType: json["MediaType"] == null ? null : json["MediaType"],
        communityRating: json["CommunityRating"] == null
            ? null
            : json["CommunityRating"].toDouble(),
        airTime: json["AirTime"] == null ? null : json["AirTime"],
        airDays: json["AirDays"] == null
            ? null
            : List<String>.from(json["AirDays"].map((x) => x)),
        displayOrder:
            json["DisplayOrder"] == null ? null : json["DisplayOrder"],
        status: json["Status"] == null ? null : json["Status"],
        endDate:
            json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
      );

  Map<String, dynamic> toMap() => {
        "Name": name,
        "ServerId": serverId,
        "Id": id,
        "HasSubtitles": hasSubtitles == null ? null : hasSubtitles,
        "Container": container == null ? null : container,
        "PremiereDate":
            premiereDate == null ? null : premiereDate.toIso8601String(),
        "RunTimeTicks": runTimeTicks == null ? null : runTimeTicks,
        "ProductionYear": productionYear,
        "IndexNumber": indexNumber == null ? null : indexNumber,
        "ParentIndexNumber":
            parentIndexNumber == null ? null : parentIndexNumber,
        "IsFolder": isFolder,
        "Type": type,
        "ParentLogoItemId": parentLogoItemId == null ? null : parentLogoItemId,
        "ParentBackdropItemId":
            parentBackdropItemId == null ? null : parentBackdropItemId,
        "ParentBackdropImageTags": parentBackdropImageTags == null
            ? null
            : List<dynamic>.from(parentBackdropImageTags.map((x) => x)),
        "UserData": userData.toMap(),
        "ChildCount": childCount,
        "SeriesName": seriesName == null ? null : seriesName,
        "SeriesId": seriesId == null ? null : seriesId,
        "SeasonId": seasonId == null ? null : seasonId,
        "SeriesPrimaryImageTag":
            seriesPrimaryImageTag == null ? null : seriesPrimaryImageTag,
        "SeasonName": seasonName == null ? null : seasonName,
        "VideoType": videoType == null ? null : videoType,
        "ImageTags": imageTags.toMap(),
        "BackdropImageTags":
            List<dynamic>.from(backdropImageTags.map((x) => x)),
        "ParentLogoImageTag":
            parentLogoImageTag == null ? null : parentLogoImageTag,
        "ImageBlurHashes": imageBlurHashes.toMap(),
        "ParentThumbItemId":
            parentThumbItemId == null ? null : parentThumbItemId,
        "ParentThumbImageTag":
            parentThumbImageTag == null ? null : parentThumbImageTag,
        "LocationType": locationType,
        "MediaType": mediaType == null ? null : mediaType,
        "CommunityRating": communityRating == null ? null : communityRating,
        "AirTime": airTime == null ? null : airTime,
        "AirDays":
            airDays == null ? null : List<dynamic>.from(airDays.map((x) => x)),
        "DisplayOrder": displayOrder == null ? null : displayOrder,
        "Status": status == null ? null : status,
        "EndDate": endDate == null ? null : endDate.toIso8601String(),
      };
}

class ImageBlurHashes {
  ImageBlurHashes({
    this.primary,
    this.logo,
    this.thumb,
    this.backdrop,
  });

  dynamic primary;
  dynamic logo;
  dynamic thumb;
  dynamic backdrop;

  factory ImageBlurHashes.fromMap(Map<String, dynamic> json) => ImageBlurHashes(
        primary: json["Primary"],
        logo: json["Logo"] == null ? null : json["Logo"],
        thumb: json["Thumb"] == null ? null : json["Thumb"],
        backdrop: json["Backdrop"] == null ? null : json["Backdrop"],
      );

  Map<String, dynamic> toMap() => {
        "Primary": primary,
        "Logo": logo == null ? null : logo,
        "Thumb": thumb == null ? null : thumb,
        "Backdrop": backdrop == null ? null : backdrop,
      };
}

class ImageTags {
  ImageTags({
    this.primary,
    this.logo,
  });

  String primary;
  String logo;

  factory ImageTags.fromMap(Map<String, dynamic> json) => ImageTags(
        primary: json["Primary"],
        logo: json["Logo"] == null ? null : json["Logo"],
      );

  Map<String, dynamic> toMap() => {
        "Primary": primary,
        "Logo": logo == null ? null : logo,
      };
}

class UserData {
  UserData({
    this.playbackPositionTicks,
    this.playCount,
    this.isFavorite,
    this.played,
    this.key,
    this.unplayedItemCount,
  });

  int playbackPositionTicks;
  int playCount;
  bool isFavorite;
  bool played;
  String key;
  int unplayedItemCount;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        playbackPositionTicks: json["PlaybackPositionTicks"],
        playCount: json["PlayCount"],
        isFavorite: json["IsFavorite"],
        played: json["Played"],
        key: json["Key"],
        unplayedItemCount: json["UnplayedItemCount"] == null
            ? null
            : json["UnplayedItemCount"],
      );

  Map<String, dynamic> toMap() => {
        "PlaybackPositionTicks": playbackPositionTicks,
        "PlayCount": playCount,
        "IsFavorite": isFavorite,
        "Played": played,
        "Key": key,
        "UnplayedItemCount":
            unplayedItemCount == null ? null : unplayedItemCount,
      };
}
