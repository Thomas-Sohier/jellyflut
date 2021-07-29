// To parse this JSON data, do
//
//     final season = seasonFromMap(jsonString);

import 'dart:convert';

import 'externalUrl.dart';
import 'genreItem.dart';
import 'imageTags.dart';
import 'person.dart';
import 'providerIds.dart';
import 'seasonBlurHash.dart';
import 'userData.dart';

Season seasonFromMap(String str) => Season.fromMap(json.decode(str));

String seasonToMap(Season data) => json.encode(data.toMap());

class Season {
  Season({
    this.name,
    this.serverId,
    this.id,
    this.etag,
    this.dateCreated,
    this.dateLastMediaAdded,
    this.canDelete,
    this.canDownload,
    this.sortName,
    this.premiereDate,
    this.externalUrls,
    this.path,
    this.enableMediaSourceDisplay,
    this.overview,
    this.taglines,
    this.genres,
    this.communityRating,
    this.cumulativeRunTimeTicks,
    this.runTimeTicks,
    this.playAccess,
    this.productionYear,
    this.remoteTrailers,
    this.providerIds,
    this.isFolder,
    this.parentId,
    this.type,
    this.people,
    this.studios,
    this.genreItems,
    this.localTrailerCount,
    this.userData,
    this.recursiveItemCount,
    this.childCount,
    this.specialFeatureCount,
    this.displayPreferencesId,
    this.status,
    this.airTime,
    this.airDays,
    this.tags,
    this.primaryImageAspectRatio,
    this.imageTags,
    this.backdropImageTags,
    this.screenshotImageTags,
    this.imageBlurHashes,
    this.locationType,
    this.endDate,
    this.lockedFields,
    this.lockData,
  });

  String? name;
  String? serverId;
  String? id;
  String? etag;
  DateTime? dateCreated;
  DateTime? dateLastMediaAdded;
  bool? canDelete;
  bool? canDownload;
  String? sortName;
  DateTime? premiereDate;
  List<ExternalUrl>? externalUrls;
  String? path;
  bool? enableMediaSourceDisplay;
  String? overview;
  List<dynamic>? taglines;
  List<String>? genres;
  double? communityRating;
  int? cumulativeRunTimeTicks;
  int? runTimeTicks;
  String? playAccess;
  int? productionYear;
  List<dynamic>? remoteTrailers;
  ProviderIds? providerIds;
  bool? isFolder;
  String? parentId;
  String? type;
  List<Person>? people;
  List<GenreItem>? studios;
  List<GenreItem>? genreItems;
  int? localTrailerCount;
  UserData? userData;
  int? recursiveItemCount;
  int? childCount;
  int? specialFeatureCount;
  String? displayPreferencesId;
  String? status;
  String? airTime;
  List<String>? airDays;
  List<dynamic>? tags;
  double? primaryImageAspectRatio;
  ImageTags? imageTags;
  List<String>? backdropImageTags;
  List<dynamic>? screenshotImageTags;
  SeasonImageBlurHashes? imageBlurHashes;
  String? locationType;
  DateTime? endDate;
  List<dynamic>? lockedFields;
  bool? lockData;

  factory Season.fromMap(Map<String, dynamic> json) => Season(
        name: json['Name'],
        serverId: json['ServerId'],
        id: json['Id'],
        etag: json['Etag'],
        dateCreated: DateTime.parse(json['DateCreated']),
        dateLastMediaAdded: DateTime.parse(json['DateLastMediaAdded']),
        canDelete: json['CanDelete'],
        canDownload: json['CanDownload'],
        sortName: json['SortName'],
        premiereDate: DateTime.parse(json['PremiereDate']),
        externalUrls: List<ExternalUrl>.from(
            json['ExternalUrls'].map((x) => ExternalUrl.fromMap(x))),
        path: json['Path'],
        enableMediaSourceDisplay: json['EnableMediaSourceDisplay'],
        overview: json['Overview'],
        taglines: List<dynamic>.from(json['Taglines'].map((x) => x)),
        genres: List<String>.from(json['Genres'].map((x) => x)),
        communityRating: json['CommunityRating'].toDouble(),
        cumulativeRunTimeTicks: json['CumulativeRunTimeTicks'],
        runTimeTicks: json['RunTimeTicks'],
        playAccess: json['PlayAccess'],
        productionYear: json['ProductionYear'],
        remoteTrailers:
            List<dynamic>.from(json['RemoteTrailers'].map((x) => x)),
        providerIds: ProviderIds.fromMap(json['ProviderIds']),
        isFolder: json['IsFolder'],
        parentId: json['ParentId'],
        type: json['Type'],
        people: List<Person>.from(json['People'].map((x) => Person.fromMap(x))),
        studios: List<GenreItem>.from(
            json['Studios'].map((x) => GenreItem.fromMap(x))),
        genreItems: List<GenreItem>.from(
            json['GenreItems'].map((x) => GenreItem.fromMap(x))),
        localTrailerCount: json['LocalTrailerCount'],
        userData: UserData.fromMap(json['UserData']),
        recursiveItemCount: json['RecursiveItemCount'],
        childCount: json['ChildCount'],
        specialFeatureCount: json['SpecialFeatureCount'],
        displayPreferencesId: json['DisplayPreferencesId'],
        status: json['Status'],
        airTime: json['AirTime'],
        airDays: List<String>.from(json['AirDays'].map((x) => x)),
        tags: List<dynamic>.from(json['Tags'].map((x) => x)),
        primaryImageAspectRatio: json['PrimaryImageAspectRatio'].toDouble(),
        imageTags: ImageTags.fromMap(json['ImageTags']),
        backdropImageTags:
            List<String>.from(json['BackdropImageTags'].map((x) => x)),
        screenshotImageTags:
            List<dynamic>.from(json['ScreenshotImageTags'].map((x) => x)),
        imageBlurHashes: SeasonImageBlurHashes.fromMap(json['ImageBlurHashes']),
        locationType: json['LocationType'],
        endDate: DateTime.parse(json['EndDate']),
        lockedFields: List<dynamic>.from(json['LockedFields'].map((x) => x)),
        lockData: json['LockData'],
      );

  Map<String, dynamic> toMap() => {
        'Name': name,
        'ServerId': serverId,
        'Id': id,
        'Etag': etag,
        'DateCreated': dateCreated?.toIso8601String(),
        'DateLastMediaAdded': dateLastMediaAdded?.toIso8601String(),
        'CanDelete': canDelete,
        'CanDownload': canDownload,
        'SortName': sortName,
        'PremiereDate': premiereDate?.toIso8601String(),
        'ExternalUrls': externalUrls != null
            ? List<dynamic>.from(externalUrls!.map((x) => x.toMap()))
            : null,
        'Path': path,
        'EnableMediaSourceDisplay': enableMediaSourceDisplay,
        'Overview': overview,
        'Taglines': taglines != null
            ? List<dynamic>.from(taglines!.map((x) => x))
            : null,
        'Genres':
            genres != null ? List<dynamic>.from(genres!.map((x) => x)) : null,
        'CommunityRating': communityRating,
        'CumulativeRunTimeTicks': cumulativeRunTimeTicks,
        'RunTimeTicks': runTimeTicks,
        'PlayAccess': playAccess,
        'ProductionYear': productionYear,
        'RemoteTrailers': remoteTrailers != null
            ? List<dynamic>.from(remoteTrailers!.map((x) => x))
            : null,
        'ProviderIds': providerIds?.toMap(),
        'IsFolder': isFolder,
        'ParentId': parentId,
        'Type': type,
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
        'UserData': userData != null ? userData!.toMap() : null,
        'RecursiveItemCount': recursiveItemCount,
        'ChildCount': childCount,
        'SpecialFeatureCount': specialFeatureCount,
        'DisplayPreferencesId': displayPreferencesId,
        'Status': status,
        'AirTime': airTime,
        'AirDays':
            airDays != null ? List<dynamic>.from(airDays!.map((x) => x)) : null,
        'Tags': tags != null ? List<dynamic>.from(tags!.map((x) => x)) : null,
        'PrimaryImageAspectRatio': primaryImageAspectRatio,
        'ImageTags': imageTags?.toMap(),
        'BackdropImageTags': backdropImageTags != null
            ? List<dynamic>.from(backdropImageTags!.map((x) => x))
            : null,
        'ScreenshotImageTags': screenshotImageTags != null
            ? List<dynamic>.from(screenshotImageTags!.map((x) => x))
            : null,
        'ImageBlurHashes': imageBlurHashes?.toMap(),
        'LocationType': locationType,
        'EndDate': endDate?.toIso8601String(),
        'LockedFields': lockedFields != null
            ? List<dynamic>.from(lockedFields!.map((x) => x))
            : null,
        'LockData': lockData,
      };
}
