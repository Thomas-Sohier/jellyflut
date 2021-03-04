// this annotation tells moor to prepare a database class that uses the tables we just defined. (Modes in our case)

import 'dart:io';

import 'package:jellyflut/database/tables/server.dart';
import 'package:jellyflut/database/tables/setting.dart';
import 'package:jellyflut/database/tables/user.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

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
    tables: [Servers, Users, Settings],
    daos: [ServersDao, UsersDao, SettingsDao])
class Database extends _$Database {
  // we tell the database where to store the data with this constructor
  Database() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [Servers])
class ServersDao extends DatabaseAccessor<Database> with _$ServersDaoMixin {
  ServersDao(Database db) : super(db);
  Future<List<Server>> get allWatchingServers => select(servers).get();
  Stream<List<Server>> get watchAllServers => select(servers).watch();
  Future<int> createEntry(Server server) => into(servers).insert(server);
  Future<bool> updateEntry(Server server) => update(servers).replace(server);
  Future<int> deleteEntry(Server server) => delete(servers).delete(server);
}

@UseDao(tables: [Users])
class UsersDao extends DatabaseAccessor<Database> with _$UsersDaoMixin {
  UsersDao(Database db) : super(db);
  Future<List<User>> get allWatchingUsers => select(users).get();
  Stream<List<User>> get watchAllUsers => select(users).watch();
  Future<int> createUser(User user) => into(users).insert(user);
  Future<bool> updateUser(User user) => update(users).replace(user);
  Future<int> deleteUser(User user) => delete(users).delete(user);
}

@UseDao(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Database> with _$SettingsDaoMixin {
  SettingsDao(Database db) : super(db);
  Future<List<Setting>> get allWatchingSettings => select(settings).get();
  Stream<List<Setting>> get watchAllSettings => select(settings).watch();
  Future<int> createEntry(Setting setting) => into(settings).insert(setting);
  Future<bool> updateEntry(Setting setting) =>
      update(settings).replace(setting);
  Future<int> deleteEntry(Setting setting) => delete(settings).delete(setting);
}
