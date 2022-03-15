import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProgramsRequestBody {
  List<String>? channelIds;
  String? userId;
  DateTime? minStartDate;
  bool? hasAired;
  bool? isAiring;
  DateTime? maxStartDate;
  DateTime? minEndDate;
  DateTime? maxEndDate;
  bool? isMovie;
  bool? isSeries;
  bool? isNews;
  bool? isKids;
  bool? isSports;
  int? startIndex;
  int? limit;
  List<String>? sortBy;
  List<String>? sortOrder;
  List<String>? genres;
  List<String>? genreIds;
  bool? enableImages;
  bool? enableTotalRecordCount;
  int? imageTypeLimit;
  List<String>? enableImageTypes;
  bool? enableUserData;
  String? seriesTimerId;
  String? librarySeriesId;
  List<String>? fields;

  ProgramsRequestBody({
    this.channelIds,
    this.userId,
    this.minStartDate,
    this.hasAired,
    this.isAiring,
    this.maxStartDate,
    this.minEndDate,
    this.maxEndDate,
    this.isMovie,
    this.isSeries,
    this.isNews,
    this.isKids,
    this.isSports,
    this.startIndex,
    this.limit,
    this.sortBy,
    this.sortOrder,
    this.genres,
    this.genreIds,
    this.enableImages,
    this.enableTotalRecordCount,
    this.imageTypeLimit,
    this.enableImageTypes,
    this.enableUserData,
    this.seriesTimerId,
    this.librarySeriesId,
    this.fields,
  });

  ProgramsRequestBody copyWith({
    List<String>? channelIds,
    String? userId,
    DateTime? minStartDate,
    bool? hasAired,
    bool? isAiring,
    DateTime? maxStartDate,
    DateTime? minEndDate,
    DateTime? maxEndDate,
    bool? isMovie,
    bool? isSeries,
    bool? isNews,
    bool? isKids,
    bool? isSports,
    int? startIndex,
    int? limit,
    List<String>? sortBy,
    List<String>? sortOrder,
    List<String>? genres,
    List<String>? genreIds,
    bool? enableImages,
    bool? enableTotalRecordCount,
    int? imageTypeLimit,
    List<String>? enableImageTypes,
    bool? enableUserData,
    String? seriesTimerId,
    String? librarySeriesId,
    List<String>? fields,
  }) {
    return ProgramsRequestBody(
      channelIds: channelIds ?? this.channelIds,
      userId: userId ?? this.userId,
      minStartDate: minStartDate ?? this.minStartDate,
      hasAired: hasAired ?? this.hasAired,
      isAiring: isAiring ?? this.isAiring,
      maxStartDate: maxStartDate ?? this.maxStartDate,
      minEndDate: minEndDate ?? this.minEndDate,
      maxEndDate: maxEndDate ?? this.maxEndDate,
      isMovie: isMovie ?? this.isMovie,
      isSeries: isSeries ?? this.isSeries,
      isNews: isNews ?? this.isNews,
      isKids: isKids ?? this.isKids,
      isSports: isSports ?? this.isSports,
      startIndex: startIndex ?? this.startIndex,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      genres: genres ?? this.genres,
      genreIds: genreIds ?? this.genreIds,
      enableImages: enableImages ?? this.enableImages,
      enableTotalRecordCount:
          enableTotalRecordCount ?? this.enableTotalRecordCount,
      imageTypeLimit: imageTypeLimit ?? this.imageTypeLimit,
      enableImageTypes: enableImageTypes ?? this.enableImageTypes,
      enableUserData: enableUserData ?? this.enableUserData,
      seriesTimerId: seriesTimerId ?? this.seriesTimerId,
      librarySeriesId: librarySeriesId ?? this.librarySeriesId,
      fields: fields ?? this.fields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channelIds': channelIds,
      'userId': userId,
      'minStartDate': minStartDate?.millisecondsSinceEpoch,
      'hasAired': hasAired,
      'isAiring': isAiring,
      'maxStartDate': maxStartDate?.millisecondsSinceEpoch,
      'minEndDate': minEndDate?.millisecondsSinceEpoch,
      'maxEndDate': maxEndDate?.millisecondsSinceEpoch,
      'isMovie': isMovie,
      'isSeries': isSeries,
      'isNews': isNews,
      'isKids': isKids,
      'isSports': isSports,
      'startIndex': startIndex,
      'limit': limit,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
      'genres': genres,
      'genreIds': genreIds,
      'enableImages': enableImages,
      'enableTotalRecordCount': enableTotalRecordCount,
      'imageTypeLimit': imageTypeLimit,
      'enableImageTypes': enableImageTypes,
      'enableUserData': enableUserData,
      'seriesTimerId': seriesTimerId,
      'librarySeriesId': librarySeriesId,
      'fields': fields,
    };
  }

  factory ProgramsRequestBody.fromMap(Map<String, dynamic> map) {
    return ProgramsRequestBody(
      channelIds: List<String>.from(map['channelIds']),
      userId: map['userId'],
      minStartDate: map['minStartDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['minStartDate'])
          : null,
      hasAired: map['hasAired'],
      isAiring: map['isAiring'],
      maxStartDate: map['maxStartDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['maxStartDate'])
          : null,
      minEndDate: map['minEndDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['minEndDate'])
          : null,
      maxEndDate: map['maxEndDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['maxEndDate'])
          : null,
      isMovie: map['isMovie'],
      isSeries: map['isSeries'],
      isNews: map['isNews'],
      isKids: map['isKids'],
      isSports: map['isSports'],
      startIndex: map['startIndex']?.toInt(),
      limit: map['limit']?.toInt(),
      sortBy: List<String>.from(map['sortBy']),
      sortOrder: List<String>.from(map['sortOrder']),
      genres: List<String>.from(map['genres']),
      genreIds: List<String>.from(map['genreIds']),
      enableImages: map['enableImages'],
      enableTotalRecordCount: map['enableTotalRecordCount'],
      imageTypeLimit: map['imageTypeLimit']?.toInt(),
      enableImageTypes: List<String>.from(map['enableImageTypes']),
      enableUserData: map['enableUserData'],
      seriesTimerId: map['seriesTimerId'],
      librarySeriesId: map['librarySeriesId'],
      fields: List<String>.from(map['fields']),
    );
  }

  String toJson() =>
      json.encode(toMap()..removeWhere((key, value) => value == null));

  factory ProgramsRequestBody.fromJson(String source) =>
      ProgramsRequestBody.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProgramsRequestBody(channelIds: $channelIds, userId: $userId, minStartDate: $minStartDate, hasAired: $hasAired, isAiring: $isAiring, maxStartDate: $maxStartDate, minEndDate: $minEndDate, maxEndDate: $maxEndDate, isMovie: $isMovie, isSeries: $isSeries, isNews: $isNews, isKids: $isKids, isSports: $isSports, startIndex: $startIndex, limit: $limit, sortBy: $sortBy, sortOrder: $sortOrder, genres: $genres, genreIds: $genreIds, enableImages: $enableImages, enableTotalRecordCount: $enableTotalRecordCount, imageTypeLimit: $imageTypeLimit, enableImageTypes: $enableImageTypes, enableUserData: $enableUserData, seriesTimerId: $seriesTimerId, librarySeriesId: $librarySeriesId, fields: $fields)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProgramsRequestBody &&
        listEquals(other.channelIds, channelIds) &&
        other.userId == userId &&
        other.minStartDate == minStartDate &&
        other.hasAired == hasAired &&
        other.isAiring == isAiring &&
        other.maxStartDate == maxStartDate &&
        other.minEndDate == minEndDate &&
        other.maxEndDate == maxEndDate &&
        other.isMovie == isMovie &&
        other.isSeries == isSeries &&
        other.isNews == isNews &&
        other.isKids == isKids &&
        other.isSports == isSports &&
        other.startIndex == startIndex &&
        other.limit == limit &&
        listEquals(other.sortBy, sortBy) &&
        listEquals(other.sortOrder, sortOrder) &&
        listEquals(other.genres, genres) &&
        listEquals(other.genreIds, genreIds) &&
        other.enableImages == enableImages &&
        other.enableTotalRecordCount == enableTotalRecordCount &&
        other.imageTypeLimit == imageTypeLimit &&
        listEquals(other.enableImageTypes, enableImageTypes) &&
        other.enableUserData == enableUserData &&
        other.seriesTimerId == seriesTimerId &&
        other.librarySeriesId == librarySeriesId &&
        listEquals(other.fields, fields);
  }

  @override
  int get hashCode {
    return channelIds.hashCode ^
        userId.hashCode ^
        minStartDate.hashCode ^
        hasAired.hashCode ^
        isAiring.hashCode ^
        maxStartDate.hashCode ^
        minEndDate.hashCode ^
        maxEndDate.hashCode ^
        isMovie.hashCode ^
        isSeries.hashCode ^
        isNews.hashCode ^
        isKids.hashCode ^
        isSports.hashCode ^
        startIndex.hashCode ^
        limit.hashCode ^
        sortBy.hashCode ^
        sortOrder.hashCode ^
        genres.hashCode ^
        genreIds.hashCode ^
        enableImages.hashCode ^
        enableTotalRecordCount.hashCode ^
        imageTypeLimit.hashCode ^
        enableImageTypes.hashCode ^
        enableUserData.hashCode ^
        seriesTimerId.hashCode ^
        librarySeriesId.hashCode ^
        fields.hashCode;
  }
}
