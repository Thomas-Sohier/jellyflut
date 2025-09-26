// lib/models/extensions/item_ui_logic.dart

import 'package:jellyflut_models/jellyflut_models.dart';

extension ItemUILogic on Item {
  /// Vrai si l'item a été créé il y a moins de 3 jours.
  bool get isNew {
    if (dateCreated == null) return false;
    return DateTime.now().difference(dateCreated!).inDays < 3;
  }

  /// Vrai si l'item a été marqué comme lu.
  bool get isPlayed => userData?.played ?? false;

  /// Vrai si l'item est dans les favoris.
  bool get isFavorite => userData?.isFavorite ?? false;

  /// Vrai si l'item a une progression de lecture.
  bool get hasProgress => (userData?.playbackPositionTicks ?? 0) > 0;

  /// Vrai si la liste des genres n'est pas vide.
  bool get hasGenres => genres.isNotEmpty;

  /// Vrai si la liste des artistes n'est pas vide.
  bool get hasArtists => artists.isNotEmpty;

  /// Vrai si le synopsis n'est pas nul ou vide.
  bool get hasOverview => overview?.isNotEmpty ?? false;

  /// Vrai si l'item a une image de type Logo.
  bool get hasLogo => imageTags['Logo']?.isNotEmpty ?? false;

  /// Vrai si l'item a au moins une image de type Backdrop.
  bool get hasBackdrop => backdropImageTags.isNotEmpty;

  /// Vrai si la liste des personnes (acteurs, etc.) n'est pas vide.
  bool get hasPeople => people.isNotEmpty;

  /// Vrai si le titre original est différent du titre localisé (nom).
  bool get hasDifferentOriginalTitle => originalTitle != null && originalTitle!.toLowerCase() != name?.toLowerCase();

  /// Vrai si au moins une note (communauté ou critique) est disponible.
  bool get hasRatings => communityRating != null || criticRating != null;

  /// Vrai si au moins une bande-annonce (locale ou distante) est disponible.
  bool get hasTrailer => remoteTrailers.isNotEmpty || (localTrailerCount ?? 0) > 0;

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

  String concatenateArtists({int? maxArtists}) {
    var max = artists.length;
    if (maxArtists != null) {
      max = artists.length > maxArtists ? maxArtists : artists.length;
    }

    if (artists.isNotEmpty) {
      return artists.getRange(0, max).join(', ').toString();
    }
    return '';
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
    return name ?? '';
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
    if (collectionType == CollectionType.movies) {
      return [ItemType.Movie];
    } else if (collectionType == CollectionType.tvshows) {
      return [ItemType.Series];
    } else if (collectionType == CollectionType.music) {
      return [ItemType.MusicAlbum, ItemType.Audio];
    } else if (collectionType == CollectionType.books) {
      return [ItemType.Book];
    } else if (collectionType == CollectionType.homevideos) {
      return [ItemType.Video];
    } else if (collectionType == CollectionType.boxsets) {
      return [ItemType.BoxSet];
    } else if (collectionType == CollectionType.mixed) {
      return [
        ItemType.Folder,
        ItemType.Audio,
        ItemType.Video,
        ItemType.Book,
        ItemType.MusicAlbum,
        ItemType.Series,
        ItemType.Movie,
      ];
    } else if (collectionType == CollectionType.musicvideos) {
      return [ItemType.MusicVideo];
    } else {
      return [];
    }
  }

  bool hasBackrop() {
    return backdropImageTags.isNotEmpty;
  }

  /// Tell if current item is playable or can contains children which are playable
  /// Return [true] if item or children can be played
  /// Else return [false] if not playable
  bool isPlayableOrCanHavePlayableChilren() {
    final playableItems = [
      ItemType.Audio,
      ItemType.MusicAlbum,
      ItemType.MusicVideo,
      ItemType.TvChannel,
      ItemType.Movie,
      ItemType.Series,
      ItemType.Season,
      ItemType.Episode,
      ItemType.Book,
      ItemType.Video,
    ];
    return playableItems.contains(type);
  }

  /// Tell if current item is playable (not like [isPlayableOrCanHavePlayableChilren()])
  /// Return [true] if item ocan be played
  /// Else return [false] if not playable
  bool isPlayable() {
    final playableItems = [
      ItemType.Movie,
      ItemType.Episode,
      ItemType.Photo,
      ItemType.Recording,
      ItemType.Video,
      ItemType.MusicVideo,
      ItemType.Audio,
      ItemType.Book,
      ItemType.Video,
    ];
    return playableItems.contains(type);
  }

  bool isDownloable() {
    final playableItems = [
      ItemType.Audio,
      ItemType.MusicAlbum,
      ItemType.MusicVideo,
      ItemType.Movie,
      ItemType.Series,
      ItemType.Season,
      ItemType.Episode,
      ItemType.Book,
      ItemType.Video,
    ];
    return playableItems.contains(type);
  }

  bool isCollectionPlayable() {
    final playableItems = [
      CollectionType.books,
      CollectionType.homevideos,
      CollectionType.movies,
      CollectionType.tvshows,
      CollectionType.musicvideos,
      CollectionType.music,
    ];
    return playableItems.contains(collectionType);
  }

  ///Check if original title is different from Localized title
  ///
  /// Return [true] if is different
  /// Return [false] if same
  bool haveDifferentOriginalTitle() {
    return originalTitle != null && originalTitle!.toLowerCase() != name?.toLowerCase();
  }
}
