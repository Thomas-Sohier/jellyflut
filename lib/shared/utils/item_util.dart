import 'package:jellyflut_models/jellyflut_models.dart';

class ItemUtil {
  /// Play current item given context
  ///
  /// If Book open Epub reader
  /// If Video open video player
  /// If music play it and show music button
  static Future<void> playItem(Item item) {
    final type = item.type;
    // final context = context.router.root.navigatorKey.currentContext!;
    if (type == ItemType.Episode ||
        type == ItemType.Season ||
        type == ItemType.Series ||
        type == ItemType.Movie ||
        type == ItemType.TvChannel ||
        type == ItemType.Video) {
      // return context.router.root.push(r.StreamPage(item: item));
    } else if (type == ItemType.Audio) {
      // context.read<MusicPlayerBloc>().add(PlaySongRequested(item: item));
      return Future.value();
    } else if (type == ItemType.MusicAlbum) {
      // context.read<MusicPlayerBloc>().add(PlayPlaylistRequested(item: item));
      return Future.value();
    } else if (type == ItemType.Book) {
      // return context.router.root.push(EpubRoute(item: this));
      throw UnimplementedError('Item is not playable (type : $type');
    }
    throw UnimplementedError('Item is not playable (type : $type');
  }
}