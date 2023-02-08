import 'package:authentication_repository/authentication_repository.dart';
import 'package:settings_repository/src/models/database_setting_dto.dart';
import 'package:settings_repository/src/models/database_setting.dart';
import 'package:settings_repository/src/models/database_user.dart';
import 'package:settings_repository/src/models/database_user_dto.dart';
import 'package:sqlite_database/sqlite_database.dart';

/// {@template settings_repository}
/// A repository that handles settings related requests
/// {@endtemplate}
class SettingsRepository {
  /// {@macro settings_repository}
  const SettingsRepository({required AuthenticationRepository authenticationRepository, required Database database})
      : _database = database,
        _authenticationRepository = authenticationRepository;

  final Database _database;
  final AuthenticationRepository _authenticationRepository;

  String get currentUserId => _authenticationRepository.currentUser.id;

  Future<DatabaseUser> getCurrentUser() async {
    final userAppData = await _database.userAppDao.getUserByJellyfinUserId(currentUserId);
    return DatabaseUser.fromUserApp(userAppData);
  }

  Future<bool> updateCurrentUser(DatabaseUserDto databaseUser) async {
    final userAppData = await _database.userAppDao.getUserByJellyfinUserId(currentUserId);
    final updatedUser = userAppData.copyWith(
      id: databaseUser.id,
      name: databaseUser.name,
      password: databaseUser.password,
      apiKey: databaseUser.apiKey,
      jellyfinUserId: databaseUser.jellyfinUserId,
      settingsId: databaseUser.settingsId,
      serverId: databaseUser.serverId,
    );
    return _database.userAppDao.updateUser(updatedUser);
  }

  Future<DatabaseSetting> getcurrentSettings() async {
    final userAppData = await _database.userAppDao.getUserByJellyfinUserId(currentUserId);
    final settings = await _database.settingsDao.getSettingsByUserId(userAppData.id);
    return DatabaseSetting.fromUserApp(settings);
  }

  Future<bool> updateCurrentSettings(DatabaseSettingDto databaseSetting) async {
    final userAppData = await _database.userAppDao.getUserByJellyfinUserId(currentUserId);
    final settings = await _database.settingsDao.getSettingsByUserId(userAppData.id);
    final updatedSettings = settings.copyWith(
      id: databaseSetting.id,
      preferredPlayer: databaseSetting.preferredPlayer,
      preferredTranscodeAudioCodec: databaseSetting.preferredTranscodeAudioCodec,
      maxVideoBitrate: databaseSetting.maxVideoBitrate,
      maxAudioBitrate: databaseSetting.maxAudioBitrate,
      downloadPath: databaseSetting.downloadPath,
      directPlay: databaseSetting.directPlay,
    );
    return _database.settingsDao.updateSettings(updatedSettings);
  }

  Future<DatabaseSetting> getCurrentServer() async {
    final userAppData = await _database.userAppDao.getUserByJellyfinUserId(currentUserId);
    final settings = await _database.settingsDao.getSettingsByUserId(userAppData.id);
    return DatabaseSetting.fromUserApp(settings);
  }

  Future<bool> updateCurrentServer(DatabaseSettingDto databaseSetting) async {
    final userAppData = await _database.userAppDao.getUserByJellyfinUserId(currentUserId);
    final server = await _database.serversDao.getServerById(userAppData.serverId);
    final updatedServer = server.copyWith(
      id: server.id,
      url: server.url,
      name: server.name,
    );
    return _database.serversDao.updateserver(updatedServer);
  }
}
