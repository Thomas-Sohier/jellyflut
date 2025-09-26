// lib/models/extensions/item_playback_logic.dart

import 'package:jellyflut_models/jellyflut_models.dart';

extension ItemPlaybackLogic on Item {
  /// Vrai si l'item est directement jouable.
  bool get isPlayable {
    const playableTypes = {
      ItemType.Movie,
      ItemType.Episode,
      ItemType.Photo,
      ItemType.Recording,
      ItemType.Video,
      ItemType.MusicVideo,
      ItemType.Audio,
      ItemType.Book,
    };
    return playableTypes.contains(type);
  }

  /// Vrai si l'item peut être téléchargé.
  bool get isDownloadable {
    const downloadableTypes = {
      ItemType.Audio,
      ItemType.MusicAlbum,
      ItemType.MusicVideo,
      ItemType.Movie,
      ItemType.Series,
      ItemType.Season,
      ItemType.Episode,
      ItemType.Book,
      ItemType.Video,
    };
    return downloadableTypes.contains(type);
  }

  /// Durée de l'item en microsecondes. Retourne 0 si non disponible.
  int get durationInMicroseconds => runTimeTicks == null ? 0 : (runTimeTicks! / 10).round();

  /// Position de la dernière lecture en microsecondes.
  int get playbackPositionInMicroseconds => userData == null ? 0 : (userData!.playbackPositionTicks / 10).round();

  /// Pourcentage de lecture de l'item (entre 0.0 et 1.0).
  double get percentPlayed {
    if (userData != null && runTimeTicks != null && runTimeTicks! > 0) {
      return userData!.playbackPositionTicks / runTimeTicks!;
    }
    return 0.0;
  }

  /// Tell if item can be viewed in sense of already played before
  /// Return [yes] if already seen (played)
  /// Else returl [false] if not seen (played)
  bool isViewable() {
    final playableItems = [
      ItemType.Movie,
      ItemType.Series,
      ItemType.Season,
      ItemType.Episode,
      ItemType.Book,
      ItemType.Video,
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
}
