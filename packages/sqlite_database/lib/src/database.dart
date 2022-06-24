// this annotation tells moor to prepare a database class that uses the tables we just defined. (Modes in our case)

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'class/servers_with_users.dart';
import 'migrations/from_2_to_3.dart';
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
  tables: [Servers, Users, Settings, Downloads],
  daos: [ServersDao, UsersDao, SettingsDao, DownloadsDao],
)
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database() : super.connect(impl.connect());

  Database.forTesting(super.connection) : super.connect();

  // you should bump this number whenever you change or add a table definition
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (m, before, now) async {
        for (var target = before + 1; target <= now; target++) {
          from2to3(this, m, target);
        }
      });

  Future<Setting> settingsFromUserId(int userId) {
    return (select(settings)
          ..join([innerJoin(users, settings.id.equalsExp(users.settingsId))])
              .where(users.id.equals(userId)))
        .getSingle();
  }

  Stream<List<ServersWithUsers>> serversWithUsers() {
    final query = (select(servers)
        .join([innerJoin(users, servers.id.equalsExp(users.serverId))]));

    return query.watch().map((rows) {
      // read both the entry and the associated category for each row
      final results = rows.map((row) {
        return ServersWithUsersDao(
            server: row.readTable(servers), user: row.readTable(users));
      }).toList();

      final listResult = <ServersWithUsers>[];
      final mapResults =
          groupBy(results.toList(), (ServersWithUsersDao s) => s.server);
      mapResults.forEach((server, swu) {
        final users = swu.map((e) => e.user);
        final s = ServersWithUsers(server: server, users: users.toList());
        listResult.add(s);
      });
      return listResult;
    });
  }
}

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<Database> with _$UsersDaoMixin {
  UsersDao(super.db);
  Future<List<User>> get allWatchingUsers => select(users).get();
  Stream<List<User>> get watchAllUsers => select(users).watch();
  Future<User> getUserById(int userId) =>
      (select(users)..where((tbl) => tbl.id.equals(userId))).getSingle();
  Future<User> getUserByNameAndServerId(String username, int serverId) =>
      (select(users)
            ..where((tbl) => tbl.name.equals(username))
            ..where((tbl) => tbl.serverId.equals(serverId)))
          .getSingle();
  Future<List<User>> getUsersByserverId(int serverId) =>
      (select(users)..where((tbl) => tbl.serverId.equals(serverId))).get();
  Stream<List<User>> watchUsersByserverId(int serverId) =>
      (select(users)..where((tbl) => tbl.serverId.equals(serverId))).watch();
  Stream<User> watchUserById(int userId) =>
      (select(users)..where((tbl) => tbl.id.equals(userId))).watchSingle();
  Future<int> createUser(UsersCompanion user) => into(users).insert(user);
  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);
  Future<int> deleteUser(UsersCompanion user) => delete(users).delete(user);
}

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Database> with _$SettingsDaoMixin {
  SettingsDao(super.db);
  Future<List<Setting>> get allWatchingSettings => select(settings).get();
  Stream<List<Setting>> get watchAllSettings => select(settings).watch();
  Future<Setting> getSettingsById(int settingsId) =>
      (select(settings)..where((tbl) => tbl.id.equals(settingsId))).getSingle();
  Future<Setting> getSettingsByUserId(int userId) =>
      db.settingsFromUserId(userId);
  Stream<Setting> watchSettingsById(int settingsId) =>
      (select(settings)..where((tbl) => tbl.id.equals(settingsId)))
          .watchSingle();
  Future<int> createSettings(SettingsCompanion setting) =>
      into(settings).insert(setting, mode: InsertMode.insertOrReplace);
  Future<bool> updateSettings(SettingsCompanion setting) =>
      update(settings).replace(setting);
  Future<int> deleteSettings(SettingsCompanion setting) =>
      delete(settings).delete(setting);
}

@DriftAccessor(tables: [Servers])
class ServersDao extends DatabaseAccessor<Database> with _$ServersDaoMixin {
  ServersDao(super.db);
  Future<List<Server>> get allWatchingServers => select(servers).get();
  Stream<List<Server>> get watchAllServers => select(servers).watch();
  Stream<List<ServersWithUsers>> get watchAllServersWithUsers =>
      db.serversWithUsers();
  Future<Server> getServerById(int serverId) =>
      (select(servers)..where((tbl) => tbl.id.equals(serverId))).getSingle();
  Stream<Server> watchServerById(int serverId) =>
      (select(servers)..where((tbl) => tbl.id.equals(serverId))).watchSingle();
  Future<Server> getServerByUrl(String url) =>
      (select(servers)..where((tbl) => tbl.url.equals(url))).getSingle();
  Future<int> createServer(ServersCompanion server) =>
      into(servers).insert(server, mode: InsertMode.insertOrReplace);
  Future<bool> updateserver(ServersCompanion server) =>
      update(servers).replace(server);
  Future<int> deleteServer(ServersCompanion server) =>
      delete(servers).delete(server);
}

@DriftAccessor(tables: [Downloads])
class DownloadsDao extends DatabaseAccessor<Database> with _$DownloadsDaoMixin {
  DownloadsDao(super.db);
  Future<List<Download>> get allWatchingDownloads => select(downloads).get();
  Stream<List<Download>> get watchAllDownloads => select(downloads).watch();
  Future<Download> getDownloadById(String downloadId) =>
      (select(downloads)..where((tbl) => tbl.id.equals(downloadId)))
          .getSingle();
  Stream<Download> watchDownloadById(String downloadId) =>
      (select(downloads)..where((tbl) => tbl.id.equals(downloadId)))
          .watchSingle();
  Future<int> createDownload(DownloadsCompanion download) =>
      into(downloads).insert(download, mode: InsertMode.insertOrReplace);
  Future<bool> updateDownload(DownloadsCompanion download) =>
      update(downloads).replace(download);
  Future<bool> doesExist(String downloadId) async {
    final x = await (select(downloads)
          ..where((tbl) => tbl.id.equals(downloadId)))
        .getSingleOrNull();
    return x != null;
  }

  Future<int> deleteDownload(DownloadsCompanion download) =>
      delete(downloads).delete(download);
}
