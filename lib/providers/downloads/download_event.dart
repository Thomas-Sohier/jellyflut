import 'package:jellyflut/models/downloads/item_download.dart';
import 'package:jellyflut/providers/downloads/download_event_type.dart';

class DownloadEvent {
  final DownloadEventType eventType;
  final ItemDownload download;

  const DownloadEvent(this.eventType, this.download);
}
