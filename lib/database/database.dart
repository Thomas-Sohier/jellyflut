import 'dart:async';
import 'package:jellyflut/models/user.dart';
import 'package:jellyflut/models/userDB.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jellyflut/models/server.dart';

final tableServer = "server";
final tableUser = "user";

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Future<Database> database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal() {
    initDatabase();
  }

  initDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'beautiful_alarm.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        db.execute('''CREATE TABLE $tableServer(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url VARCHAR,
            name VARCHAR);
          ''');
        db.execute('''CREATE TABLE $tableUser(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR,
            apiKey VARCHAR);
          ''');
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );
  }

  Future<int> insertServer(Server server) async {
    Database db = await database;
    int id = await db.insert(tableServer, server.toMap());
    return id;
  }

  Future<Server> getServer(int id) async {
    Database db = await database;
    List<Map> datas =
        await db.query(tableServer, where: 'id = ?', whereArgs: [id]);
    if (datas.length > 0) {
      return Server.fromMap(datas.first);
    }
    return null;
  }

  Future<int> insertUSer(UserDB userDB) async {
    Database db = await database;
    int id = await db.insert(tableUser, userDB.toMap());
    return id;
  }

  Future<User> getUser(int id) async {
    Database db = await database;
    List<Map> datas =
        await db.query(tableUser, where: 'id = ?', whereArgs: [id]);
    if (datas.length > 0) {
      return User.fromMap(datas.first);
    }
    return null;
  }
}
