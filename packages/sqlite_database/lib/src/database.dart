// this annotation tells moor to prepare a database class that uses the tables we just defined. (Modes in our case)

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:jellyflut_models/jellyflut_models.dart';
import 'package:sqlite_database/src/migrations/from_3_to_4.dart';
import 'migrations/from_2_to_3.dart';
import 'models/models.dart';
import 'tables/download.dart';
import 'tables/server.dart';
import 'tables/setting.dart';
import 'tables/user.dart';
import 'connection/connection.dart' as impl;

part 'database.g.dart';

// Generate files
// flutter packages pub run build_runner watch

// Delete conflicts
// flutter packages pub run build_runner watch --delete-conflicting-outputs

class AppDatabase {
  final Database _database = Database();

  static final AppDatabase _appDatabase = AppDatabase._internal();

  factory AppDatabase() {
    return _appDatabase;
  }

  AppDatabase._internal();

  Database get getDatabase => _database;
}

@DriftDatabase(
  tables: [Servers, UserApp, Settings, Downloads],
  daos: [ServersDao, UserAppDao, SettingsDao, DownloadsDao],
)
class Database extends _$Database {
  Database() : super(impl.connect().executor);

  Database.forTesting(DatabaseConnection connection) : super(connection.executor);

  // you should bump this number whenever you change or add a table definition
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (m, before, now) async {
        for (var target = before + 1; target <= now; target++) {
          from2to3(this, m, target);
          from3to4(this, m, target);
        }
      });

  Future<Setting> settingsFromUserId(int userId) {
    return (select(settings)
          ..join([innerJoin(userApp, settings.id.equalsExp(userApp.settingsId))]).where(userApp.id.equals(userId)))
        .getSingle();
  }

  Stream<List<ServersWithUsers>> serversWithUsers() {
    final query = (select(servers).join([innerJoin(userApp, servers.id.equalsExp(userApp.serverId))]));

    return query.watch().map((rows) {
      // read both the entry and the associated category for each row
      final results = rows.map((row) {
        return ServersWithUsersDao(server: row.readTable(servers), user: row.readTable(userApp));
      }).toList();

      final listResult = <ServersWithUsers>[];
      final mapResults = groupBy(results.toList(), (ServersWithUsersDao s) => s.server);
      mapResults.forEach((server, swu) {
        final users = swu.map((e) => e.user);
        final s = ServersWithUsers(server: server, users: users.toList());
        listResult.add(s);
      });
      return listResult;
    });
  }
}

@DriftAccessor(tables: [UserApp])
class UserAppDao extends DatabaseAccessor<Database> with _$UserAppDaoMixin {
  UserAppDao(super.db);
  Future<List<UserAppData>> get allWatchingUserApp => select(userApp).get();
  Stream<List<UserAppData>> get watchAllUserApp => select(userApp).watch();
  Future<UserAppData> getUserById(int userId) => (select(userApp)..where((tbl) => tbl.id.equals(userId))).getSingle();
  Future<UserAppData> getUserByJellyfinUserId(String userId) =>
      (select(userApp)..where((tbl) => tbl.jellyfinUserId.equals(userId))).getSingle();
  Future<UserAppData> getUserByNameAndServerId(String username, int serverId) => (select(userApp)
        ..where((tbl) => tbl.name.equals(username))
        ..where((tbl) => tbl.serverId.equals(serverId)))
      .getSingle();
  Future<List<UserAppData>> getUserAppByserverId(int serverId) =>
      (select(userApp)..where((tbl) => tbl.serverId.equals(serverId))).get();
  Stream<List<UserAppData>> watchUserAppByserverId(int serverId) =>
      (select(userApp)..where((tbl) => tbl.serverId.equals(serverId))).watch();
  Stream<UserAppData> watchUserById(int userId) =>
      (select(userApp)..where((tbl) => tbl.id.equals(userId))).watchSingle();
  Future<int> createUser(UserAppCompanion user) => into(userApp).insert(user);
  Future<bool> updateUser(Insertable<UserAppData> user) => update(userApp).replace(user);
  Future<int> deleteUser(UserAppCompanion user) => delete(userApp).delete(user);
}

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Database> with _$SettingsDaoMixin {
  SettingsDao(super.db);
  Future<List<Setting>> get allWatchingSettings => select(settings).get();
  Stream<List<Setting>> get watchAllSettings => select(settings).watch();
  Future<Setting> getSettingsById(int settingsId) =>
      (select(settings)..where((tbl) => tbl.id.equals(settingsId))).getSingle();
  Future<Setting> getSettingsByUserId(int userId) => db.settingsFromUserId(userId);
  Stream<Setting> watchSettingsById(int settingsId) =>
      (select(settings)..where((tbl) => tbl.id.equals(settingsId))).watchSingle();
  Future<int> createSettings(SettingsCompanion setting) =>
      into(settings).insert(setting, mode: InsertMode.insertOrReplace);
  Future<bool> updateSettings(Insertable<Setting> setting) => update(settings).replace(setting);
  Future<int> deleteSettings(SettingsCompanion setting) => delete(settings).delete(setting);
}

@DriftAccessor(tables: [Servers])
class ServersDao extends DatabaseAccessor<Database> with _$ServersDaoMixin {
  ServersDao(super.db);
  Future<List<Server>> get allWatchingServers => select(servers).get();
  Stream<List<Server>> get watchAllServers => select(servers).watch();
  Stream<List<ServersWithUsers>> get watchAllServersWithUserApp => db.serversWithUsers();
  Future<Server> getServerById(int serverId) => (select(servers)..where((tbl) => tbl.id.equals(serverId))).getSingle();
  Stream<Server> watchServerById(int serverId) =>
      (select(servers)..where((tbl) => tbl.id.equals(serverId))).watchSingle();
  Future<Server> getServerByUrl(String url) => (select(servers)..where((tbl) => tbl.url.equals(url))).getSingle();
  Future<int> createServer(ServersCompanion server) => into(servers).insert(server, mode: InsertMode.insertOrReplace);
  Future<bool> updateserver(Insertable<Server> server) => update(servers).replace(server);
  Future<int> deleteServer(ServersCompanion server) => delete(servers).delete(server);
}

@DriftAccessor(tables: [Downloads])
class DownloadsDao extends DatabaseAccessor<Database> with _$DownloadsDaoMixin {
  DownloadsDao(super.db);
  Future<List<Download>> get allWatchingDownloads => select(downloads).get();
  Stream<List<Download>> get watchAllDownloads => select(downloads).watch();
  Future<Download> getDownloadById(String downloadId) =>
      (select(downloads)..where((tbl) => tbl.id.equals(downloadId))).getSingle();
  Stream<Download> watchDownloadById(String downloadId) =>
      (select(downloads)..where((tbl) => tbl.id.equals(downloadId))).watchSingle();
  Future<int> createDownload(DownloadDto downloadDto) {
    assert(downloadDto.path != null && downloadDto.path!.isNotEmpty, 'Download path needs to be set');
    final dc = DownloadsCompanion(
      id: Value(downloadDto.id),
      backdrop: Value(downloadDto.backdrop),
      item: Value(downloadDto.item),
      path: Value(downloadDto.path!),
      primary: Value(downloadDto.primary),
      name: Value(downloadDto.name),
    );
    return into(downloads).insert(dc, mode: InsertMode.insertOrReplace);
  }

  Future<bool> updateDownload(Insertable<Download> download) => update(downloads).replace(download);
  Future<bool> doesExist(String downloadId) async {
    final x = await (select(downloads)..where((tbl) => tbl.id.equals(downloadId))).getSingleOrNull();
    return x != null;
  }

  Future<int> deleteDownloadFromId(String id) => (delete(downloads)..where((tbl) => tbl.id.equals(id))).go();
  Future<int> deleteDownload(DownloadsCompanion download) => delete(downloads).delete(download);
}
