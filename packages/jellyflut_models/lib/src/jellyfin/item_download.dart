import 'package:jellyflut_models/src/jellyfin/item.dart';
import 'package:rxdart/rxdart.dart';

class ItemDownload {
  final Item item;
  final void Function() cancel;
  final BehaviorSubject<int> downloadValueWatcher;

  const ItemDownload({
    required this.item,
    required this.cancel,
    required this.downloadValueWatcher,
  });
}
