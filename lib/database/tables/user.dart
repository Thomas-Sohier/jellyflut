import 'package:moor/moor.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get apiKey => text()();
  IntColumn get settingsId => integer()();
  IntColumn get serverId => integer()();
}
