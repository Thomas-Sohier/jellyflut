import 'dart:async';
import 'dart:io';
import 'package:jellyflut/models/settingsDB.dart';
import 'package:jellyflut/models/userDB.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jellyflut/models/server.dart';

final tableServer = 'server';
final tableUser = 'user';
final tableSettings = 'settings';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Future<Database> database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal() {
    initDatabase();
  }

  /// delete the db, create the folder and returnes its path
  Future<String> initDb(String dbName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);

    // Make sure the directory exists
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}
    return path;
  }

  void initDatabase() async {
    database = openDatabase(
      await initDb('jellyflut.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        db.execute('''CREATE TABLE $tableServer(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url VARCHAR,
            name VARCHAR);
          ''');
        db.execute('''CREATE TABLE $tableUser(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            settingsId INTEGER,
            serverId INTEGER,
            name VARCHAR,
            apiKey VARCHAR);
          ''');
        db.execute('''CREATE TABLE $tableSettings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            preferredPlayer VARCHAR DEFAULT 'exoplayer',
            maxVideoBitrate INTEGER DEFAULT 140000000,
            preferredTranscodeAudioCodec VARCHAR DEFAULT 'auto',
            maxAudioBitrate INTEGER DEFAULT 320000);
          ''');
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 6,

      // V1 : add Server & User table
      // V2 : edit table Server, added apiKey
      // V3 : add Settings table
      // V4 : add default value to Settings table
      // V5 : add new settings
      // V6 : add link user to settings
    );
  }

  Future<int> insertServer(Server server) async {
    var db = await database;
    var id = await db.insert(tableServer, server.toMap());
    return id;
  }

  Future<Server> getServer(int id) async {
    var db = await database;
    List<Map> datas =
        await db.query(tableServer, where: 'id = ?', whereArgs: [id]);
    if (datas.isNotEmpty) {
      return Server.fromMap(datas.first);
    }
    return null;
  }

  Future<int> insertUser(UserDB userDB) async {
    var db = await database;
    var id = await db.insert(tableUser, userDB.toMap());
    return id;
  }

  Future<UserDB> getUser(int id) async {
    var db = await database;
    List<Map> datas =
        await db.query(tableUser, where: 'id = ?', whereArgs: [id]);
    if (datas.isNotEmpty) {
      return UserDB.fromMap(datas.first);
    }
    return null;
  }

  Future<int> insertSettings(SettingsDB settingsDB) async {
    var db = await database;
    var id = await db.insert(tableSettings, settingsDB.toMapDB(),
        nullColumnHack: 'id');
    return id;
  }

  Future<int> updateSettings(SettingsDB settingsDB) async {
    var db = await database;
    var id = await db.update(tableSettings, settingsDB.toMap(),
        where: 'id = ?', whereArgs: [settingsDB.id]);
    return id;
  }

  Future<SettingsDB> getSettings(int id) async {
    var db = await database;
    List<Map> datas =
        await db.query(tableSettings, where: 'id = ?', whereArgs: [id]);
    if (datas.isNotEmpty) {
      return SettingsDB.fromMap(datas.first);
    }
    return null;
  }
}
