import 'package:sqlite_database/sqlite_database.dart';

class DatabaseSetting {
  final int id;
  final String preferredPlayer;
  final String preferredTranscodeAudioCodec;
  final int maxVideoBitrate;
  final int maxAudioBitrate;
  final String? downloadPath;
  final bool directPlay;

  const DatabaseSetting(
      {required this.id,
      required this.preferredPlayer,
      required this.preferredTranscodeAudioCodec,
      required this.maxVideoBitrate,
      required this.maxAudioBitrate,
      this.downloadPath,
      required this.directPlay});

  static DatabaseSetting fromUserApp(Setting setting) {
    return DatabaseSetting(
        id: setting.id,
        preferredPlayer: setting.preferredPlayer,
        preferredTranscodeAudioCodec: setting.preferredTranscodeAudioCodec,
        maxVideoBitrate: setting.maxVideoBitrate,
        maxAudioBitrate: setting.maxAudioBitrate,
        downloadPath: setting.downloadPath,
        directPlay: setting.directPlay);
  }

  /// Empty user which represents an unauthenticated user.
  static const empty = DatabaseSetting(
      directPlay: true,
      id: 0,
      maxAudioBitrate: 0,
      maxVideoBitrate: 0,
      preferredPlayer: '',
      preferredTranscodeAudioCodec: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == DatabaseSetting.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != DatabaseSetting.empty;
}
