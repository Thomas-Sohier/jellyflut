import 'package:sqlite_database/sqlite_database.dart';

class DatabaseUser {
  final int id;
  final String name;
  final String password;
  final String apiKey;
  final String jellyfinUserId;
  final int settingsId;
  final int serverId;

  const DatabaseUser(
      {required this.id,
      required this.name,
      required this.password,
      required this.apiKey,
      required this.jellyfinUserId,
      required this.settingsId,
      required this.serverId});

  static DatabaseUser fromUserApp(UserAppData userAppData) {
    return DatabaseUser(
      id: userAppData.id,
      name: userAppData.name,
      password: userAppData.password,
      apiKey: userAppData.apiKey,
      jellyfinUserId: userAppData.jellyfinUserId,
      settingsId: userAppData.settingsId,
      serverId: userAppData.serverId,
    );
  }
}
