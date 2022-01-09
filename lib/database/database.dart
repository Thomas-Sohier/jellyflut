// this annotation tells moor to prepare a database class that uses the tables we just defined. (Modes in our case)

import 'dart:io';

import 'package:jellyflut/database/tables/download.dart';
import 'package:jellyflut/database/tables/server.dart';
import 'package:jellyflut/database/tables/setting.dart';
import 'package:jellyflut/database/tables/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(
    tables: [Servers, Users, Settings, Downloads],
    daos: [ServersDao, UsersDao, SettingsDao, DownloadsDao])
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1 && to == 2) {
          // we added the dueDate property in the change from version 1
          await m.createTable(downloads);
          await m.addColumn(settings, settings.downloadPath);
        }
      });
}

@UseDao(tables: [Users])
class UsersDao extends DatabaseAccessor<Database> with _$UsersDaoMixin {
  UsersDao(Database db) : super(db);
  Future<List<User>> get allWatchingUsers => select(users).get();
  Stream<List<User>> get watchAllUsers => select(users).watch();
  Future<User> getUserById(int userId) =>
      (select(users)..where((tbl) => tbl.id.equals(userId))).getSingle();
  Stream<User> watchUserById(int userId) =>
      (select(users)..where((tbl) => tbl.id.equals(userId))).watchSingle();
  Future<int> createUser(UsersCompanion user) => into(users).insert(user);
  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);
  Future<int> deleteUser(UsersCompanion user) => delete(users).delete(user);
}

@UseDao(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Database> with _$SettingsDaoMixin {
  SettingsDao(Database db) : super(db);
  Future<List<Setting>> get allWatchingSettings => select(settings).get();
  Stream<List<Setting>> get watchAllSettings => select(settings).watch();
  Future<Setting> getSettingsById(int settingsId) =>
      (select(settings)..where((tbl) => tbl.id.equals(settingsId))).getSingle();
  Stream<Setting> watchSettingsById(int settingsId) =>
      (select(settings)..where((tbl) => tbl.id.equals(settingsId)))
          .watchSingle();
  Future<int> createSettings(SettingsCompanion setting) =>
      into(settings).insert(setting);
  Future<bool> updateSettings(SettingsCompanion setting) =>
      update(settings).replace(setting);
  Future<int> deleteSettings(SettingsCompanion setting) =>
      delete(settings).delete(setting);
}

@UseDao(tables: [Servers])
class ServersDao extends DatabaseAccessor<Database> with _$ServersDaoMixin {
  ServersDao(Database db) : super(db);
  Future<List<Server>> get allWatchingServers => select(servers).get();
  Stream<List<Server>> get watchAllServers => select(servers).watch();
  Future<Server> getServerById(int serverId) =>
      (select(servers)..where((tbl) => tbl.id.equals(serverId))).getSingle();
  Stream<Server> watchServerById(int serverId) =>
      (select(servers)..where((tbl) => tbl.id.equals(serverId))).watchSingle();
  Future<int> createServer(ServersCompanion server) =>
      into(servers).insert(server);
  Future<bool> updateserver(ServersCompanion server) =>
      update(servers).replace(server);
  Future<int> deleteServer(ServersCompanion server) =>
      delete(servers).delete(server);
}

@UseDao(tables: [Downloads])
class DownloadsDao extends DatabaseAccessor<Database> with _$DownloadsDaoMixin {
  DownloadsDao(Database db) : super(db);
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
