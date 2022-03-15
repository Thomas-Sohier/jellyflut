import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChannelsRequestBody {
  String? type;
  String? userId;
  int? startIndex;
  bool? isSeries;
  bool? isNews;
  bool? isKids;
  bool? isSports;
  int? limit;
  bool? isFavorite;
  bool? isLiked;
  bool? isDisliked;
  bool? enableImages;
  int? imageTypeLimit;
  List<String>? enableImageTypes;
  List<String>? fields;
  bool? enableUserData;
  List<String>? sortBy;
  String? sortOrder;
  bool? enableFavoriteSorting;
  bool? addCurrentProgram;

  ChannelsRequestBody({
    this.type,
    this.userId,
    this.startIndex,
    this.isSeries,
    this.isNews,
    this.isKids,
    this.isSports,
    this.limit,
    this.isFavorite,
    this.isLiked,
    this.isDisliked,
    this.enableImages,
    this.imageTypeLimit,
    this.enableImageTypes,
    this.fields,
    this.enableUserData,
    this.sortBy,
    this.sortOrder,
    this.enableFavoriteSorting,
    this.addCurrentProgram,
  });

  ChannelsRequestBody copyWith({
    String? type,
    String? userId,
    int? startIndex,
    bool? isSeries,
    bool? isNews,
    bool? isKids,
    bool? isSports,
    int? limit,
    bool? isFavorite,
    bool? isLiked,
    bool? isDisliked,
    bool? enableImages,
    int? imageTypeLimit,
    List<String>? enableImageTypes,
    List<String>? fields,
    bool? enableUserData,
    List<String>? sortBy,
    String? sortOrder,
    bool? enableFavoriteSorting,
    bool? addCurrentProgram,
  }) {
    return ChannelsRequestBody(
      type: type ?? this.type,
      userId: userId ?? this.userId,
      startIndex: startIndex ?? this.startIndex,
      isSeries: isSeries ?? this.isSeries,
      isNews: isNews ?? this.isNews,
      isKids: isKids ?? this.isKids,
      isSports: isSports ?? this.isSports,
      limit: limit ?? this.limit,
      isFavorite: isFavorite ?? this.isFavorite,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      enableImages: enableImages ?? this.enableImages,
      imageTypeLimit: imageTypeLimit ?? this.imageTypeLimit,
      enableImageTypes: enableImageTypes ?? this.enableImageTypes,
      fields: fields ?? this.fields,
      enableUserData: enableUserData ?? this.enableUserData,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      enableFavoriteSorting:
          enableFavoriteSorting ?? this.enableFavoriteSorting,
      addCurrentProgram: addCurrentProgram ?? this.addCurrentProgram,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'userId': userId,
      'startIndex': startIndex,
      'isSeries': isSeries,
      'isNews': isNews,
      'isKids': isKids,
      'isSports': isSports,
      'limit': limit,
      'isFavorite': isFavorite,
      'isLiked': isLiked,
      'isDisliked': isDisliked,
      'enableImages': enableImages,
      'imageTypeLimit': imageTypeLimit,
      'enableImageTypes': enableImageTypes,
      'fields': fields,
      'enableUserData': enableUserData,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
      'enableFavoriteSorting': enableFavoriteSorting,
      'addCurrentProgram': addCurrentProgram,
    };
  }

  factory ChannelsRequestBody.fromMap(Map<String, dynamic> map) {
    return ChannelsRequestBody(
      type: map['type'],
      userId: map['userId'],
      startIndex: map['startIndex']?.toInt(),
      isSeries: map['isSeries'],
      isNews: map['isNews'],
      isKids: map['isKids'],
      isSports: map['isSports'],
      limit: map['limit']?.toInt(),
      isFavorite: map['isFavorite'],
      isLiked: map['isLiked'],
      isDisliked: map['isDisliked'],
      enableImages: map['enableImages'],
      imageTypeLimit: map['imageTypeLimit']?.toInt(),
      enableImageTypes: List<String>.from(map['enableImageTypes']),
      fields: List<String>.from(map['fields']),
      enableUserData: map['enableUserData'],
      sortBy: List<String>.from(map['sortBy']),
      sortOrder: map['sortOrder'],
      enableFavoriteSorting: map['enableFavoriteSorting'],
      addCurrentProgram: map['addCurrentProgram'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChannelsRequestBody.fromJson(String source) =>
      ChannelsRequestBody.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChannelsRequestBody(type: $type, userId: $userId, startIndex: $startIndex, isSeries: $isSeries, isNews: $isNews, isKids: $isKids, isSports: $isSports, limit: $limit, isFavorite: $isFavorite, isLiked: $isLiked, isDisliked: $isDisliked, enableImages: $enableImages, imageTypeLimit: $imageTypeLimit, enableImageTypes: $enableImageTypes, fields: $fields, enableUserData: $enableUserData, sortBy: $sortBy, sortOrder: $sortOrder, enableFavoriteSorting: $enableFavoriteSorting, addCurrentProgram: $addCurrentProgram)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChannelsRequestBody &&
        other.type == type &&
        other.userId == userId &&
        other.startIndex == startIndex &&
        other.isSeries == isSeries &&
        other.isNews == isNews &&
        other.isKids == isKids &&
        other.isSports == isSports &&
        other.limit == limit &&
        other.isFavorite == isFavorite &&
        other.isLiked == isLiked &&
        other.isDisliked == isDisliked &&
        other.enableImages == enableImages &&
        other.imageTypeLimit == imageTypeLimit &&
        listEquals(other.enableImageTypes, enableImageTypes) &&
        listEquals(other.fields, fields) &&
        other.enableUserData == enableUserData &&
        listEquals(other.sortBy, sortBy) &&
        other.sortOrder == sortOrder &&
        other.enableFavoriteSorting == enableFavoriteSorting &&
        other.addCurrentProgram == addCurrentProgram;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        userId.hashCode ^
        startIndex.hashCode ^
        isSeries.hashCode ^
        isNews.hashCode ^
        isKids.hashCode ^
        isSports.hashCode ^
        limit.hashCode ^
        isFavorite.hashCode ^
        isLiked.hashCode ^
        isDisliked.hashCode ^
        enableImages.hashCode ^
        imageTypeLimit.hashCode ^
        enableImageTypes.hashCode ^
        fields.hashCode ^
        enableUserData.hashCode ^
        sortBy.hashCode ^
        sortOrder.hashCode ^
        enableFavoriteSorting.hashCode ^
        addCurrentProgram.hashCode;
  }
}
