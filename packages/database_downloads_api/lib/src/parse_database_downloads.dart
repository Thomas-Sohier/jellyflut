import 'package:downloads_api/downloads_api.dart';
import 'package:sqlite_database/sqlite_database.dart' as db;

List<Download> parseDatabaseDownloads(List<db.Download> databaseDownloads) {
  return databaseDownloads.map(parseDatabaseDownload).toList();
}

Download parseDatabaseDownload(db.Download databaseDownload) {
  return Download(
      id: databaseDownload.id,
      name: databaseDownload.name,
      path: databaseDownload.path,
      item: databaseDownload.item!,
      backdrop: databaseDownload.backdrop,
      primary: databaseDownload.primary);
}
