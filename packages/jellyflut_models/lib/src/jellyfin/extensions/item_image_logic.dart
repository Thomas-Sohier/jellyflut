// lib/models/extensions/item_image_logic.dart

import 'package:jellyflut_models/jellyflut_models.dart';

extension ItemImageLogic on Item {
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
      return typeAspectRatio(type: type);
    }
    return typeAspectRatio(type: type);
  }

  double parentAspectRatio({ItemType? type}) {
    if (type == ItemType.MusicAlbum || type == ItemType.Audio) {
      return 1 / 1;
    } else if (type == ItemType.Photo) {
      return 4 / 3;
    } else if (type == ItemType.Episode) {
      return 2 / 3;
    } else if (type == ItemType.TvChannel || type == ItemType.TvProgram) {
      return 16 / 9;
    }
    return 2 / 3;
  }

  double typeAspectRatio({ItemType? type}) {
    if (type == ItemType.MusicAlbum || type == ItemType.Audio) {
      return 1 / 1;
    } else if (type == ItemType.Photo) {
      return 4 / 3;
    } else if (type == ItemType.Episode) {
      return 16 / 9;
    } else if (type == ItemType.TvChannel || type == ItemType.TvProgram) {
      return 16 / 9;
    }
    return 2 / 3;
  }

  /// Get id or parentid if primary image is not defined
  ///
  /// Return [String]
  ///
  /// Return id if type do not have parent
  /// Return parent id if there is no primary image set
  String getIdBasedOnImage() {
    if (type == ItemType.Season) {
      if (imageTags.isEmpty) return id;
      return seasonId ?? id;
    }
    return id;
  }

  /// Get correct image id based on searchType
  ///
  /// Return [String]
  ///
  /// Return id as [String] if found
  /// Else return item's id as [String]
  String correctImageId({ImageType searchType = ImageType.Primary}) {
    // If of type logo we return only parent logo
    if (searchType == ImageType.Logo) {
      switch (type) {
        case ItemType.Season:
        case ItemType.Episode:
          return seriesId ?? id;
        case ItemType.MusicAlbum:
          return albumId ?? id;
        default:
          return id;
      }
    }
    switch (type) {
      case ItemType.Episode:
        return id;
      case ItemType.Season:
        return seriesId ?? id;
      case ItemType.MusicAlbum:
      case ItemType.Audio:
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
  String? correctImageTags({ImageType searchType = ImageType.Primary}) {
    // If of type logo we return only parent logo
    if (searchType == ImageType.Logo) {
      switch (type) {
        case ItemType.Season:
        case ItemType.Episode:
        case ItemType.Series:
          return seriesPrimaryImageTag;
        case ItemType.MusicAlbum:
          return albumPrimaryImageTag;
        default:
          return null;
      }
    } else if (imageTags.isNotEmpty) {
      switch (type) {
        case ItemType.Season:
          return seriesPrimaryImageTag;
        case ItemType.MusicAlbum:
        case ItemType.Audio:
          return albumPrimaryImageTag;
        default:
          return getImageTagBySearchType(searchType: searchType);
      }
    }
    return null;
  }

  String? getImageTagBySearchType({ImageType searchType = ImageType.Primary}) {
    return imageTags.isNotEmpty ? imageTags[searchType] : null;
  }

  /// Get correct image tags based on searchType
  ///
  /// Return [String]
  ///
  /// Return imageTag as [String] if found
  /// Else return [null]
  ImageType correctImageType({ImageType searchType = ImageType.Primary}) {
    // If we search correct image type for a logo that do not exist we still
    //return a logo tag and not a primary one as backup (or it will be ugly)
    late final backupSearchType;
    if (searchType == ImageType.Logo) {
      backupSearchType = ImageType.Logo;
    } else {
      backupSearchType = ImageType.Primary;
    }

    // If of type logo we return only parent logo
    if (searchType == ImageType.Backdrop && backdropImageTags.isNotEmpty) {
      return searchType;
    } else if (imageTags.isNotEmpty) {
      return getImageTypeBySearchTypeOrBackup(searchType: searchType, backupSearchType: backupSearchType);
    }
    return searchType;
  }

  ImageType getImageTypeBySearchTypeOrBackup({
    ImageType searchType = ImageType.Primary,
    required ImageType backupSearchType,
  }) {
    if (imageTags.containsKey(searchType)) {
      return searchType;
    }
    return backupSearchType;
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

  /// Get item aspect ratio
  ///
  /// Return aspect ratio from video as [double] value
  /// If not specified return [16/9] as default value
  double getAspectRatio() {
    MediaStream mediaStream;
    if (mediaStreams.isNotEmpty && mediaStreams.isNotEmpty) {
      mediaStream = mediaStreams.firstWhere((element) => element.type == MediaStreamType.Video);

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
    var secondValue = double.parse(aspectRatio.substring(separatorIndex + 1, aspectRatio.length));
    return firstValue / secondValue;
  }
}
