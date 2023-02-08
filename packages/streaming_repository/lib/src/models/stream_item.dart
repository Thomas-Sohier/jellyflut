import 'package:jellyflut_models/jellyflut_models.dart';

class StreamItem {
  final String url;
  final PlayBackInfos? playbackInfos;
  final Item item;

  const StreamItem({required this.url, this.playbackInfos, required this.item});

  static const empty = StreamItem(url: '', playbackInfos: null, item: Item.empty);

  /// Convenience getter to determine whether the current stream item is empty.
  bool get isEmpty => this == StreamItem.empty;

  /// Convenience getter to determine whether the current stream item is not empty.
  bool get isNotEmpty => this != StreamItem.empty;
}
