import 'package:rxdart/rxdart.dart';

import '../jellyfin/jellyfin.dart';

class ItemDownload {
  final Item item;
  final void Function() cancelToken;
  final BehaviorSubject<int> downloadValueWatcher;

  const ItemDownload({
    required this.item,
    required this.cancelToken,
    required this.downloadValueWatcher,
  });
}
