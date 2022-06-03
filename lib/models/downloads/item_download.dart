import 'package:dio/dio.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:rxdart/rxdart.dart';

class ItemDownload {
  final Item item;
  final CancelToken cancelToken;
  final BehaviorSubject<int> downloadValueWatcher;

  const ItemDownload({
    required this.item,
    required this.cancelToken,
    required this.downloadValueWatcher,
  });
}
