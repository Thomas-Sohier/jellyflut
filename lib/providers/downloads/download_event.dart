import 'package:jellyflut/providers/downloads/download_event_type.dart';
import 'package:jellyflut_models/jellyflut_models.dart';

class DownloadEvent {
  final DownloadEventType eventType;
  final ItemDownload download;

  const DownloadEvent(this.eventType, this.download);
}
