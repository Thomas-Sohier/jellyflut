import 'package:dio/dio.dart';
import 'package:downloads_api/downloads_api.dart';
import 'package:rxdart/rxdart.dart';

class OngoingDownload extends Download {
  final BehaviorSubject<int> stateOfDownload;
  final CancelToken cancelToken;

  const OngoingDownload({
    required super.id,
    super.name,
    required super.path,
    super.primary,
    super.backdrop,
    required super.item,
    required this.stateOfDownload,
    required this.cancelToken,
  });

  /// Stop current download
  stopDownload() => cancelToken.cancel();
}
