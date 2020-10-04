import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:jellyflut/models/server.dart';

final tableServer = "server";

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
        db.execute(
          '''CREATE TABLE $tableServer(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url VARCHAR,
            name VARCHAR)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
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
}
